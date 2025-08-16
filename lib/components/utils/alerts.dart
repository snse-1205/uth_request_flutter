import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackcError(String error) {
  Get.snackbar(
    'Error',
    error,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.redAccent,
    colorText: Colors.white,
  );
}

void showSnackcSuccess(String message) {
  Get.snackbar(
    'Exito',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );
}

void showSnackcInfo(String message) {
  Get.snackbar(
    'Informacion',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.lightBlue,
    colorText: Colors.white,
  );
}

