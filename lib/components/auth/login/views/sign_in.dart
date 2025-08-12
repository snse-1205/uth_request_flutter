import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/auth/login/controllers/inicio_sesion_controller.dart';
import 'package:uth_request_flutter_application/components/pages/fondo_inicio_sesion.dart';
import 'package:uth_request_flutter_application/components/pages/home_page.dart';
import 'package:uth_request_flutter_application/components/auth/register/views/sign_up.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/logo_UTH_verde.png', height: 100),
          SizedBox(height: 16),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: textoCorreoElectronico,
              filled: true,
              fillColor: AppColors.onSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              hintStyle: TextStyle(color: AppColors.onSecondaryText),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 16),

          TextField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            decoration: InputDecoration(
              hintText: textoContrasena,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              hintStyle: TextStyle(color: AppColors.onSecondaryText),
            ),
          ),
          SizedBox(height: 24),

          Obx(() {
            if (authController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.onHighlightText,
                ),
              );
            } else {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _signInSuccess(
                      emailController.text,
                      passwordController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B7756),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    botonIngresar,
                    style: TextStyle(color: AppColors.onSurface),
                  ),
                ),
              );
            }
          }),

          SizedBox(height: 16),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: AppColors.primary),
              children: [
                TextSpan(
                  text: botonNoTienesCuenta,
                  style: const TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.to(
                        () => FondoInicioSesion(widget_child: RegisterScreen()),
                        transition: Transition.fadeIn,
                      );
                    },
                ),
                /*const TextSpan(text: "\n"),
                const TextSpan(text: "\n"),
                TextSpan(
                  text: botonOlvidarContrasena,
                  style: const TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.to(
                        () => FondoInicioSesion(
                          widget_child: ChangePasswordScreen(),
                        ),
                      );
                    },
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginError(String error) {
    Get.snackbar(
      'Error de inicio de sesion',
      error,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  void _signInSuccess(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error por campos vacios',
        'Se han detectado campos vacios, llenalos antes de continuar.',
      );
    } else {
      AuthController authController = Get.find<AuthController>();
      authController.iniciarSesion(correo: email, contrasena: password).then((
        error,
      ) {
        if (error != null) {
          _showLoginError(error);
        } else {
          Get.offAll(() => HomePage(), transition: Transition.circularReveal);
          Get.snackbar(
            'Exito',
            'Inicio de sesion exitoso',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      });
    }
  }
}
