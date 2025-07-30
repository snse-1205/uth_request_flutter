import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/register/controllers/controller_auth.dart';
import 'package:uth_request_flutter_application/components/register/models/estudiantes_models.dart';
import 'package:uth_request_flutter_application/components/register/views/register_academic.dart';
import 'package:uth_request_flutter_application/components/register/views/register_email_pin.dart';
import 'package:uth_request_flutter_application/components/register/views/register_info.dart';
import 'package:uth_request_flutter_application/components/register/views/register_password.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String nombre = '';
  String apellido = '';
  String correo = '';
  String campus = '';
  String carrera = '';
  String cuenta = '';
  String contrasena = '';
  String confirmarContrasena = '';

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
                      onNombreChanged: (value) => nombre = value,
                      onApellidoChanged: (value) => apellido = value,
                      onCorreoChanged: (value) => correo = value,
                    ),
                  ),
                  Center(
                    child: RegisterAcademicPage(
                      onCampusChanged: (value) => campus = value,
                      onCarreraChanged: (value) => carrera = value,
                      onCuentaChanged: (value) => cuenta = value,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [RegisterEmailPinPage()],
                    ),
                  ),
                  Center(
                    child: RegisterPassword(
                      onPasswordChanged: (value) => contrasena = value,
                      onConfirmPasswordChanged: (value) =>
                          confirmarContrasena = value,
                    ),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
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
                      onPressed: () {
                        if (_currentPage < 3) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          print("Registro completado");
                          _registroEstudiante(
                            context,
                            nombre,
                            apellido,
                            correo,
                            campus,
                            carrera,
                            cuenta,
                            contrasena,
                            confirmarContrasena,
                          );
                        }
                      },
                      icon: Icon(Icons.arrow_forward, color: Colors.white),
                      iconAlignment: IconAlignment.end,
                      label: Text(
                        _currentPage == 3 ? botonFinalizar : botonSiguiente,
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
                    Navigator.pop(context);
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
  String campus,
  String carrera,
  String cuenta,
  String contrasena,
  String confirmarContrasena,
) async {
  if (contrasena != confirmarContrasena) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text('Las contraseñas no coinciden.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
    return;
  }

  final estudiante = EstudianteModel(
    nombre: nombre,
    apellido: apellido,
    correo: correo,
    campus: campus,
    carrera: carrera,
    cuenta: cuenta,
  );

  final controller = RegisterController();
  String? error = await controller.registrarEstudiante(
    correo: correo,
    contrasena: contrasena,
    estudiante: estudiante,
  );

  if (error == null) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Registro exitoso'),
        content: Text('Tu cuenta ha sido creada correctamente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
