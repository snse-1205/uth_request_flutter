import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uth_request_flutter_application/components/utils/alerts.dart';

class AgregarCampusTab extends StatefulWidget {
  const AgregarCampusTab({super.key});

  @override
  State<AgregarCampusTab> createState() => _AgregarCampusTabState();
}

class _AgregarCampusTabState extends State<AgregarCampusTab> {
  final TextEditingController _lugarCampusController = TextEditingController();

  Future<void> _guardarCampus() async {
  final nombre = _lugarCampusController.text.trim();
  if (nombre.isEmpty) {
    showSnackcError("Ingrese el nombre de un lugar para registrar");
    return;
  }

  // Opcional: normalizar para unicidad case-insensitive
  final docId = nombre.toLowerCase();

  try {
    final creado = await FirebaseFirestore.instance
        .runTransaction<bool>((tx) async {
      final docRef = FirebaseFirestore.instance.collection('Campus').doc(docId);

      final snap = await tx.get(docRef);
      if (snap.exists) {
        return false;
      }

      tx.set(docRef, {
        'dateCreate': FieldValue.serverTimestamp(),
      });
      return true;
    });

    if (!mounted) return;

    if (creado) {
      showSnackcSuccess("Campus registrado correctamente");
      _lugarCampusController.clear();
    } else {
      showSnackcError("Ya existe un campus con ese nombre");
    }
  } catch (e) {
    showSnackcError("Error al guardar: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ingrese los datos del campus que desea registrar',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _lugarCampusController,
                  decoration: InputDecoration(
                    labelText: 'Ubicacion del campus',
                    prefixIcon: const Icon(Icons.school),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar Campus'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _guardarCampus,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
