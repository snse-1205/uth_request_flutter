import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:uth_request_flutter_application/components/notificaciones/modelo/notificaciones_model.dart';
import 'package:uth_request_flutter_application/components/notificaciones/views/notificaciones_card.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class Notificacionesvista extends StatelessWidget {
  
  
  const Notificacionesvista({super.key});


  @override
  Widget build(BuildContext context) {
    final List<NotificacionesModel> lista = [
    NotificacionesModel(atencion,notificacionMensaje,clase,estadoLleno,fecha,Icons.check_circle),
    NotificacionesModel(administracion,notificacionMensaje,clase,estadoAceptado,fecha,Icons.sentiment_satisfied),
    NotificacionesModel(administracion,notificacionMensaje,clase,estadoDenegado,fecha, Icons.sentiment_dissatisfied),
  ];
    return Scaffold(
      
      body: ListView.builder(
        itemCount: lista.length,
        itemBuilder: (_, index) => NotificacionesCard(notificacion: lista[index]),
      ),

    );
  }
}