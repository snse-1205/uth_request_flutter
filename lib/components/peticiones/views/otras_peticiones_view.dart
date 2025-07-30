import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/peticiones/views/card_peticiones.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class OtrasPeticionesView extends StatelessWidget {
  const OtrasPeticionesView({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'Peticiones en la que Estoy de Acuerdo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                CardPeticiones(community: false, deacuerdo: true),
                CardPeticiones(community: false, deacuerdo: true),
                CardPeticiones(community: false, deacuerdo: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}