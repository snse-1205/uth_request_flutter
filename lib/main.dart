import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:uth_request_flutter_application/Peticiones/Views/pantalla_A.dart';
=======
import 'package:uth_request_flutter_application/components/login/views/sign_in.dart';
import 'package:uth_request_flutter_application/components/pages/fondo_inicio_sesion.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

>>>>>>> main
void main() {
   runApp(GetMaterialApp(
    home: ScreenA(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FondoInicioSesion(widget_child: LoginScreen(),),
        backgroundColor: AppColors.onBackgroundDefault,
      ),
    );
  }
}
