import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uth_request_flutter_application/components/utils/alerts.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class CrearClaseTab extends StatefulWidget {
  const CrearClaseTab({super.key});
  @override
  State<CrearClaseTab> createState() => _CrearClaseTabState();
}

class _CrearClaseTabState extends State<CrearClaseTab> {
  final _idController = TextEditingController();
  final _nombreController = TextEditingController();

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: c, width: 1.2),
  );

  Future<void> _guardar() async {
    final id = _idController.text.trim();
    final nombre = _nombreController.text.trim();

    if (id.isEmpty || nombre.isEmpty) {
      showSnackcError("Completa ID y nombre de clase");
      return;
    }

    try {
      final ok = await FirebaseFirestore.instance.runTransaction<bool>((tx) async {
        final docRef = FirebaseFirestore.instance.collection('Clases').doc(id);
        final snap = await tx.get(docRef);
        if (snap.exists) return false;

        tx.set(docRef, {
          'nombre': nombre,
          'dateCreate': FieldValue.serverTimestamp(),
        });
        return true;
      });

      if (!mounted) return;
      if (ok) {
        showSnackcSuccess("Clase creada");
        _idController.clear();
        _nombreController.clear();
      } else {
        showSnackcError("Ya existe una clase con ese ID");
      }
    } catch (e) {
      showSnackcError("Error al guardar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: AppColors.onSurface,
        elevation: 8,
        shadowColor: AppColors.primaryLight.withOpacity(0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Registrar clase',
                  style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800,
                    color: AppColors.onPrimaryText)),
              const SizedBox(height: 16),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'ID de clase (p.ej. CAE-0504)',
                  labelStyle: const TextStyle(color: AppColors.onSecondaryText),
                  prefixIcon: const Icon(Icons.tag, color: AppColors.primary),
                  filled: true, fillColor: AppColors.onSurface,
                  enabledBorder: _border(AppColors.onBorderTextField),
                  focusedBorder: _border(AppColors.primary),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la clase',
                  labelStyle: const TextStyle(color: AppColors.onSecondaryText),
                  prefixIcon: const Icon(Icons.menu_book, color: AppColors.primary),
                  filled: true, fillColor: AppColors.onSurface,
                  enabledBorder: _border(AppColors.onBorderTextField),
                  focusedBorder: _border(AppColors.primary),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _guardar,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar Clase',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
