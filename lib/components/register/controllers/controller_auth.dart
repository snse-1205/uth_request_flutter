import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uth_request_flutter_application/components/register/models/estudiantes_models.dart';

class RegisterController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> registrarEstudiante({
    required String correo,
    required String contrasena,
    required EstudianteModel estudiante,
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );

      String uid = cred.user!.uid;

      await _firestore.collection('estudiantes').doc(uid).set(estudiante.toMap());

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error desconocido: $e';
    }
  }
}
