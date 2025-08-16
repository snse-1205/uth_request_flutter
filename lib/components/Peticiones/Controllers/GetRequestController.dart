import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' show CombineLatestStream;

// Tu modelo (debe exponer PetitionModel.fromSnap)
import 'package:uth_request_flutter_application/components/Peticiones/Models/getRequestModel.dart';

class PeticionesController extends GetxController {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Lista reactiva (opcional si tienes vistas reactivas con GetX)
  var peticiones = <PetitionModel>[].obs;

  /// COMMUNITY
  /// Muestra peticiones en las que los estudiantes pueden participar:
  /// estados: 'aceptada' y 'disponible'
  Stream<List<PetitionModel>> streamPeticiones({String? classId}) {
    Query<Map<String, dynamic>> q = _db
        .collection('peticiones')
        .where('status', whereIn: ['aceptada', 'disponible']);

    if (classId != null && classId.isNotEmpty) {
      q = q.where('classId', isEqualTo: classId);
      // si usas DocumentReference: q = q.where('claseRef', isEqualTo: ref);
    }

    // Si 'fechaLimite' puede ser nulo en algunos docs, considera quitar este orderBy
    // y ordenar en memoria luego del map.
    q = q.orderBy('fechaLimite', descending: false);

    return q.snapshots().map(
      (snap) => snap.docs.map((d) => PetitionModel.fromSnap(d)).toList(),
    );
  }

  /// CONTADOR de acuerdos (uids en el array "acuerdos")
  Stream<int> getAgreeCount(String petitionId) {
    return _db.collection('peticiones').doc(petitionId).snapshots().map((doc) {
      final acuerdos = List<String>.from(doc.data()?['acuerdos'] ?? []);
      return acuerdos.length;
    });
  }

  /// Saber si el usuario actual YA aceptó (está en "acuerdos")
  Stream<bool> hasAgreed(String petitionId) {
    final uid = _auth.currentUser?.uid ?? '';
    return _db.collection('peticiones').doc(petitionId).snapshots().map((doc) {
      final acuerdos = List<String>.from(doc.data()?['acuerdos'] ?? []);
      return uid.isNotEmpty && acuerdos.contains(uid);
    });
  }

  /// Toggle "Estoy de acuerdo" con TRANSACCIÓN.
  /// Si estaba 'aceptada' y se cumple la meta al agregar, cambia a 'disponible'.
  Future<void> toggleAgree(String petitionId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final ref = _db.collection('peticiones').doc(petitionId);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) return;

      final data = snap.data() as Map<String, dynamic>;
      final acuerdos = List<String>.from(data['acuerdos'] ?? []);
      final meta = (data['meta'] ?? 0) as int;
      final status = (data['status'] ?? 'pendiente').toString();

      final yaEsta = acuerdos.contains(uid);
      int nuevo = acuerdos.length;

      if (yaEsta) {
        // Quitar apoyo
        tx.update(ref, {'acuerdos': FieldValue.arrayRemove([uid])});
        nuevo -= 1;

        // Si quisieras revertir 'disponible' -> 'aceptada' al bajar de meta, descomenta:
        // if (status == 'disponible' && nuevo < meta) {
        //   tx.update(ref, {'status': 'aceptada'});
        // }
      } else {
        // Agregar apoyo
        tx.update(ref, {'acuerdos': FieldValue.arrayUnion([uid])});
        nuevo += 1;

        // Promoción automática
        if (status == 'aceptada' && meta > 0 && nuevo >= meta) {
          tx.update(ref, {'status': 'disponible'});
        }
      }
    });
  }

  /// MIS PETICIONES
  /// Combina en tiempo real:
  /// 1) Creé yo (uid == currentUser.uid)
  /// 2) Me uní (acuerdos contiene uid)
  /// Se deduplican por id y se ordenan (aquí por fechaLimite asc; ajusta si prefieres dateCreate).
  Stream<List<PetitionModel>> streamMisPeticiones() {
    final uid = _auth.currentUser?.uid ?? '';
    if (uid.isEmpty) return Stream.value(const <PetitionModel>[]);

    final creadasQ = _db
        .collection('peticiones')
        .where('uid', isEqualTo: uid)
        .orderBy('fechaLimite', descending: false)
        .snapshots()
        .map((s) => s.docs.map((d) => PetitionModel.fromSnap(d)).toList());

    final unidasQ = _db
        .collection('peticiones')
        .where('acuerdos', arrayContains: uid)
        .orderBy('fechaLimite', descending: false)
        .snapshots()
        .map((s) => s.docs.map((d) => PetitionModel.fromSnap(d)).toList());

    // Combina ambos streams y deduplica por id
    return CombineLatestStream.combine2<List<PetitionModel>, List<PetitionModel>, List<PetitionModel>>(
      creadasQ,
      unidasQ,
      (a, b) {
        final byId = <String, PetitionModel>{};
        for (final x in a) byId[x.id] = x;
        for (final x in b) byId[x.id] = x;

        final list = byId.values.toList()
          ..sort((x, y) {
            // Si tu PetitionModel expone fechaLimite como DateTime?:
            final dx = x.fechaLimite ?? DateTime.fromMillisecondsSinceEpoch(0);
            final dy = y.fechaLimite ?? DateTime.fromMillisecondsSinceEpoch(0);
            return dx.compareTo(dy);
          });

        return list;
      },
    );
  }

  // ==== (Opcional) UTILIDADES PARA ADMIN ====

  /// Admin: cambia estado manualmente (pendiente/aceptada/negada/disponible)
  Future<void> adminSetStatus(String petitionId, String newStatus) async {
    await _db.collection('peticiones').doc(petitionId).update({'status': newStatus});
  }

  /// Admin: fija/actualiza meta mínima de estudiantes
  Future<void> adminSetMeta(String petitionId, int meta) async {
    await _db.collection('peticiones').doc(petitionId).update({'meta': meta});
  }
}
