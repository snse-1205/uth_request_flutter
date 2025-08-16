import 'package:cloud_firestore/cloud_firestore.dart';

class PetitionModel {
  final String id;
  final String uid;          // creador de la petición
  final String classId;      // id en ClasesPorCarrera (o usa claseRef si ya la tienes)
  final String tipo;         // "Apertura", etc. -> si falta: "datos por agregar"
  final String nombreClase;  // si falta: "datos por agregar"
  final String modalidad;    // si falta: "datos por agregar"
  final String campus;       // si falta: "datos por agregar"
  final String horario;      // si falta: "datos por agregar"
  final String status;       // "abierta" / "cerrada"
  final DateTime? fechaLimite;
  final int meta;            // objetivo de apoyos
  final List<String> acuerdos; // uids que aceptaron

  PetitionModel({
    required this.id,
    required this.uid,
    required this.classId,
    required this.tipo,
    required this.nombreClase,
    required this.modalidad,
    required this.campus,
    required this.horario,
    required this.status,
    required this.fechaLimite,
    required this.meta,
    required this.acuerdos,
  });

  factory PetitionModel.fromSnap(DocumentSnapshot<Map<String, dynamic>> d) {
    final data = d.data() ?? {};
    return PetitionModel(
      id: d.id,
      uid: (data['uid'] ?? '') as String,
      classId: (data['classId'] ?? '') as String,  // si usas claseRef, cambia a string del ref.id
      tipo: (data['tipo'] ?? 'datos por agregar').toString(),
      nombreClase: (data['nombreClase'] ?? 'datos por agregar').toString(),
      modalidad: (data['modalidad'] ?? 'datos por agregar').toString(),
      campus: (data['campus'] ?? 'datos por agregar').toString(),
      horario: (data['horario'] ?? 'datos por agregar').toString(),
      status: (data['status'] ?? 'abierta').toString(),
      fechaLimite: (data['fechaLimite'] is Timestamp)
          ? (data['fechaLimite'] as Timestamp).toDate()
          : null,
      meta: (data['meta'] ?? 0) as int,
      acuerdos: List<String>.from(data['acuerdos'] ?? const <String>[]),
    );
  }
}
