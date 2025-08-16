import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:uth_request_flutter_application/components/Peticiones/Controllers/GetRequestController.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class CardPeticiones extends StatelessWidget {
  const CardPeticiones({
    super.key,
    required this.petitionId,
    required this.tipoPeticion,
    required this.nombreClase,
    required this.modalidad,
    required this.campus,
    required this.horario,
    required this.fechaLimite,
    required this.meta,
  });

  final String petitionId;
  final String tipoPeticion;
  final String nombreClase;
  final String modalidad;
  final String campus;
  final String horario;
  final DateTime? fechaLimite;
  final int meta;

  @override
  Widget build(BuildContext context) {
    final ctl = Get.find<PeticionesController>();

    final safeTipo = (tipoPeticion.isEmpty) ? 'datos por agregar' : tipoPeticion;
    final safeNombre = (nombreClase.isEmpty) ? 'datos por agregar' : nombreClase;
    final safeModalidad = (modalidad.isEmpty) ? 'datos por agregar' : modalidad;
    final safeCampus = (campus.isEmpty) ? 'datos por agregar' : campus;
    final safeHorario = (horario.isEmpty) ? 'datos por agregar' : horario;
    final fechaTxt = (fechaLimite != null)
        ? 'Fecha límite: ${_fmtDate(fechaLimite!)}'
        : 'Fecha límite: datos por agregar';

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      color: AppColors.onSurface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              safeTipo,
              style: TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              safeNombre,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("$safeModalidad - $safeCampus"),
            Text(safeHorario),
            const SizedBox(height: 8),
            Text(
              fechaTxt,
              style: TextStyle(color: AppColors.onBorderTextField),
            ),
            const SizedBox(height: 16),

            // Bloque de progreso + textos en tiempo real
            Row(
              children: [
                // Conteo en vivo
                StreamBuilder<int>(
                  stream: ctl.getAgreeCount(petitionId),
                  builder: (context, countSnap) {
                    final deacuerdoCount = countSnap.data ?? 0;
                    final totalNecesario = (meta <= 0) ? 0 : meta;
                    final faltantes = (totalNecesario - deacuerdoCount).clamp(0, 1 << 31);
                    final percent = (totalNecesario > 0)
                        ? (deacuerdoCount / totalNecesario).clamp(0.0, 1.0)
                        : 0.0;

                    return Row(
                      children: [
                        CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 15.0,
                          percent: percent,
                          center: Text(
                            '$deacuerdoCount',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          progressColor: AppColors.primaryProgress,
                          backgroundColor: AppColors.primaryLight,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Estudiantes',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('De acuerdo: $deacuerdoCount'),
                            const SizedBox(height: 4),
                            Text(
                              'Faltantes: $faltantes',
                              style: TextStyle(
                                color: AppColors.primarySecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Botón: estado en vivo y toggle que guarda el UID
            StreamBuilder<bool>(
              stream: ctl.hasAgreed(petitionId),
              builder: (context, s) {
                final yaAcepte = s.data ?? false;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => ctl.toggleAgree(petitionId),
                  child: Text(
                    yaAcepte ? '¡Ya estás de acuerdo!' : 'Estoy de acuerdo',
                    style: TextStyle(color: AppColors.onSurface),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return '$dd/$mm/$yy';
  }
}

class EstudianteModel {
  final String uid;
  final String nombre;
  final String correo;
  final String cuenta;

  EstudianteModel({
    required this.uid,
    required this.nombre,
    required this.correo,
    required this.cuenta,
  });

  factory EstudianteModel.fromMap(Map<String, dynamic> map, String uid) {
    return EstudianteModel(
      uid: uid,
      nombre: map['nombre'] ?? '',
      correo: map['correo'] ?? '',
      cuenta: map['cuenta'] ?? '',
    );
  }

  Map<String, String> toMapForExcel() {
    return {
      "nombre": nombre,
      "correo": correo,
      "cuenta": cuenta,
    };
  }
}
