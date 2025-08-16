import 'package:cloud_firestore/cloud_firestore.dart';

class EstudianteModel {
  final String nombre;
  final String apellido;
  final String correo;
  final DocumentReference? campus;                // referencia
  final List<DocumentReference> carrera;         // array de referencias
  final List<DocumentReference>? clasesCursadas; // array de referencias opcional
  final String cuenta;
  final String rol;

  EstudianteModel({
    required this.nombre,
    required this.apellido,
    required this.correo,
    this.campus,
    required this.carrera,
    this.clasesCursadas,
    required this.cuenta,
    required this.rol,
  });

  factory EstudianteModel.fromMap(Map<String, dynamic> map) {
    return EstudianteModel(
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      correo: map['correo'] ?? '',
      campus: map['campus'] as DocumentReference,
      carrera: (map['carrera'] as List)
          .map((e) => e as DocumentReference)
          .toList(),
      clasesCursadas: map['clasesCursadas'] != null
          ? (map['clasesCursadas'] as List)
              .map((e) => e as DocumentReference)
              .toList()
          : null,
      cuenta: map['cuenta'] ?? '',
      rol: map['rol'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'campus': campus,
      'carrera': carrera,
      'clasesCursadas': clasesCursadas ?? [],
      'cuenta': cuenta,
      'rol': rol,
    };
  }
}
