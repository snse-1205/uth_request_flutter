import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

import 'package:uth_request_flutter_application/components/Peticiones/Controllers/controller.dart';
// ↑ Asegúrate de que este import apunte a donde definiste ClassRequestController y PetitionModel.

class AdminPendientesView extends StatelessWidget {
  const AdminPendientesView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctl = Get.put(ClassRequestController());

    return Scaffold(
      backgroundColor: AppColors.onBackgroundDefault,
      appBar: AppBar(
        title: const Text('Peticiones pendientes'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onSurface,
      ),
      body: StreamBuilder<List<PetitionModel>>(
        stream: ctl.streamPeticionesPendientesAdmin(), // <— aquí
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final items = snap.data ?? const <PetitionModel>[];
          if (items.isEmpty) {
            return const Center(child: Text('No hay peticiones pendientes.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _AdminPeticionCard(p: items[i], ctl: ctl),
          );
        },
      ),
    );
  }
}

class _AdminPeticionCard extends StatelessWidget {
  final PetitionModel p;
  final ClassRequestController ctl;

  const _AdminPeticionCard({required this.p, required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.onSurface,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título: nombre de la clase
            Text(
              p.nombreClase ?? p.classId,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 4),

            // Datos extra (campus y horario)
            Text("Campus: ${p.campus ?? '-'}",
                style: const TextStyle(color: Colors.black87)),
            Text("Horario: ${p.horario ?? '-'}",
                style: const TextStyle(color: Colors.black87)),

            const SizedBox(height: 6),

            // Contador de apoyos
            Row(
              children: [
                const Icon(Icons.people, size: 18, color: Colors.black54),
                const SizedBox(width: 4),
                Text(
                  "${p.acuerdos?.length ?? 0} estudiantes interesados",
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),

            const Divider(),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => ctl.updateStatus(p.id, "rechazada"),
                  icon: const Icon(Icons.close, color: Colors.red),
                  label: const Text("Rechazar",
                      style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => ctl.updateStatus(p.id, "aceptada"),
                  icon: const Icon(Icons.check),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  label: const Text("Aceptar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
