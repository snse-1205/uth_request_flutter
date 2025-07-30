import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:uth_request_flutter_application/components/Peticiones/Views/createRequest.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/login/views/sign_in.dart';
import 'package:uth_request_flutter_application/components/pages/fondo_inicio_sesion.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';


void main() {
   runApp(GetMaterialApp(
    home: CreateRequest(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FondoInicioSesion(widget_child: LoginScreen()),
        backgroundColor: AppColors.onBackgroundDefault,
      ),
    );
  }
}
