import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/models/usuariosModel.dart';

class UsuariosController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Usuario>> streamAll() {
    return _db.collection('estudiantes').snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Usuario.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }
}
