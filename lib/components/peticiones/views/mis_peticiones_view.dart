import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/peticiones/views/card_peticiones.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class MisPeticionesView extends StatelessWidget {
  const MisPeticionesView({super.key});

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
                  'Mis Peticiones',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                CardPeticiones(community: false, deacuerdo: false),
                CardPeticiones(community: false, deacuerdo: false),
                CardPeticiones(community: false, deacuerdo: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}