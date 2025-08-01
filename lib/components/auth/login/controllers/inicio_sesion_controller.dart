import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uth_request_flutter_application/components/auth/login/views/sign_in.dart';
import 'package:uth_request_flutter_application/components/pages/fondo_inicio_sesion.dart';
import 'package:uth_request_flutter_application/components/auth/register/models/estudiantes_models.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();

  var isLoading = false.obs;

  Future<String?> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    try {
      isLoading.value = true;

      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );

      final user = cred.user;

      if (user == null) return "No se pudo autenticar al usuario";

      final uid = user.uid;
      final doc = await _firestore.collection('estudiantes').doc(uid).get();
      isLoading.value = false;

      if (!doc.exists) return "No se encontró la información del estudiante";

      final estudiante = EstudianteModel.fromMap(doc.data()!);

      _storage.write('uid', uid);
      _storage.write('correo', estudiante.correo);
      _storage.write('nombre', estudiante.nombre);
      _storage.write('apellido', estudiante.apellido);
      _storage.write('campus', estudiante.campus);
      _storage.write('carrera', estudiante.carrera);
      _storage.write('cuenta', estudiante.cuenta);
      _storage.write('rol', estudiante.rol);
      _storage.write("logueado", true);

      return null;
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      return e.message;
    } catch (e) {
      isLoading.value = false;
      return "Error inesperado: $e";
    }
  }

  Future<void> cerrarSesion() async {
    await _auth.signOut();
    await _storage.erase();
    Get.offAll(() => FondoInicioSesion(widget_child: LoginScreen()), transition: Transition.circularReveal);
  }

  bool estaAutenticado() {
    return _storage.read('uid') != null;
  }

  EstudianteModel obtenerUsuarioLocal() {
    return EstudianteModel(
      nombre: _storage.read('nombre') ?? '',
      apellido: _storage.read('apellido') ?? '',
      correo: _storage.read('correo') ?? '',
      campus: _storage.read('campus') ?? '',
      carrera: _storage.read('carrera') ?? '',
      cuenta: _storage.read('cuenta') ?? '',
      rol: _storage.read('rol') ?? '',
    );
  }
}
