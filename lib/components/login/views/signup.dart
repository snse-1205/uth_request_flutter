import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class LoginScreen extends StatelessWidget {
   const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onBackgroundDefault,
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -80,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: AppColors.primaryVariant,
            ),
          ),
          Positioned(
            bottom: -30,
            right: -100,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: AppColors.primaryVariant,
            ),
          ),
          Positioned(
            bottom: -80,
            left: -20,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: AppColors.primaryVariant,
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding:  EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/logo_UTH_verde.png',
                    height: 200,
                  ),

                  TextField(
                    decoration: InputDecoration(
                      hintText: textoCorreoElectronico,
                      filled: true,
                      fillColor: AppColors.onSurface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:  EdgeInsets.symmetric(
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
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: textoContrasena,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:  EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      hintStyle:  TextStyle(color: AppColors.onSecondaryText),
                    ),
                  ),
                   SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Color(0xFF4B7756),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:  EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        botonIngresar,
                        style: TextStyle(color: AppColors.onSurface),
                      ),
                    ),
                  ),
                   SizedBox(height: 16),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style:  TextStyle(color: AppColors.primary),
                      children: [
                        TextSpan(
                          text: botonNoTienesCuenta,
                          style:  TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("Redirigir a registro");
                            },
                        ),
                         TextSpan(text: "\n"),
                        TextSpan(
                          text: botonOlvidarContrasena,
                          style:  TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("Redirigir a recuperar contraseña");
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
