// file: screen_b.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/Peticiones/Controllers/controller.dart';

// ignore: use_key_in_widget_constructors
class ScreenB extends StatelessWidget {
  final List<String> options = ["Opción 1", "Opción 2", "Opción 3"];
  final SelectionController controller = Get.find<SelectionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pantalla B")),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(options[index]),
            onTap: () {
              controller.updateText(options[index]);
              Get.back(); // Vuelve a Pantalla A
            },
          );
        },
      ),
    );
  }
}
