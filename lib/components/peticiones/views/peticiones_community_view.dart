import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/peticiones/views/card_peticiones.dart';

// Usa el controller correcto (donde definiste streamPeticionesCommunity y PetitionModel)
import 'package:uth_request_flutter_application/components/Peticiones/Controllers/controller.dart';

class PeticionesCommunityView extends StatelessWidget {
  const PeticionesCommunityView({
    super.key,
    this.classId,      // opcional: para filtrar por clase seleccionada
    this.periodoTexto, // opcional: encabezado
  });

  final String? classId;
  final String? periodoTexto;

  @override
  Widget build(BuildContext context) {
    final ctl = Get.put(ClassRequestController()); // <<--- este controller

    return Scaffold(
      backgroundColor: AppColors.onBackgroundDefault,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 14),
                Text(
                  periodoTexto ?? 'Periodo 03-2025',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            StreamBuilder<List<PetitionModel>>(
              stream: ctl.streamPeticionesCommunity(classId: classId), // <<--- este stream
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snap.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Error: ${snap.error}'),
                  );
                }

                final items = snap.data ?? const <PetitionModel>[];
                if (items.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('No hay peticiones disponibles para aceptar.'),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final p = items[i];

                    return CardPeticiones(
                      petitionId: p.id,
                      tipoPeticion: p.tipo.isEmpty ? 'APERTURA DE CLASE' : p.tipo,
                      nombreClase: (p.nombreClase ?? '').isEmpty ? p.classId : p.nombreClase!,
                      modalidad: p.modalidad.isEmpty ? 'Presencial' : p.modalidad,
                      campus: p.campus ?? '',
                      horario: p.horario ?? '${p.horaInicio} - ${p.horaFin}${p.dia.isNotEmpty ? ' • ${p.dia}' : ''}',
                      fechaLimite: p.fechaLimite?.toDate(), // <<--- convierte Timestamp? a DateTime?
                      meta: p.meta,
                    );
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
