import 'package:cloud_firestore/cloud_firestore.dart';
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

                    // nombreClase no nulo para la Card
                    final nombreSeguro = p.nombreClase ?? 'datos por agregar';

                    // Si tu modelo usa Timestamp?, conviértelo; si ya es DateTime?, el operador ?.toDate no existirá.
                    // Por compatibilidad con ambos, usa un try/catch ligero:
                    DateTime? fechaLimiteDT;
                    try {
                      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                      // Si es Timestamp:
                      // @ts-ignore in Dart: simplemente intentamos llamar toDate()
                      // y si no existe, cae al catch y lo dejamos nulo o lo asignamos directo.
                      // Pero para evitar warnings, hacemos un cast seguro.
                      // Nota: si tu PetitionModel ya define DateTime?, simplemente comenta la siguiente línea y usa p.fechaLimite.
                      // // fechaLimiteDT = (p.fechaLimite as Timestamp?)?.toDate();
                      // Para no depender del cast, dejemos así:
                      // ignore: unnecessary_type_check
                      if (p.fechaLimite is Timestamp) {
                        fechaLimiteDT = (p.fechaLimite as Timestamp?)?.toDate();
                      } else if (p.fechaLimite is DateTime) {
                        fechaLimiteDT = p.fechaLimite as DateTime?;
                      } else {
                        fechaLimiteDT = null;
                      }
                    } catch (_) {
                      // Si ya es DateTime?
                      // @dart = 3.0  — simple fallback
                      // ignore: unnecessary_type_check
                      if (p.fechaLimite is DateTime) {
                        fechaLimiteDT = p.fechaLimite as DateTime?;
                      } else {
                        fechaLimiteDT = null;
                      }
                    }

                    return CardPeticiones(
                      petitionId: p.id,
                      tipoPeticion: p.tipo,
                      nombreClase: nombreSeguro,
                      modalidad: p.modalidad,
                      campus: p.campus ?? 'datos por agregar',
                      horario: p.horario ?? 'datos por agregar',
                      fechaLimite: fechaLimiteDT,
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
