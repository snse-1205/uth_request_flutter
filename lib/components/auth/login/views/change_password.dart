import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        children: [
          TextField(
            controller: _newController,
            obscureText: _obscureNew,
            decoration: InputDecoration(
              hintText: textNuevaContrasena,
              filled: true,
              fillColor: AppColors.onSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNew ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureNew = !_obscureNew;
                  });
                },
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              hintStyle: TextStyle(color: AppColors.onSecondaryText),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _confirmController,
            obscureText: _obscureConfirm,
            decoration: InputDecoration(
              hintText: textConfirmarNuevaContrasena,
              filled: true,
              fillColor: AppColors.onSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirm = !_obscureConfirm;
                  });
                },
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              hintStyle: TextStyle(color: AppColors.onSecondaryText),
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_newController.text != _confirmController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Las contraseñas no coinciden"),
                    ),
                  );
                  return;
                }

                print("Cambiar contraseña:");
                print("Actual: ${_currentController.text}");
                print("Nueva: ${_newController.text}");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                textGuardarCambios,
                style: TextStyle(color: AppColors.onSurface),
              ),
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, color: Colors.white),
            label: Text(textCancelar, style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.onTertiaryText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            ),
          ),
        ],
      ),
    );
  }
}
