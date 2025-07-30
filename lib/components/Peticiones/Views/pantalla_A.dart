import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/Peticiones/Controllers/controller.dart';
import 'package:uth_request_flutter_application/Peticiones/Views/screen_b.dart';

// ignore: use_key_in_widget_constructors
class ScreenA extends StatelessWidget {
  final SelectionController controller = Get.put(SelectionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pantalla A")),
      body: Center(
        child: Obx(() => GestureDetector(
              onTap: () => Get.to(() => ScreenB()),
              child: Card(
                color: Colors.green[100],
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(controller.selectedText.value),
                ),
              ),
            )),
      ),
    );
  }
}
