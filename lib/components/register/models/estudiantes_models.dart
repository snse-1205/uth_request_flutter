class EstudianteModel {
  final String nombre;
  final String apellido;
  final String correo;
  final String campus;
  final String carrera;
  final String cuenta;

  EstudianteModel({
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.campus,
    required this.carrera,
    required this.cuenta,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'campus': campus,
      'carrera': carrera,
      'cuenta': cuenta,
    };
  }
}
