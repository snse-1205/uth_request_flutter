import 'package:cloud_firestore/cloud_firestore.dart';

class CampusModel {
  final String id;                 // ID del documento (nombre del campus)
  final DateTime? dateCreate;      // puede venir null si aún no ha llegado el serverTimestamp

  CampusModel({required this.id, this.dateCreate});

  factory CampusModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return CampusModel(
      id: doc.id,
      dateCreate: (data?['dateCreate'] as Timestamp?)?.toDate(),
    );
  }
}
