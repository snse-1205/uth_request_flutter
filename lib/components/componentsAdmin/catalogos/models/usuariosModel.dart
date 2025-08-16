class Usuario {
  final String uid;
  final String nombre;
  final String apellido;
  final String correo;
  final String rol;

  Usuario({
    required this.uid,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.rol,
  });

  factory Usuario.fromMap(String id, Map<String, dynamic> data) {
    return Usuario(
      uid: id,
      nombre: data['nombre'] ?? '',
      apellido: data['apellido'] ?? '',
      correo: data['correo'] ?? '',
      rol: data['rol'] ?? '',
    );
  }
}
