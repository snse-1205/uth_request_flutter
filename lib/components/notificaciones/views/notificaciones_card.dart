import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/notificaciones/modelo/notificaciones_model.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class NotificacionesCard extends StatelessWidget {
  final NotificacionesModel notificacion;

  const NotificacionesCard({super.key, required this.notificacion});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      margin: const EdgeInsets.all(12),
      child: Padding(padding: EdgeInsetsGeometry.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notificacion.titulo,
                    style: TextStyle(color: AppColors.secondary, fontSize: 16),
                  ),
                  Text(notificacion.mensaje),
                  Text(notificacion.clase),
                  Text(notificacion.estado),
                ],
              ),
              Icon(notificacion.icono, size: 75),
              
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 20,),
              Column(
                children: [
                  ElevatedButton(onPressed: null, child: Text("¿Que hago?"),style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(AppColors.onBackgroundDefault),backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryVariant)),),
                  Text(notificacion.fecha),
                ],
              ),
            ],
          ),
        ],
      ),
      )
      
      
    );
  }
}
