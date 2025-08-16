import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/notificaciones/modelo/notificaciones_model.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class NotificacionesCard extends StatelessWidget {
  final NotificacionesModel notificacion;

  const NotificacionesCard({super.key, required this.notificacion});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(12),
      color: AppColors.onSurface,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              notificacion.titulo,
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),

            // Contenido
            Text(
              notificacion.mensaje,
              style: TextStyle(
                color: AppColors.onPrimaryText,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),

            // Fecha
            Text(
              notificacion.fecha,
              style: TextStyle(
                color: AppColors.onPrimaryText.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
