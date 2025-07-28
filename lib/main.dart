import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/login/views/card_peticiones.dart';
import 'package:uth_request_flutter_application/components/login/views/signup.dart';
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
        body: SingleChildScrollView(
            child: ClaseCard(),
        ),
        /*body: LoginScreen(),
        backgroundColor: AppColors.onBackgroundDefault,*/
      ),
    );
  }
}
