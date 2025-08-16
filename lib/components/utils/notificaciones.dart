import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uth_request_flutter_application/components/notificaciones/modelo/notificaciones_model.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Notificaciones extends GetxController {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String fdb = 'fcmTokens';
  final GetStorage _storage = GetStorage();

  Future<void> guardarToken(String uid) async {
    final notificationSettings = await firebaseMessaging.requestPermission(
      provisional: true,
    );
    String fcmtoken = await firebaseMessaging.getToken() ?? '';

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Get.snackbar(
        message.notification?.title ?? 'Título de la notificación',
        message.notification?.body ?? 'Cuerpo del mensaje',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primarySecondary,
        colorText: Colors.white,
        icon: Icon(Icons.notifications, color: AppColors.secondary),
      );
    });

    if (fcmtoken.isEmpty) {
      print('No se pudo obtener el token de FCM.');
      return;
    }

    final doc = await firebaseFirestore.collection(fdb).doc(uid).get();

    List<String> tokens = [];

    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        tokens = List<String>.from(data['fcm_token']);
      }
    }

    if (!tokens.contains(fcmtoken)) {
      tokens.add(fcmtoken);
    }

    await firebaseFirestore.collection(fdb).doc(uid).set({'fcm_token': tokens});
  }

  Future<void> eliminarToken(String uid) async {
    try {
      String fcmtoken = await firebaseMessaging.getToken() ?? '';

      if (fcmtoken.isEmpty) {
        print('No se pudo obtener el token actual, no hay nada que eliminar.');
        return;
      }

      final doc = await firebaseFirestore.collection(fdb).doc(uid).get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['fcm_token'] is List) {
          List<String> tokens = List<String>.from(data['fcm_token']);

          tokens.remove(fcmtoken);

          await firebaseFirestore.collection(fdb).doc(uid).update({
            'fcm_token': tokens,
          });

          print('Token del dispositivo actual eliminado exitosamente.');
        } else {
          print('El documento no contiene una lista de tokens válida.');
        }
      } else {
        print('El documento del usuario no existe.');
      }
    } catch (e) {
      print('Error al eliminar el token: $e');
    }
  }

  Future<void> enviarNotificacion({
    required String fcmtoken,
    required String title,
    required String body,
  }) async {
    final url = Uri.parse('https://sendnotification-utkpxtmgca-uc.a.run.app');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fcmtoken': fcmtoken, 'title': title, 'body': body}),
    );

    if (response.statusCode == 200) {
      print('Notificación enviada: ${response.body}');
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> multicastNotificaciones({
    required List<String> uids,
    required String title,
    required String body,
  }) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('notificaciones').add({
      'titulo': title,
      'contenido': body,
      'uids': uids,
      'fecha': DateTime.now(),
    });

    for (final uid in uids) {
      try {
        final doc = await firestore.collection(fdb).doc(uid).get();

        if (doc.exists) {
          final data = doc.data();
          final List<dynamic> tokens = data?['fcm_token'] ?? [];

          for (final token in tokens) {
            if (token is String && token.isNotEmpty) {
              await enviarNotificacion(
                fcmtoken: token,
                title: title,
                body: body,
              );
            }
          }
        } else {
          print('No se encontró documento para UID: $uid');
        }
      } catch (e) {
        print('Error al procesar UID $uid: $e');
      }
    }
  }

  Future<List<NotificacionesModel>> obtenerNotificacionesPorUid(
    String uid,
  ) async {
    try {
      final querySnapshot = await firebaseFirestore
          .collection('notificaciones')
          .where('uids', arrayContains: uid)
          .orderBy('fecha', descending: true)
          .get();

      print("Docs encontrados: ${querySnapshot.docs.length}");

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return NotificacionesModel(
          titulo: data['titulo'] ?? '',
          mensaje: data['contenido'] ?? '',
          fecha: data['fecha']?.toString() ?? '',
        );
      }).toList();
    } catch (e) {
      print("Error al obtener notificaciones: $e");
      return [];
    }
  }
}
