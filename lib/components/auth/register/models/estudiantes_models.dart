class EstudianteModel {
  final String nombre;
  final String apellido;
  final String correo;
  final String campus;
  final String carrera;
  final String cuenta;
  final String rol;

  EstudianteModel({
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.campus,
    required this.carrera,
    required this.cuenta,
    required this.rol
  });

  factory EstudianteModel.fromMap(Map<String, dynamic> map) {
    return EstudianteModel(
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      correo: map['correo'] ?? '',
      campus: map['campus'] ?? '',
      carrera: map['carrera'] ?? '',
      cuenta: map['cuenta'] ?? '',
      rol: map['rol'] ?? ''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'campus': campus,
      'carrera': carrera,
      'cuenta': cuenta,
      'rol': rol
    };
  }
}
