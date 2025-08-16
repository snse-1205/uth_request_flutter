import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/auth/register/models/estudiantes_models.dart';

class RegisterController extends GetxController {
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

      await _firestore
          .collection('estudiantes')
          .doc(uid)
          .set(estudiante.toMap());

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error desconocido: $e';
    }
  }

  Future<String?> registrarUsuario({
    required String correo,
    required String contrasena,
    required EstudianteModel estudiante,
    required String rol,
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );

      String uid = cred.user!.uid;

      await _firestore.collection('usuarios').doc(uid).set({
        ...estudiante.toMap(),
        "rol": rol,
        "uid": uid,
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error desconocido: $e';
    }
  }

  var nombre = ''.obs;
  var apellido = ''.obs;
  var correo = ''.obs;
  var campusRef = Rx<DocumentReference?>(null);
  var carreraRef = RxList<DocumentReference>([]);
  var cuenta = ''.obs;
  var contrasena = ''.obs;
  var confirmarContrasena = ''.obs;

  void setNombre(String value) => nombre.value = value;
  void setApellido(String value) => apellido.value = value;
  void setCorreo(String value) => correo.value = value;
  void setCampusRef(DocumentReference ref) => campusRef.value = ref;
  void setCarreraRef(List<DocumentReference> refs) {
    carreraRef.clear();
    carreraRef.addAll(refs);
  }

  void setCuenta(String value) => cuenta.value = value;
  void setContrasena(String value) => contrasena.value = value;
  void setConfirmarContrasena(String value) =>
      confirmarContrasena.value = value;
}
