import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class SubjectSelectionScreen extends StatefulWidget {
  const SubjectSelectionScreen({super.key});

  @override
  State<SubjectSelectionScreen> createState() => _SubjectSelectionScreenState();
}

class _SubjectSelectionScreenState extends State<SubjectSelectionScreen> {
  late Future<List<_ClaseOption>> _future;

  // Colecciones/campos según tu esquema
  static const String studentsCol = 'estudiantes';
  static const String classesPerCareerCol = 'ClasesPorCarrera';
  static const String fCareers = 'carrera';       // List<DocumentReference>
  static const String fTaken   = 'clasesCursadas';// List<DocumentReference> -> /ClasesPorCarrera/{idClase}
  static const String fCareersIn = 'carreras';    // List<DocumentReference> (en ClasesPorCarrera)
  static const String fRequisito = 'requisito';   // DocumentReference? -> /Clases/{idReq}
  static const String fNombre    = 'nombre';      // String (en ClasesPorCarrera)

  @override
  @override
void initState() {
  super.initState();
  final storage = GetStorage();
  // aquí guardas la cuenta del estudiante
  final cuenta = (storage.read('cuenta') ?? '').toString().trim();
  _future = _loadAvailableClasses(cuenta);
}


  Iterable<List<T>> _chunks<T>(List<T> list, int size) sync* {
    for (var i = 0; i < list.length; i += size) {
      yield list.sublist(i, i + size > list.length ? list.length : i + size);
    }
  }

  Future<List<_ClaseOption>> _loadAvailableClasses(String studentCuenta) async {
  if (studentCuenta.isEmpty) {
    throw 'No se encontró la cuenta del estudiante en el almacenamiento.';
  }

  final db = FirebaseFirestore.instance;

  // 1) Buscar el estudiante por el CAMPO "cuenta", no por id de documento
  final stuSnap = await db
      .collection(studentsCol)
      .where('cuenta', isEqualTo: studentCuenta)
      .limit(1)
      .get();

  if (stuSnap.docs.isEmpty) {
    // no hay estudiante con esa cuenta
    return [];
  }

  final sdata = stuSnap.docs.first.data();

  // Carreras (List<DocumentReference>)
  final careerRefs = (sdata[fCareers] as List?)
          ?.where((e) => e is DocumentReference)
          .cast<DocumentReference>()
          .toList() ??
      <DocumentReference>[];

  // ids de clases cursadas (id de doc en ClasesPorCarrera)
  final takenIds = ((sdata[fTaken] as List?) ?? [])
      .where((e) => e is DocumentReference)
      .map((e) => (e as DocumentReference).id)
      .toSet();

  if (careerRefs.isEmpty) return [];

  // 2) Clases por carrera: arrayContainsAny (máx 10)
  final allDocs = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
  for (final ch in _chunks(careerRefs, 10)) {
    final snap = await db
        .collection(classesPerCareerCol)
        .where(fCareersIn, arrayContainsAny: ch)
        .get();
    allDocs.addAll(snap.docs);
  }

  // 3) Filtrado: no cursadas + requisito cumplido (o sin requisito)
  final out = <_ClaseOption>[];
  for (final d in allDocs) {
    final data = d.data();
    final classId = d.id;

    // excluir si ya cursada
    if (takenIds.contains(classId)) continue;

    final reqRef = data[fRequisito];

    // sin requisito → mostrar
    if (reqRef == null) {
      out.add(_ClaseOption(
        id: classId,
        nombre: (data[fNombre] ?? classId).toString(),
      ));
      continue;
    }

    // con requisito → mostrar solo si el requisito está en takenIds
    if (reqRef is DocumentReference) {
      final reqClassId = reqRef.id; // /Clases/{idReq}
      if (takenIds.contains(reqClassId)) {
        out.add(_ClaseOption(
          id: classId,
          nombre: (data[fNombre] ?? classId).toString(),
        ));
      }
    }
  }

  out.sort((a, b) => a.nombre.compareTo(b.nombre));
  return out;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onBackgroundDefault,
      appBar: AppBar(
        foregroundColor: AppColors.onSurface,
        backgroundColor: AppColors.primary,
        title: const Text('Seleccionar asignatura'),
      ),
      body: FutureBuilder<List<_ClaseOption>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final options = snap.data ?? [];
          if (options.isEmpty) {
            return const Center(child: Text('No hay clases disponibles para solicitar.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: options.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = options[index];
              return Card(
                color: AppColors.onSurface,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    item.nombre,
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    item.id, // muestra el id para claridad
                    style: const TextStyle(color: Colors.black54),
                  ),
                  onTap: () {
                    // devolvemos el id de la clase
                    Navigator.pop(context, item.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ClaseOption {
  final String id;
  final String nombre;
  _ClaseOption({required this.id, required this.nombre});
}