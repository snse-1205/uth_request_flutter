import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:uth_request_flutter_application/components/pages/home_page.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: (usuario),
      home: HomePage()
    );
  }
}
