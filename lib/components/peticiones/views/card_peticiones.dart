import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class CardPeticiones extends StatelessWidget {
  const CardPeticiones({super.key, required this.community, required this.deacuerdo});

  final bool community;
  final bool deacuerdo;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      color: AppColors.onSurface,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              textoTipoDePeticion,
              style: TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              textNombreClase,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("$textoModalidad - $textoUbicacionCampus"),
            Text(textoHorario),
            SizedBox(height: 8),
            Text(
              textoFechaLimite,
              style: TextStyle(color: AppColors.onBorderTextField),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                CircularPercentIndicator(
                  radius: 40.0,
                  lineWidth: 15.0,
                  percent: 10 / 15,
                  center: Text(
                    numeroEstudiantesDeacuerdo,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  progressColor: AppColors.primaryProgress,
                  backgroundColor: AppColors.primaryLight,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textoEstudiantes,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(textoEstudiantesDeacuerdo),
                    SizedBox(height: 4),
                    Text(
                      textoEstudiantesFaltantes,
                      style: TextStyle(
                        color: AppColors.primarySecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: Text(
                botonEstoyDeacuerdo,
                style: TextStyle(color: AppColors.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
