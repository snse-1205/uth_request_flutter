import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

// Si usas PeticionCreate en createRequest
import 'package:uth_request_flutter_application/components/Peticiones/Models/createRequestModel.dart';

/// ====== Modelo ======
class PetitionModel {
  final String id;
  final String uid;
  final String classId;
  final String tipo;
  final String modalidad;
  final String dia;
  final String horaInicio;
  final String horaFin;
  final String status; // pendiente | aceptada | negada | disponible
  final int meta;
  final Timestamp? fechaLimite;
  final Timestamp? dateCreate;
  final List<String> acuerdos;

  /// Campos enriquecidos para la UI
  final String?
  nombreClase; // desde /Clases/{id}.nombre vía ref en ClasesPorCarrera
  final String?
  campus; // si existe en ClasesPorCarrera (p.ej. 'campus', 'ubicacion')
  final String? horario; // "HH:mm - HH:mm • <dia>"

  PetitionModel({
    required this.id,
    required this.uid,
    required this.classId,
    required this.tipo,
    required this.modalidad,
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
    required this.status,
    required this.meta,
    required this.fechaLimite,
    required this.dateCreate,
    required this.acuerdos,
    this.nombreClase,
    this.campus,
    this.horario,
  });

  factory PetitionModel.fromSnap(DocumentSnapshot<Map<String, dynamic>> d) {
    final data = d.data() ?? {};
    return PetitionModel(
      id: d.id,
      uid: (data['uid'] ?? '') as String,
      classId: (data['classId'] ?? '') as String,
      tipo: (data['tipo'] ?? '').toString(),
      modalidad: (data['modalidad'] ?? '').toString(),
      dia: (data['dia'] ?? '').toString(),
      horaInicio: (data['horaInicio'] ?? '00:00').toString(),
      horaFin: (data['horaFin'] ?? '00:00').toString(),
      status: (data['status'] ?? 'pendiente').toString(),
      meta: (data['meta'] ?? 0) as int,
      fechaLimite: data['fechaLimite'] is Timestamp
          ? data['fechaLimite'] as Timestamp
          : null,
      dateCreate: data['dateCreate'] is Timestamp
          ? data['dateCreate'] as Timestamp
          : null,
      acuerdos: List<String>.from(data['acuerdos'] ?? const <String>[]),
    );
  }

  PetitionModel copyWith({
    String? nombreClase,
    String? campus,
    String? horario,
  }) {
    return PetitionModel(
      id: id,
      uid: uid,
      classId: classId,
      tipo: tipo,
      modalidad: modalidad,
      dia: dia,
      horaInicio: horaInicio,
      horaFin: horaFin,
      status: status,
      meta: meta,
      fechaLimite: fechaLimite,
      dateCreate: dateCreate,
      acuerdos: acuerdos,
      nombreClase: nombreClase ?? this.nombreClase,
      campus: campus ?? this.campus,
      horario: horario ?? this.horario,
    );
  }
}

/// ====== Controller ======
class ClassRequestController extends GetxController {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Colecciones
  static const String studentsCol = 'Estudiantes';
  static const String classesPerCareerCol = 'ClasesPorCarrera';
  static const String requestsCol = 'peticiones';

  // Campos Estudiantes
  static const String fCareers = 'carrera'; // List<DocumentReference>
  static const String fTaken = 'clasesCursadas'; // List<DocumentReference>

  // Campos ClasesPorCarrera
  static const String fCareersIn = 'carreras';
  static const String fRequisito = 'requisito';
  static const String fClaseRef = 'clase'; // DocumentReference -> /Clases/{id}
  // campos opcionales que podrías tener en ClasesPorCarrera:
  static const String fCampus = 'campus'; // String? (o 'ubicacionCampus')

  Iterable<List<T>> _chunks<T>(List<T> list, int size) sync* {
    for (var i = 0; i < list.length; i += size) {
      yield list.sublist(i, (i + size > list.length) ? list.length : i + size);
    }
  }

  Future<({List<DocumentReference> careerRefs, Set<String> takenClassIds})>
  _getStudentMeta(String studentDocId) async {
    final doc = await _db.collection(studentsCol).doc(studentDocId).get();
    if (!doc.exists) {
      return (careerRefs: <DocumentReference>[], takenClassIds: <String>{});
    }
    final data = doc.data()!;
    final careers =
        (data[fCareers] as List?)
            ?.where((e) => e is DocumentReference)
            .cast<DocumentReference>()
            .toList() ??
        <DocumentReference>[];

    final takenIds = ((data[fTaken] as List?) ?? [])
        .where((e) => e is DocumentReference)
        .map((e) => (e as DocumentReference).id)
        .toSet();

    return (careerRefs: careers, takenClassIds: takenIds);
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  _getClassesForCareers(List<DocumentReference> careerRefs) async {
    if (careerRefs.isEmpty) return [];
    final out = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
    for (final chunk in _chunks(careerRefs, 10)) {
      final snap = await _db
          .collection(classesPerCareerCol)
          .where(fCareersIn, arrayContainsAny: chunk)
          .get();
      out.addAll(snap.docs);
    }
    return out;
  }

  /// --------- API: Clases disponibles (si la sigues usando en otra pantalla) ---------
  Future<List<ClaseItem>> fetchAvailableClasses(String studentDocId) async {
    final meta = await _getStudentMeta(studentDocId);
    final careerRefs = meta.careerRefs;
    final takenIds = meta.takenClassIds;

    final raw = await _getClassesForCareers(careerRefs);
    final available = <ClaseItem>[];

    for (final d in raw) {
      final data = d.data();
      final classId = d.id;
      if (takenIds.contains(classId)) continue;

      final reqRef = data[fRequisito];
      // El nombre real está en /Clases (ref fClaseRef). Para esta función
      // podrías resolverlo si quieres, o usar sólo el id.
      final claseRef = data[fClaseRef];
      String nombre = classId;
      if (claseRef is DocumentReference) {
        try {
          final claseDoc = await claseRef.get();
          nombre =
              (claseDoc.data() as Map<String, dynamic>?)?['nombre']
                  ?.toString() ??
              claseRef.id;
        } catch (_) {}
      }

      if (reqRef == null) {
        available.add(
          ClaseItem(id: classId, nombre: nombre, requisitoRef: null),
        );
        continue;
      }
      if (reqRef is! DocumentReference) continue;

      final reqClassId = reqRef.id;
      if (takenIds.contains(reqClassId)) {
        available.add(
          ClaseItem(
            id: classId,
            nombre: nombre,
            requisitoRef: claseRef is DocumentReference ? claseRef : null,
          ),
        );
      }
    }

    available.sort((a, b) => a.nombre.compareTo(b.nombre));
    return available;
  }

  /// ---------- Crear petición ----------
  Future<void> createRequest(PeticionCreate payload) async {
    await _db
        .collection(requestsCol)
        .add(payload.toMap()); // status = 'pendiente'
  }

  /// ---------- Enriquecedor: agrega nombreClase/campus/horario ----------
  Future<List<PetitionModel>> _enrichPetitions(List<PetitionModel> list) async {
    if (list.isEmpty) return list;

    // 1) Traer los docs de ClasesPorCarrera por ids
    final ids = list.map((e) => e.classId).toSet().toList();
    final classDocs = await Future.wait(
      ids.map((id) => _db.collection(classesPerCareerCol).doc(id).get()),
    );

    // 2) Resolver ref a /Clases para nombre + campus si existe en CPC
    final claseRefSet = <DocumentReference>{};
    final campusByClassId = <String, String>{};
    final claseRefByClassId = <String, DocumentReference>{};

    for (final d in classDocs) {
      if (!d.exists) continue;
      final data = d.data() as Map<String, dynamic>;
      final classId = d.id;

      // campus (si existe)
      final c1 = (data[fCampus] ?? data['ubicacionCampus'])?.toString();
      if (c1 != null && c1.isNotEmpty) campusByClassId[classId] = c1;

      // ref a /Clases
      final ref = data[fClaseRef];
      if (ref is DocumentReference) {
        claseRefSet.add(ref);
        claseRefByClassId[classId] = ref;
      }
    }

    // 3) Fetch únicos de /Clases
    final nombreByRefPath = <String, String>{};
    await Future.wait(
      claseRefSet.map((ref) async {
        try {
          final snap = await ref.get();
          final nombre = (snap.data() as Map<String, dynamic>?)?['nombre']
              ?.toString();
          nombreByRefPath[ref.path] = nombre ?? ref.id;
        } catch (_) {
          nombreByRefPath[ref.path] = ref.id;
        }
      }),
    );

    // 4) Construir lista enriquecida
    return list.map((p) {
      final ref = claseRefByClassId[p.classId];
      final nombre = (ref != null)
          ? (nombreByRefPath[ref.path] ?? ref.id)
          : p.classId;
      final campus = campusByClassId[p.classId];

      final horario =
          '${p.horaInicio} - ${p.horaFin}${p.dia.isNotEmpty ? ' • ${p.dia}' : ''}';

      return p.copyWith(
        nombreClase: (nombre.isEmpty) ? null : nombre,
        campus: campus,
        horario: horario,
      );
    }).toList();
  }

  /// Comunidad: mostrar peticiones a las que se pueden unir (aceptada/disponible)
  Stream<List<PetitionModel>> streamPeticionesCommunity({String? classId}) {
    Query<Map<String, dynamic>> q = _db
        .collection(requestsCol)
        .where('status', whereIn: ['aceptada', 'disponible']);

    if (classId != null && classId.isNotEmpty) {
      q = q.where('classId', isEqualTo: classId);
    }

    // Usamos dateCreate para evitar requerir índices extras cuando fechaLimite es null
    q = q.orderBy('dateCreate', descending: true);

    return q
        .snapshots()
        .map((s) => s.docs.map((d) => PetitionModel.fromSnap(d)).toList())
        .asyncMap(_enrichPetitions); // <--- enriquecemos aquí
  }

  /// Mis peticiones: creadas por mí + a las que me uní (cualquier status)
  Stream<List<PetitionModel>> streamMisPeticiones() {
    final uid = _auth.currentUser?.uid ?? '';
    if (uid.isEmpty) return Stream.value(const <PetitionModel>[]);

    final creadasQ = _db
        .collection(requestsCol)
        .where('uid', isEqualTo: uid)
        .orderBy('dateCreate', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => PetitionModel.fromSnap(d)).toList());

    final unidasQ = _db
        .collection(requestsCol)
        .where('acuerdos', arrayContains: uid)
        .orderBy('dateCreate', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => PetitionModel.fromSnap(d)).toList());

    // Merge manual y luego enriquecemos
    final controller = StreamController<List<PetitionModel>>();
    List<PetitionModel>? a;
    List<PetitionModel>? b;

    late final StreamSubscription subA;
    late final StreamSubscription subB;

    Future<void> emit() async {
      if (a == null || b == null) return;
      final byId = <String, PetitionModel>{};
      for (final x in a!) {
        byId[x.id] = x;
      }
      for (final x in b!) {
        byId[x.id] = x;
      }
      var list = byId.values.toList()
        ..sort((x, y) {
          final dx =
              x.dateCreate?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
          final dy =
              y.dateCreate?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
          return dy.compareTo(dx);
        });
      list = await _enrichPetitions(list);
      controller.add(list);
    }

    subA = creadasQ.listen((v) {
      a = v;
      emit();
    }, onError: controller.addError);
    subB = unidasQ.listen((v) {
      b = v;
      emit();
    }, onError: controller.addError);

    controller.onCancel = () async {
      await subA.cancel();
      await subB.cancel();
    };
    return controller.stream;
  }

  /// ¿Cuántos han aceptado?
  Stream<int> getAgreeCount(String petitionId) {
    return _db.collection(requestsCol).doc(petitionId).snapshots().map((doc) {
      final acuerdos = List<String>.from(doc.data()?['acuerdos'] ?? []);
      return acuerdos.length;
    });
  }

  /// ¿El usuario actual ya aceptó?
  Stream<bool> hasAgreed(String petitionId) {
    final uid = _auth.currentUser?.uid ?? '';
    return _db.collection(requestsCol).doc(petitionId).snapshots().map((doc) {
      final acuerdos = List<String>.from(doc.data()?['acuerdos'] ?? []);
      return uid.isNotEmpty && acuerdos.contains(uid);
    });
  }

  /// Toggle “Estoy de acuerdo” con promoción automática a 'disponible'
  Future<void> toggleAgree(String petitionId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final ref = _db.collection(requestsCol).doc(petitionId);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) return;

      final data = snap.data() as Map<String, dynamic>;
      final List<String> acuerdos = List<String>.from(data['acuerdos'] ?? []);
      final int meta = (data['meta'] ?? 0) as int;
      final String status = (data['status'] ?? 'pendiente').toString();

      final yaEsta = acuerdos.contains(uid);
      int nuevo = acuerdos.length;

      if (yaEsta) {
        tx.update(ref, {
          'acuerdos': FieldValue.arrayRemove([uid]),
        });
        nuevo -= 1;
      } else {
        tx.update(ref, {
          'acuerdos': FieldValue.arrayUnion([uid]),
        });
        nuevo += 1;

        if (status == 'aceptada' && meta > 0 && nuevo >= meta) {
          tx.update(ref, {'status': 'disponible'});
        }
      }
    });
  }
  // En ClassRequestController

  Stream<List<PetitionModel>> streamPeticionesPendientesAdmin() {
    // Sólo filtramos por status = pendiente (sin orderBy en Firestore)
    final q = _db
        .collection(requestsCol)
        .where('status', isEqualTo: 'pendiente');

    return q
        .snapshots()
        .map((s) => s.docs.map((d) => PetitionModel.fromSnap(d)).toList())
        .asyncMap(
          _enrichPetitions,
        ) // <- tu método que agrega nombreClase/campus/horario
        .map((list) {
          // Ordenamos en memoria por fecha de creación (más reciente primero)
          list.sort((a, b) {
            final ad =
                a.dateCreate?.toDate() ??
                DateTime.fromMillisecondsSinceEpoch(0);
            final bd =
                b.dateCreate?.toDate() ??
                DateTime.fromMillisecondsSinceEpoch(0);
            return bd.compareTo(ad);
          });
          return list;
        });
  }

  Future<void> updateStatus(String petitionId, String newStatus) async {
  // newStatus ∈ { 'pendiente', 'aceptada', 'negada'/'rechazada', 'disponible' }
  await _db.collection(requestsCol).doc(petitionId).update({
    'status': newStatus,
  });
}

  // ---------- API: Admin ----------
  Future<void> adminSetStatus(String petitionId, String newStatus) async {
    // newStatus ∈ { 'pendiente', 'aceptada', 'negada', 'disponible' }
    await _db.collection(requestsCol).doc(petitionId).update({
      'status': newStatus,
    });
  }
}

/// DTO que usas en selección de asignatura
class ClaseItem {
  final String id;
  final String nombre;
  final DocumentReference? requisitoRef;
  ClaseItem({required this.id, required this.nombre, this.requisitoRef});
}
