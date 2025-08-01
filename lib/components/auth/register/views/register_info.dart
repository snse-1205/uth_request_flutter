import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class RegisterInfo extends StatefulWidget {
  const RegisterInfo({
    super.key,
    required this.onNombreChanged,
    required this.onApellidoChanged,
    required this.onCorreoChanged,
    this.initialNombre = '',
    this.initialApellido = '',
    this.initialCorreo = '',
  });

  final Function(String) onNombreChanged;
  final Function(String) onApellidoChanged;
  final Function(String) onCorreoChanged;

  final String initialNombre;
  final String initialApellido;
  final String initialCorreo;

  @override
  State<RegisterInfo> createState() => _RegisterInfoState();
}

class _RegisterInfoState extends State<RegisterInfo> {
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _correoController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.initialNombre);
    _apellidoController = TextEditingController(text: widget.initialApellido);
    _correoController = TextEditingController(text: widget.initialCorreo);

    _nombreController.addListener(() {
      widget.onNombreChanged(_nombreController.text);
    });
    _apellidoController.addListener(() {
      widget.onApellidoChanged(_apellidoController.text);
    });
    _correoController.addListener(() {
      widget.onCorreoChanged(_correoController.text);
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _correoController.dispose();
    super.dispose();
  }

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
            controller: _nombreController,
            decoration: InputDecoration(
              hintText: textNombres,
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
            controller: _apellidoController,
            decoration: InputDecoration(
              hintText: textApellidos,
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
            controller: _correoController,
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
