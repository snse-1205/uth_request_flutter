import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/auth/register/controllers/registrar_controller.dart';
import 'package:uth_request_flutter_application/components/auth/register/models/estudiantes_models.dart';
import 'package:uth_request_flutter_application/components/auth/register/views/register_academic.dart';
import 'package:uth_request_flutter_application/components/auth/register/views/register_info.dart';
import 'package:uth_request_flutter_application/components/auth/register/views/register_password.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

final RegisterController registerController = Get.find<RegisterController>();

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  get controllersRes => registerController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 400,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  Center(
                    child: RegisterInfo(
                      initialNombre: controllersRes.nombre.value,
                      initialApellido: controllersRes.apellido.value,
                      initialCorreo: controllersRes.correo.value,
                      onNombreChanged: (value) =>
                          controllersRes.setNombre(value),
                      onApellidoChanged: (value) =>
                          controllersRes.setApellido(value),
                      onCorreoChanged: (value) =>
                          controllersRes.setCorreo(value),
                    ),
                  ),
                  Center(
                    child: RegisterAcademicPage(
                      initialCampus: controllersRes.campus,
                      initialCarrera: controllersRes.carrera,
                      initialCuenta: controllersRes.cuenta.value,
                      onCampusChanged: (value) =>
                          controllersRes.setCampus(value),
                      onCarreraChanged: (value) =>
                          controllersRes.setCarrera(value),
                      onCuentaChanged: (value) =>
                          controllersRes.setCuenta(value),
                    ),
                  ),
                  Center(
                    child: RegisterPassword(
                      initialPassword: controllersRes.contrasena.value,
                      initialConfirm: controllersRes.confirmarContrasena.value,
                      onPasswordChanged: (val) =>
                          controllersRes.setContrasena(val),
                      onConfirmPasswordChanged: (val) =>
                          controllersRes.setConfirmarContrasena(val),
                    ),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                  width: _currentPage == index ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.secondary
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            // BOTONES
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (_currentPage > 0)
                      ElevatedButton.icon(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        label: Text(
                          botonAtras,
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primarySecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 20,
                          ),
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (_currentPage == 0) {
                          final nombre = controllersRes.nombre.value;
                          final apellido = controllersRes.apellido.value;
                          final correo = controllersRes.correo.value.trim();

                          if (nombre.isEmpty ||
                              apellido.isEmpty ||
                              correo.isEmpty) {
                            Get.snackbar(
                              'Error por campos vacios',
                              'Se han detectado campos vacios, llenalos antes de continuar.',
                            );
                            return;
                          }

                          final contieneNumeros = RegExp(r'\d');

                          if (contieneNumeros.hasMatch(nombre) ||
                              contieneNumeros.hasMatch(apellido)) {
                            Get.snackbar(
                              'Error de validacion',
                              'Nombre y apellido solo deben contener letras.',
                            );
                            return;
                          }

                          if (!correo.contains("@uth.hn")) {
                            Get.snackbar(
                              'Error de validacion',
                              'Debe ingresar su correo institucional, para validar que sea estudiante.',
                            );
                            return;
                          }
                        }

                        if (_currentPage == 1) {
                          final cuenta = controllersRes.cuenta.value.trim();

                          if (cuenta.isEmpty) {
                            Get.snackbar(
                              'Error por campos vacios',
                              'Se han detectado campos vacios, llenalos antes de continuar.',
                            );
                            return;
                          }

                          final contieneNumeros = RegExp(r'\d');

                          if (!contieneNumeros.hasMatch(cuenta)) {
                            Get.snackbar(
                              'Error de validacion',
                              'La cuenta universitaria solo debe contener numeros.',
                            );
                            return;
                          }
                        }

                        if (_currentPage == 2) {
                          final contrasena = controllersRes.contrasena.value;
                          final confirmarContrasena =
                              controllersRes.confirmarContrasena.value;

                          if (contrasena.isEmpty ||
                              confirmarContrasena.isEmpty) {
                            Get.snackbar(
                              'Error por campos vacios',
                              'Se han detectado campos vacios, llenalos antes de continuar.',
                            );
                            return;
                          }
                        }

                        if (_currentPage < 2) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          print(
                            "Registro completado: ${controllersRes.nombre.value}, ${controllersRes.apellido.value}, ${controllersRes.campus.value}, ${controllersRes.carrera.value}, ${controllersRes.cuenta.value}, ${controllersRes.contrasena.value}, ${controllersRes.confirmarContrasena.value}",
                          );
                          final campusRef = FirebaseFirestore.instance
                              .collection('Campus')
                              .doc(controllersRes.campus.value);

                          final carreraRefs = controllersRes.carrera
                              .map(
                                (id) => FirebaseFirestore.instance
                                    .collection('Carreras')
                                    .doc(id),
                              )
                              .toList();
                          _registroEstudiante(
                            context,
                            controllersRes.nombre.value,
                            controllersRes.apellido.value,
                            controllersRes.correo.value,
                            campusRef,
                            carreraRefs,
                            controllersRes.cuenta.value,
                            "estudiante",
                            controllersRes.contrasena.value,
                            controllersRes.confirmarContrasena.value,
                            controllersRes,
                          );
                        }
                      },
                      icon: Icon(Icons.arrow_forward, color: Colors.white),
                      label: Text(
                        _currentPage == 2 ? botonFinalizar : botonSiguiente,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: () {
                    _limpiarControlador(controllersRes);
                    Get.back();
                  },
                  icon: Icon(Icons.close, color: Colors.white),
                  label: Text(
                    textCancelar,
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.onTertiaryText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _registroEstudiante(
  BuildContext context,
  String nombre,
  String apellido,
  String correo,
  DocumentReference campusRef, // ahora es referencia
  List<DocumentReference> carreraRef, // ahora es lista de referencias
  String cuenta,
  String rol,
  String contrasena,
  String confirmarContrasena,
  controller,
) async {
  if (contrasena != confirmarContrasena) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text('Las contraseñas no coinciden.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: Text('OK'),
          ),
        ],
      ),
    );
    return;
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) =>
        Center(child: CircularProgressIndicator(color: AppColors.primary)),
  );

  final estudiante = EstudianteModel(
    nombre: nombre,
    apellido: apellido,
    correo: correo,
    campus: campusRef,
    carrera: carreraRef,
    cuenta: cuenta,
    rol: rol,
  );

  final controller = Get.find<RegisterController>();
  String? error = await controller.registrarEstudiante(
    correo: correo,
    contrasena: contrasena,
    estudiante: estudiante,
  );

  Navigator.of(context).pop();

  if (error == null) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Registro exitoso'),
        content: Text('Tu cuenta ha sido creada correctamente.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
    _limpiarControlador(controller);
  } else {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

Future<void> _limpiarControlador(controller) async {
  controller.nombre.value = '';
  controller.apellido.value = '';
  controller.correo.value = '';
  controller.campus.value = '';
  controller.carrera.value = '';
  controller.cuenta.value = '';
  controller.contrasena.value = '';
  controller.confirmarContrasena.value = '';
}

Future<bool> verificarCorreoDisponible(String correo) async {
  try {
    List<String> signInMethods = await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(correo);
    return signInMethods.isEmpty;
  } catch (e) {
    print("Error al verificar correo: $e");
    return false;
  }
}
