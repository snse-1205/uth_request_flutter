import 'package:get/get.dart';

class SelectionController extends GetxController {
  var selectedText = "Selecciona una opción".obs;

  void updateText(String newText) {
    selectedText.value = newText;
  }
}