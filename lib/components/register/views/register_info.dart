import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class RegisterInfo extends StatelessWidget {
  const RegisterInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/logo_UTH_verde.png', height: 100),
          SizedBox(height: 16),
          Text(
            textRegistroCuenta,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.onPrimaryText,
            ),
          ),
          SizedBox(height: 24),

          TextField(
            decoration: InputDecoration(
              hintText: textNombreCompleto,
              filled: true,
              fillColor: AppColors.onSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              hintStyle: TextStyle(color: AppColors.onSecondaryText),
            ),
          ),
          SizedBox(height: 16),

          TextField(
            decoration: InputDecoration(
              hintText: textoCorreoElectronico,
              filled: true,
              fillColor: AppColors.onSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              hintStyle: TextStyle(color: AppColors.onSecondaryText),
            ),
          ),
        ],
      ),
    );
  }
}
