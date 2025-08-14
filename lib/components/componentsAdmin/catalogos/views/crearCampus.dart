import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/controllers/campusController.dart';
import 'package:uth_request_flutter_application/components/utils/alerts.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

// usa el controlador unificado
class AgregarCampusTab extends StatefulWidget {
  const AgregarCampusTab({super.key});

  @override
  State<AgregarCampusTab> createState() => _AgregarCampusTabState();
}

class _AgregarCampusTabState extends State<AgregarCampusTab> {
  final TextEditingController _lugarCampusController = TextEditingController();
  final CampusController _controller = CampusController();

  bool _saving = false;

  Future<void> _guardarCampus() async {
    final nombre = _lugarCampusController.text.trim();
    if (nombre.isEmpty) {
      showSnackcError("Ingrese el nombre de un lugar para registrar");
      return;
    }

    setState(() => _saving = true);
    try {
      final creado = await _controller.create(nombre);

      if (!mounted) return;

      if (creado) {
        showSnackcSuccess("Campus registrado correctamente");
        _lugarCampusController.clear();
      } else {
        showSnackcError("Ya existe un campus con ese nombre");
      }
    } catch (e) {
      showSnackcError("Error al guardar: $e");
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: 1.2),
      );

  @override
  void dispose() {
    _lugarCampusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  'Ingrese los datos del campus que desea registrar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onPrimaryText,
                  ),
                ),
                const SizedBox(height: 20),

                // TextField
                TextField(
                  controller: _lugarCampusController,
                  cursorColor: AppColors.primary,
                  enabled: !_saving,
                  decoration: InputDecoration(
                    labelText: 'Ubicación del campus',
                    labelStyle: const TextStyle(color: AppColors.onSecondaryText),
                    prefixIcon: const Icon(Icons.location_on, color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.onSurface,
                    enabledBorder: _border(AppColors.onBorderTextField),
                    focusedBorder: _border(AppColors.primary),
                    errorBorder: _border(AppColors.electricError),
                    focusedErrorBorder: _border(AppColors.electricError),
                    helperText: 'Ejemplo: EL PROGRESO • PUERTO CORTES',
                    helperStyle: const TextStyle(color: AppColors.onSecondaryText),
                  ),
                ),
                const SizedBox(height: 20),

                // Botón Guardar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: _saving
                        ? const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                        : const Icon(Icons.save),
                    label: Text(
                      _saving ? 'Guardando...' : 'Guardar Campus',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ).copyWith(
                      overlayColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return AppColors.primarySecondary.withOpacity(0.15);
                        }
                        return null;
                      }),
                    ),
                    onPressed: _saving ? null : _guardarCampus,
                  ),
                ),

                const SizedBox(height: 8),
                const Divider(color: AppColors.onLineDivider, height: 24),
                Row(
                  children: const [
                    Icon(Icons.info_outline, color: AppColors.onTertiaryText, size: 18),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Recuerda: evita duplicados usando el mismo nombre de campus.',
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
