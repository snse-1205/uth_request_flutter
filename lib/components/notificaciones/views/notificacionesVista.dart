import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/notificaciones/modelo/notificaciones_model.dart';
import 'package:uth_request_flutter_application/components/notificaciones/views/notificaciones_card.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class Notificacionesvista extends StatelessWidget {
  const Notificacionesvista({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NotificacionesModel> lista = [
      NotificacionesModel(
        atencion,
        notificacionMensaje,
        clase,
        estadoLleno,
        fecha,
        Icons.check_circle,
      ),
      NotificacionesModel(
        administracion,
        notificacionMensaje,
        clase,
        estadoAceptado,
        fecha,
        Icons.sentiment_satisfied,
      ),
      NotificacionesModel(
        administracion,
        notificacionMensaje,
        clase,
        estadoDenegado,
        fecha,
        Icons.sentiment_dissatisfied,
      ),
    ];
    return Scaffold(
      backgroundColor: AppColors.onBackgroundDefault,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 14),
                Text(
                  'Notificaciones',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: lista
                  .map((notificacion) =>
                      NotificacionesCard(notificacion: notificacion))
                  .toList(),
            ),
          ],
        ),
      )
    );
  }
}
