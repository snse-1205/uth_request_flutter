import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uth_request_flutter_application/components/notificaciones/modelo/notificaciones_model.dart';
import 'package:uth_request_flutter_application/components/notificaciones/views/notificaciones_card.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/notificaciones.dart';

class Notificacionesvista extends StatelessWidget {
  const Notificacionesvista({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = GetStorage().read('uid');

    return Scaffold(
      backgroundColor: AppColors.onBackgroundDefault,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SizedBox(width: 14),
                Text(
                  'Notificaciones',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Aquí usamos FutureBuilder
            FutureBuilder<List<NotificacionesModel>>(
              future: uid != null
                  ? Notificaciones().obtenerNotificacionesPorUid(uid)
                  : Future.value([]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error al cargar notificaciones"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No tienes notificaciones"));
                }

                final notificaciones = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notificaciones.length,
                  itemBuilder: (context, index) {
                    return NotificacionesCard(notificacion: notificaciones[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
