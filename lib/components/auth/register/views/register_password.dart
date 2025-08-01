import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class RegisterPassword extends StatefulWidget {
  final Function(String) onPasswordChanged;
  final Function(String) onConfirmPasswordChanged;

  final String initialPassword;
  final String initialConfirm;

  const RegisterPassword({
    super.key,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
    this.initialPassword = '',
    this.initialConfirm = '',
  });

  @override
  State<RegisterPassword> createState() => _RegisterPasswordState();
}

class _RegisterPasswordState extends State<RegisterPassword> {
  late TextEditingController _passwordController;
  late TextEditingController _confirmController;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: widget.initialPassword);
    _confirmController = TextEditingController(text: widget.initialConfirm);

    // Escuchar cambios para llamar a las funciones externas
    _passwordController.addListener(() {
      widget.onPasswordChanged(_passwordController.text);
    });
    _confirmController.addListener(() {
      widget.onConfirmPasswordChanged(_confirmController.text);
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        children: [
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: textoContrasena,
              filled: true,
              fillColor: AppColors.onSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
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
              hintText: "Confirmar contraseña",
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
        ],
      ),
    );
  }
}

