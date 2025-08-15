import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uth_request_flutter_application/components/Peticiones/Models/createRequestModel.dart';

class ClassRequestController {
  final _db = FirebaseFirestore.instance;

  // Nombres de colecciones según tu estructura
  static const String studentsCol = 'Estudiantes';
  static const String classesPerCareerCol = 'ClasesPorCarrera';
  static const String requestsCol = 'Peticiones'; // cámbialo si usas otro nombre

  // Campos en Estudiantes
  static const String fCareers = 'carrera';       // List<DocumentReference>
  static const String fTaken   = 'clasesCursadas';// List<DocumentReference> -> /ClasesPorCarrera/{idClase}

  // Campos en ClasesPorCarrera
  static const String fName      = 'nombre';      // String
  static const String fCareersIn = 'carreras';    // List<DocumentReference>
  static const String fRequisito = 'requisito';   // DocumentReference? -> /Clases/{idClaseReq}

  // ---------- Helpers ----------
  Iterable<List<T>> _chunks<T>(List<T> list, int size) sync* {
    for (var i = 0; i < list.length; i += size) {
      yield list.sublist(i, i + size > list.length ? list.length : i + size);
    }
  }

  Future<({
    List<DocumentReference> careerRefs,
    Set<String> takenClassIds,
  })> _getStudentMeta(String studentDocId) async {
    final doc = await _db.collection(studentsCol).doc(studentDocId).get();
    if (!doc.exists) {
      return (careerRefs: <DocumentReference>[], takenClassIds: <String>{});
    }
    final data = doc.data()!;
    final careers = (data[fCareers] as List?)
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

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _getClassesForCareers(
      List<DocumentReference> careerRefs) async {
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

  // ---------- API para la Vista ----------
  /// Devuelve clases disponibles para el estudiante (filtradas por cursadas/prerrequisito).
  Future<List<ClaseItem>> fetchAvailableClasses(String studentDocId) async {
    final meta = await _getStudentMeta(studentDocId);
    final careerRefs = meta.careerRefs;
    final takenIds   = meta.takenClassIds;

    final raw = await _getClassesForCareers(careerRefs);

    final available = <ClaseItem>[];

    for (final d in raw) {
      final data = d.data();
      final classId = d.id; // == id de la clase
      if (takenIds.contains(classId)) continue; // ya cursada, excluir

      final reqRef = data[fRequisito];

      // Exenta (sin requisito)
      if (reqRef == null) {
        available.add(
          ClaseItem(
            id: classId,
            nombre: (data[fName] ?? '').toString(),
            requisitoRef: null,
          ),
        );
        continue;
      }

      if (reqRef is! DocumentReference) continue; // inconsistente

      // Con requisito: mostrar solo si el id del requisito está en cursadas
      final reqClassId = reqRef.id; // /Clases/{idReq}
      if (takenIds.contains(reqClassId)) {
        available.add(
          ClaseItem(
            id: classId,
            nombre: (data[fName] ?? '').toString(),
            requisitoRef: reqRef,
          ),
        );
      }
    }

    available.sort((a, b) => a.nombre.compareTo(b.nombre));
    return available;
  }

  /// Crea la petición en Firestore.
  Future<void> createRequest(PeticionCreate payload) async {
    await _db.collection(requestsCol).add(payload.toMap());
  }
}
