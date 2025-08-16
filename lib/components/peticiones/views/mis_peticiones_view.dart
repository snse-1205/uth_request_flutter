import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/Peticiones/Controllers/GetRequestController.dart';
import 'package:uth_request_flutter_application/components/Peticiones/Models/getRequestModel.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/peticiones/views/card_peticiones.dart';


class MisPeticionesView extends StatelessWidget {
  const MisPeticionesView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctl = Get.put(PeticionesController());

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
                  'Mis Peticiones',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            StreamBuilder<List<PetitionModel>>(
              stream: ctl.streamMisPeticiones(),
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
                    child: Text('Aún no tienes peticiones creadas ni aceptadas.'),
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
                      tipoPeticion: p.tipo,
                      nombreClase: p.nombreClase,
                      modalidad: p.modalidad,
                      campus: p.campus,
                      horario: p.horario,
                      fechaLimite: p.fechaLimite,
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
