import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uth_request_flutter_application/components/utils/alerts.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class AgregarCarreraTab extends StatefulWidget {
  const AgregarCarreraTab({super.key});

  @override
  State<AgregarCarreraTab> createState() => _AgregarCarreraTabState();
}

class _AgregarCarreraTabState extends State<AgregarCarreraTab> {
  final TextEditingController _nombreCarreraController =
      TextEditingController();
  final TextEditingController _idCarreraController = TextEditingController();

  @override
  void dispose() {
    _nombreCarreraController.dispose();
    _idCarreraController.dispose();
    super.dispose();
  }

  // slug simple desde el nombre
  String _generarIdDesdeNombre(String input) {
    String s = input.trim().toLowerCase();
    const Map<String, String> acentos = {
      'á': 'a',
      'ä': 'a',
      'à': 'a',
      'â': 'a',
      'ã': 'a',
      'å': 'a',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'í': 'i',
      'ì': 'i',
      'î': 'i',
      'ï': 'i',
      'ó': 'o',
      'ò': 'o',
      'ô': 'o',
      'ö': 'o',
      'õ': 'o',
      'ú': 'u',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ñ': 'n',
      'ç': 'c',
    };
    acentos.forEach((k, v) => s = s.replaceAll(k, v));
    s = s.replaceAll(RegExp(r'[\s/|]+'), '-');
    s = s.replaceAll(RegExp(r'[^a-z0-9\-_]'), '');
    s = s.replaceAll(RegExp(r'-{2,}'), '-').replaceAll(RegExp(r'_{2,}'), '_');
    s = s.replaceAll(RegExp(r'^[-_]+|[-_]+$'), '');
    if (s.length > 32) s = s.substring(0, 32);
    return s;
  }

  Future<void> _guardarCarrera() async {
    final nombre = _nombreCarreraController.text.trim();
    final id = _idCarreraController.text.trim();

    if (nombre.isEmpty) {
      showSnackcError("Ingrese el nombre de la carrera");
      return;
    }
    if (id.isEmpty) {
      showSnackcError("Ingrese o genere el ID de la carrera");
      return;
    }
    final idOk = RegExp(r'^[a-z0-9\-_]{3,32}$').hasMatch(id);
    if (!idOk) {
      showSnackcError(
        "El ID debe tener 3-32 caracteres y solo usar a-z, 0-9, '-' o '_'.",
      );
      return;
    }

    try {
      final creado = await FirebaseFirestore.instance.runTransaction<bool>((
        tx,
      ) async {
        final docRef = FirebaseFirestore.instance
            .collection('Carreras')
            .doc(id);
        final snap = await tx.get(docRef);
        if (snap.exists) return false;

        tx.set(docRef, {
          'id': id,
          'nombre': nombre,
          'dateCreate': FieldValue.serverTimestamp(),
        });
        return true;
      });

      if (!mounted) return;

      if (creado) {
        showSnackcSuccess("Carrera registrada correctamente");
        _nombreCarreraController.clear();
        _idCarreraController.clear();
      } else {
        showSnackcError("Ya existe una carrera con ese ID");
      }
    } catch (e) {
      showSnackcError("Error al guardar: $e");
    }
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: 1.2),
  );

  @override
  Widget build(BuildContext context) {
    final nombreNoVacio = _nombreCarreraController.text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: AppColors.onSurface,
        elevation: 8,
        shadowColor: AppColors.primaryLight.withOpacity(0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ingrese los datos de la carrera que desea registrar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onPrimaryText,
                  ),
                ),
                const SizedBox(height: 20),

                // NOMBRE
                TextField(
                  controller: _nombreCarreraController,
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    labelText: 'Nombre de la carrera',
                    labelStyle: const TextStyle(
                      color: AppColors.onSecondaryText,
                    ),
                    prefixIcon: const Icon(
                      Icons.menu_book,
                      color: AppColors.primary,
                    ),
                    filled: true,
                    fillColor: AppColors.onSurface,
                    enabledBorder: _border(AppColors.onBorderTextField),
                    focusedBorder: _border(AppColors.primary),
                    errorBorder: _border(AppColors.electricError),
                    focusedErrorBorder: _border(AppColors.electricError),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),

                // ID + BOTÓN GENERAR
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _idCarreraController,
                      cursorColor: AppColors.primary,
                      decoration: InputDecoration(
                        labelText: 'ID de la carrera',
                        helperText: "Puede escribirlo o generarlo del nombre",
                        helperStyle: const TextStyle(
                          color: AppColors.onSecondaryText,
                        ),
                        prefixIcon: const Icon(
                          Icons.tag,
                          color: AppColors.primary,
                        ),
                        filled: true,
                        fillColor: AppColors.onSurface,
                        enabledBorder: _border(AppColors.onBorderTextField),
                        focusedBorder: _border(AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Tooltip(
                      message: 'Generar ID a partir del nombre',
                      child: ElevatedButton.icon(
                        onPressed: nombreNoVacio
                            ? () {
                                final generado = _generarIdDesdeNombre(
                                  _nombreCarreraController.text,
                                );
                                setState(
                                  () => _idCarreraController.text = generado,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.auto_fix_high),
                        label: const Text('Generar ID automáticamente'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.secondary, // botón secundario
                          foregroundColor:
                              AppColors.onPrimaryText, // texto/ícono oscuro
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // GUARDAR
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'Guardar Carrera',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: _guardarCarrera,
                  ),
                ),

                const SizedBox(height: 8),
                const Divider(color: AppColors.onLineDivider, height: 24),
                Row(
                  children: const [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.onTertiaryText,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'El ID debe ser único. Usa “Generar ID” para crear uno en base al nombre.',
                        style: TextStyle(
                          color: AppColors.onTertiaryText,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
