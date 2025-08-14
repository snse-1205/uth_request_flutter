import 'package:cloud_firestore/cloud_firestore.dart';

class Carrera {
  final String id;            // id del doc (slug)
  final String nombre;        // nombre visible
  final DateTime? dateCreate; // puede venir null por serverTimestamp

  Carrera({required this.id, required this.nombre, this.dateCreate});

  factory Carrera.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Carrera(
      id: doc.id,
      nombre: (data?['nombre'] as String?)?.trim() ?? doc.id,
      dateCreate: (data?['dateCreate'] as Timestamp?)?.toDate(),
    );
  }
}
