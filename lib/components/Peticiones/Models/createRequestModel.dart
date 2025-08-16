// components/Peticiones/Models/createRequestModel.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PeticionCreate {
  final String uid;
  final String tipo;
  final String claseId;       // código de la clase (doc id en ClasesPorCarrera)
  final String nombreClase;   // nombre legible para mostrar en UI
  final String modalidad;
  final String dia;
  final String horaInicio;
  final String horaFin;
  final int meta;
  final Timestamp dateCreate;

  PeticionCreate({
    required this.uid,
    required this.tipo,
    required this.claseId,
    required this.nombreClase,
    required this.modalidad,
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
    required this.meta,
    required this.dateCreate,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid'        : uid,
      'tipo'       : tipo,
      'classId'    : claseId,
      'nombreClase': nombreClase,       // ← para no volver a buscar
      'modalidad'  : modalidad,
      'dia'        : dia,
      'horaInicio' : horaInicio,
      'horaFin'    : horaFin,
      'meta'       : meta,
      'status'     : 'pendiente',       // al crear
      'dateCreate' : dateCreate,
      'acuerdos'   : <String>[],
      // 'fechaLimite': ... (si lo usas)
      // 'periodo'    : ... (si lo usas)
    };
  }
}

class ClaseItem {
  final String id;
  final String nombre;
  final DocumentReference? requisitoRef;

  ClaseItem({
    required this.id,
    required this.nombre,
    this.requisitoRef,
  });
}
