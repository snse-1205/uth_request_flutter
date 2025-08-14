import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/models/campusModel.dart';

class CampusController {
  final FirebaseFirestore _db;
  CampusController({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  /// Stream de todos los campus ordenados por fecha de creación (desc).
  Stream<List<CampusModel>> streamAll() {
    final query = _db.collection('Campus').orderBy('dateCreate', descending: true);
    return query.snapshots().map(
      (snap) => snap.docs
          .map((d) => CampusModel.fromDoc(d as DocumentSnapshot<Map<String, dynamic>>))
          .toList(),
    );
  }

  /// Crear campus (doc id = nombre). Devuelve true si creó, false si ya existía.
  Future<bool> create(String nombre) async {
    final id = nombre.trim();
    if (id.isEmpty) throw ArgumentError('Nombre vacío');

    return _db.runTransaction<bool>((tx) async {
      final ref = _db.collection('Campus').doc(id);
      final snap = await tx.get(ref);
      if (snap.exists) return false;

      tx.set(ref, {'dateCreate': FieldValue.serverTimestamp()});
      return true;
    });
  }

  /// Eliminar campus por id (opcional, por si lo necesitas).
  Future<void> delete(String id) async {
    await _db.collection('Campus').doc(id).delete();
  }

  /// Renombrar (crea nuevo doc y borra el anterior) – opcional.
  Future<void> rename({required String oldId, required String newId}) async {
    if (newId.trim().isEmpty) throw ArgumentError('Nuevo nombre vacío');
    await _db.runTransaction((tx) async {
      final oldRef = _db.collection('Campus').doc(oldId);
      final oldSnap = await tx.get(oldRef);
      if (!oldSnap.exists) return;

      final newRef = _db.collection('Campus').doc(newId.trim());
      final newSnap = await tx.get(newRef);
      if (newSnap.exists) {
        throw StateError('Ya existe un campus con ese nombre');
      }

      tx.set(newRef, oldSnap.data()!);
      tx.delete(oldRef);
    });
  }
}
