class CommentModel {
  String id;
  String uid;
  String postId;
  String nombre;
  bool verificado;
  String mensaje;
  String fechaCreacion;

  CommentModel({
    required this.id,
    required this.uid,
    required this.postId,
    required this.nombre,
    required this.verificado,
    required this.mensaje,
    required this.fechaCreacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'postId': postId,
      'mensaje': mensaje,
      'fechaCreacion': fechaCreacion,
    };
  }

  factory CommentModel.fromMap(String id, Map<String, dynamic> map, Map<String, dynamic> userData) {
    return CommentModel(
      id: id,
      uid: map['uid'] ?? '',
      postId: map['postId'] ?? '',
      nombre: "${userData['nombre'] ?? ''} ${userData['apellido'] ?? ''}",
      verificado: userData['verificado'] ?? false,
      mensaje: map['mensaje'] ?? '',
      fechaCreacion: map['fechaCreacion'] ?? '',
    );
  }
}