// components/Peticiones/Views/subjectSelectionScreen.dart
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
  static const String studentsCol        = 'estudiantes';     // AJUSTA si tu colección real es 'Estudiantes'
  static const String classesPerCareerCol= 'ClasesPorCarrera';
  static const String fCareers           = 'carrera';         // List<DocumentReference>
  static const String fTaken             = 'clasesCursadas';  // List<DocumentReference> -> /ClasesPorCarrera/{idClase}
  static const String fCareersIn         = 'carreras';        // List<DocumentReference> (en ClasesPorCarrera)
  static const String fRequisito         = 'requisito';       // DocumentReference? -> /Clases/{idReq}
  static const String fClaseRef          = 'clase';           // DocumentReference -> /Clases/{id}  *** AQUI ESTA EL NOMBRE ***
  // static const String fNombre         = 'nombre';          // (NO existe directo en ClasesPorCarrera)

  @override
  void initState() {
    super.initState();
    final storage = GetStorage();
    final cuenta = (storage.read('cuenta') ?? '').toString().trim();
    _future = _loadAvailableClassesByCuenta(cuenta);
  }

  Iterable<List<T>> _chunks<T>(List<T> list, int size) sync* {
    for (var i = 0; i < list.length; i += size) {
      yield list.sublist(i, i + size > list.length ? list.length : i + size);
    }
  }

  Future<List<_ClaseOption>> _loadAvailableClassesByCuenta(String cuenta) async {
    if (cuenta.isEmpty) {
      throw 'No se encontró la cuenta del estudiante en el almacenamiento.';
    }

    final db = FirebaseFirestore.instance;

    // 1) Estudiante por campo "cuenta"
    final stuSnap = await db
        .collection(studentsCol)
        .where('cuenta', isEqualTo: cuenta)
        .limit(1)
        .get();

    if (stuSnap.docs.isEmpty) return [];

    final sdata = stuSnap.docs.first.data();
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

    // 2) Traer ClasesPorCarrera para las carreras del estudiante
    final allDocs = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
    for (final ch in _chunks(careerRefs, 10)) {
      final snap = await db
          .collection(classesPerCareerCol)
          .where(fCareersIn, arrayContainsAny: ch)
          .get();
      allDocs.addAll(snap.docs);
    }

    // 2.1 Reunir todos los DocumentReference a /Clases/{id} para resolver nombres en un solo batch
    final claseRefs = <DocumentReference>{};
    for (final d in allDocs) {
      final data = d.data();
      final ref = data[fClaseRef];
      if (ref is DocumentReference) {
        claseRefs.add(ref);
      }
    }

    // Resolver nombres de /Clases/{id}
    final nombreByRefPath = <String, String>{};
    await Future.wait(claseRefs.map((ref) async {
      try {
        final doc = await ref.get();
        final nombre = (doc.data() as Map<String, dynamic>?)?['nombre']?.toString();
        nombreByRefPath[ref.path] = nombre ?? ref.id; // fallback a id si no hay nombre
      } catch (_) {
        nombreByRefPath[ref.path] = ref.id;
      }
    }));

    // 3) Filtrado: no cursadas + requisito cumplido (o sin requisito)
    final out = <_ClaseOption>[];
    for (final d in allDocs) {
      final data = d.data();
      final classId = d.id; // *** ESTE es el CÓDIGO que vas a guardar en la petición ***

      if (takenIds.contains(classId)) continue;

      // nombre desde la ref /Clases/{id}
      String nombre = classId; // fallback
      final claseRef = data[fClaseRef];
      if (claseRef is DocumentReference) {
        nombre = nombreByRefPath[claseRef.path] ?? claseRef.id;
      }

      final reqRef = data[fRequisito];

      if (reqRef == null) {
        out.add(_ClaseOption(id: classId, nombre: nombre));
        continue;
      }
      if (reqRef is DocumentReference) {
        if (takenIds.contains(reqRef.id)) {
          out.add(_ClaseOption(id: classId, nombre: nombre));
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
            return const Center(
              child: Text('No hay clases disponibles para solicitar.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: options.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final item = options[i];
              return Card(
                color: AppColors.onSurface,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(item.nombre, style: const TextStyle(color: Colors.black)),
                  subtitle: Text(item.id, style: const TextStyle(color: Colors.black54)),
                  // devolvemos {codigo, nombre}
                  onTap: () => Navigator.pop<Map<String, String>>(
                    context,
                    {'id': item.id, 'nombre': item.nombre},
                  ),
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
