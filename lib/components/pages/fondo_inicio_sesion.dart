import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class FondoInicioSesion extends StatelessWidget {
  const FondoInicioSesion({super.key, required this.widget_child});

  final Widget widget_child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onBackgroundDefault,
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -80,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: AppColors.primaryVariant,
            ),
          ),
          Positioned(
            bottom: -30,
            right: -100,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: AppColors.primaryVariant,
            ),
          ),
          Positioned(
            bottom: -80,
            left: -20,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: AppColors.primaryVariant,
            ),
          ),

          Center(
            child: widget_child,
          ),
        ],
      ),
    );
  }
}