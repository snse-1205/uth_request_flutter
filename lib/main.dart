import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/pages/fondo_inicio_sesion.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        /*body: SingleChildScrollView(
            child: ClaseCard(),
        ),*/
        body: FondoInicioSesion(),
        backgroundColor: AppColors.onBackgroundDefault,
      ),
    );
  }
}
