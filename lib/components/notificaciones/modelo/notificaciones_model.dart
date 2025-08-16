class NotificacionesModel {
  final String titulo;
  final String mensaje;
  final String fecha;

  NotificacionesModel({
    required this.titulo,
    required this.mensaje,
    required this.fecha,
  });

  factory NotificacionesModel.fromMap(Map<String, dynamic> map) {
    return NotificacionesModel(
      titulo: map['titulo'] ?? '',
      mensaje: map['contenido'] ?? '',
      fecha: map['fecha'] != null
          ? map['fecha'].toString() // Si es Timestamp se convierte a String
          : '',
    );
  }

  factory NotificacionesModel.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return NotificacionesModel(
      titulo: data['titulo'] ?? '',
      mensaje: data['contenido'] ?? '',
      fecha: data['fecha'] != null ? data['fecha'].toString() : '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'contenido': mensaje,
      'fecha': fecha,
    };
  }
}
