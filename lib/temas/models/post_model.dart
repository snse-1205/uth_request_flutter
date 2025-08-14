class PostModel {
  String id;
  String uid;
  String mensaje;
  String carrera;
  String nombre;
  bool verificado;
  List<String> likes;
  int comentarios;
  bool principal;
  bool comentario;
  String fechaCreacion;
  String tiempo;

  PostModel({
    required this.id,
    required this.uid,
    required this.mensaje,
    required this.carrera,
    required this.nombre,
    required this.verificado,
    required this.likes,
    required this.comentarios,
    required this.principal,
    required this.comentario,
    required this.fechaCreacion,
    required this.tiempo,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'mensaje': mensaje,
      'fechaCreacion': fechaCreacion,
      'likes': likes,
      'comentarios': comentarios,
      'principal': principal,
      'comentario': comentario,
    };
  }

  factory PostModel.fromMap(String id, Map<String, dynamic> map, Map<String, dynamic> userData) {
    return PostModel(
      id: id,
      uid: map['uid'] ?? '',
      mensaje: map['mensaje'] ?? '',
      carrera: userData['carrera'] ?? '',
      nombre: "${userData['nombre'] ?? ''} ${userData['apellido'] ?? ''}",
      verificado: userData['verificado'] ?? false,
      likes: List<String>.from(map['likes'] ?? []),
      comentarios: map['comentarios'] ?? 0,
      principal: map['principal'] ?? true,
      comentario: map['comentario'] ?? false,
      fechaCreacion: map['fechaCreacion'] ?? '',
      tiempo: map['tiempo'] ?? '',
    );
  }
}
