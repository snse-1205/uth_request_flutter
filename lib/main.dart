import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uth_request_flutter_application/components/auth/login/controllers/inicio_sesion_controller.dart';
import 'package:uth_request_flutter_application/components/auth/login/views/sign_in.dart';
import 'package:uth_request_flutter_application/components/auth/register/controllers/registrar_controller.dart';
import 'package:uth_request_flutter_application/components/pages/fondo_inicio_sesion.dart';
import 'package:uth_request_flutter_application/components/pages/home_page.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';


void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


      
  runApp(MainApp());
  Get.put(AuthController(), permanent: true);
  Get.put(RegisterController(), permanent: true);


}




class MainApp extends StatelessWidget {
  MainApp({super.key});
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {

    void mostrarMensaje(){}


    final hayData = storage.read("logueado") ?? false;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: hayData
          ? HomePage()
          : Scaffold(
              body: FondoInicioSesion(widget_child: LoginScreen()),
              backgroundColor: AppColors.onBackgroundDefault,
            ),
    );
  }
}
