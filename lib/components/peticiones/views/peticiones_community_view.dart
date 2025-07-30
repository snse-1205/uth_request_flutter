import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/peticiones/views/card_peticiones.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class PeticionesCommunityView extends StatelessWidget {
  const PeticionesCommunityView({super.key});

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
                  'Periodo 03-2025',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                CardPeticiones(community: true, deacuerdo: false),
                CardPeticiones(community: true, deacuerdo: false),
                CardPeticiones(community: true, deacuerdo: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
