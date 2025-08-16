import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/controllers/campusController.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/controllers/carrerasController.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/models/campusModel.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/models/carrerasModel.dart';
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

  final Function(DocumentReference) onCampusChanged;
  final Function(List<DocumentReference>) onCarreraChanged;
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

  final CampusController _campusController = CampusController();
  final CarreraController _carreraController = CarreraController();

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

          StreamBuilder<List<CampusModel>>(
            stream: _campusController.streamAll(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final campusList = snapshot.data!;
              if (campusList.isEmpty) {
                return const Text(
                  "No hay campus registrados",
                  style: TextStyle(color: AppColors.onSecondaryText),
                );
              }

              return DropdownButtonFormField<String>(
                decoration: _inputDecoration(textSeleccionaCampus),
                value: selectedCampus ?? campusList.first.id,
                items: campusList.map((campus) {
                  return DropdownMenuItem<String>(
                    value: campus.id,
                    child: Text(campus.id),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCampus = value;
                    if (value != null) {
                      final campusRef = FirebaseFirestore.instance
                          .collection('Campus')
                          .doc(value);
                      widget.onCampusChanged(campusRef);
                    }
                  });
                },
              );
            },
          ),
          const SizedBox(height: 16),

          StreamBuilder<List<Carrera>>(
            stream: _carreraController.streamAll(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text(
                  "Error al cargar carreras",
                  style: TextStyle(color: AppColors.electricError),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                );
              }

              final carreraList = snapshot.data!;
              if (carreraList.isEmpty) {
                return const Text(
                  "No hay carreras registradas",
                  style: TextStyle(color: AppColors.onSecondaryText),
                );
              }

              return DropdownButtonFormField<String>(
                decoration: _inputDecoration(textSeleccionaCarrera),
                value: selectedCarrera ?? carreraList.first.id,
                items: carreraList.map((carrera) {
                  return DropdownMenuItem<String>(
                    value: carrera.id,
                    child: Text(
                      carrera.nombre.isNotEmpty ? carrera.nombre : carrera.id,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCarrera = value;
                    if (value != null) {
                      final carreraRef = FirebaseFirestore.instance
                          .collection('Carreras')
                          .doc(value);
                      widget.onCarreraChanged([carreraRef]); // si solo es una
                    }
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.onSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(color: AppColors.onSecondaryText),
    );
  }
}
