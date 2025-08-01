import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class RegisterEmailPinPage extends StatefulWidget {
  const RegisterEmailPinPage({super.key});

  @override
  State<RegisterEmailPinPage> createState() => _RegisterEmailPinPageState();
}

class _RegisterEmailPinPageState extends State<RegisterEmailPinPage> {
  TextEditingController pinController = TextEditingController();
  String currentPin = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            textVerificarPinMensaje,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: AppColors.onPrimaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),

          PinCodeTextField(
            appContext: context,
            length: 6,
            controller: pinController,
            animationType: AnimationType.scale,
            keyboardType: TextInputType.number,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.underline,
              fieldHeight: 50,
              fieldWidth: 40,
              inactiveColor: Colors.grey,
              activeColor: AppColors.primary,
              selectedColor: Colors.green,
            ),
            onChanged: (value) {
              setState(() {
                currentPin = value;
              });
            },
            onCompleted: (value) {
              print("PIN ingresado: $value");
            },
          ),

          const SizedBox(height: 32),

          ElevatedButton(
            onPressed: currentPin.length == 6
                ? () {
                    print("Verificar PIN: $currentPin");
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4B7756),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            ),
            child: Text(
              botonVerificarPin,
              style: TextStyle(color: AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
