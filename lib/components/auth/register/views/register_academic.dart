import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class RegisterAcademicPage extends StatefulWidget {
  const RegisterAcademicPage({
    super.key,
    required this.onCampusChanged,
    required this.onCarreraChanged,
    required this.onCuentaChanged,
    this.initialCampus,
    this.initialCarrera,
    this.initialCuenta = '',
  });

  final Function(String) onCampusChanged;
  final Function(String) onCarreraChanged;
  final Function(String) onCuentaChanged;

  final String? initialCampus;
  final String? initialCarrera;
  final String initialCuenta;

  @override
  State<RegisterAcademicPage> createState() => _RegisterAcademicPageState();
}

class _RegisterAcademicPageState extends State<RegisterAcademicPage> {
  late String? selectedCampus;
  late String? selectedCarrera;
  late TextEditingController _cuentaController;

  final List<String> campusList = [
    'Campus San Pedro Sula',
    'Campus Tegucigalpa',
    'Campus La Ceiba',
    'Campus Santa Bárbara',
  ];

  final List<String> carreraList = [
    'Ingeniería en Sistemas',
    'Administración de Empresas',
    'Diseño Gráfico',
    'Contaduría Pública',
  ];

  @override
  void initState() {
    super.initState();
    selectedCampus = widget.initialCampus;
    selectedCarrera = widget.initialCarrera;
    _cuentaController = TextEditingController(text: widget.initialCuenta);

    _cuentaController.addListener(() {
      widget.onCuentaChanged(_cuentaController.text);
    });
  }

  @override
  void dispose() {
    _cuentaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        children: [
          TextField(
            controller: _cuentaController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: textNumeroCuenta,
              filled: true,
              fillColor: AppColors.onSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              hintStyle: TextStyle(color: AppColors.onSecondaryText),
            ),
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: textSeleccionaCampus,
              filled: true,
              fillColor: AppColors.onSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            value: selectedCampus =
                (widget.initialCampus != null &&
                    campusList.contains(widget.initialCampus))
                ? widget.initialCampus
                : campusList.first,
            items: campusList.map((campus) {
              return DropdownMenuItem<String>(
                value: campus,
                child: Text(campus),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCampus = value;
                widget.onCampusChanged(value ?? '');
              });
            },
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: textSeleccionaCarrera,
              filled: true,
              fillColor: AppColors.onSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            value: selectedCarrera = (widget.initialCarrera != null &&
                    carreraList.contains(widget.initialCarrera))
                ? widget.initialCarrera
                : carreraList.first,
            items: carreraList.map((carrera) {
              return DropdownMenuItem<String>(
                value: carrera,
                child: Text(carrera),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCarrera = value;
                widget.onCarreraChanged(value ?? '');
              });
            },
          ),
        ],
      ),
    );
  }
}
