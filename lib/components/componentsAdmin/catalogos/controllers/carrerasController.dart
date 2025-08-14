import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/models/carrerasModel.dart';

class CarreraController {
  final FirebaseFirestore _db;
  CarreraController({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  Stream<List<Carrera>> streamAll() {
    final q = _db.collection('Carreras').orderBy('dateCreate', descending: true);
    return q.snapshots().map((snap) => snap.docs
        .map((d) => Carrera.fromDoc(d as DocumentSnapshot<Map<String, dynamic>>))
        .toList());
  }

  /// Crea la carrera con ID = `id` y nombre = `nombre`.
  /// Devuelve true si se creó, false si ya existía.
  Future<bool> create({required String id, required String nombre}) async {
    final _id = id.trim();
    final _nombre = nombre.trim();
    if (_id.isEmpty || _nombre.isEmpty) {
      throw ArgumentError('ID y nombre son requeridos');
    }

    return _db.runTransaction<bool>((tx) async {
      final ref = _db.collection('Carreras').doc(_id);
      final snap = await tx.get(ref);
      if (snap.exists) return false;

      tx.set(ref, {
        'id': _id,
        'nombre': _nombre,
        'dateCreate': FieldValue.serverTimestamp(),
      });
      return true;
    });
  }
}
