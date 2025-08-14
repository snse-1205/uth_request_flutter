import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/views/crudCampus.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/views/crudCarreras.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart'; // 👈 para navegación con GetX

class PanelControl extends StatefulWidget {
  const PanelControl({super.key});

  @override
  State<PanelControl> createState() => _PanelControlState();
}

// Puedes dejar esta acción vacía si aún no navegas
void _accionVoid() {}

// MODELITO PARA LOS ITEMS
class _PanelItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  _PanelItem({required this.label, required this.icon, required this.onTap});
}

class _PanelControlState extends State<PanelControl> {
  final List<_PanelItem> _items = [
    // 👇 Ejemplos de navegación con GetX:
    _PanelItem(
      label: 'Campus',
      icon: Icons.location_city,
      onTap: () => Get.to(() => const CrudCampus()),
      // o: onTap: () => Get.toNamed('/campus'),
    ),
    _PanelItem(
      label: 'Carreras',
      icon: Icons.school,
      onTap: () => Get.to(() => const CrudCarreras()),
    ),
    _PanelItem(
      label: 'Profesores',
      icon: Icons.person,
      onTap: () => Get.to(() => const ProfesoresPage()),
    ),
    _PanelItem(
      label: 'Estudiantes',
      icon: Icons.groups,
      onTap: () => Get.to(() => const EstudiantesPage()),
    ),
    _PanelItem(
      label: 'Clases',
      icon: Icons.class_,
      onTap: () => Get.to(() => const ClasesPage()),
    ),
    _PanelItem(
      label: 'Ajustes',
      icon: Icons.settings,
      onTap: () => Get.to(() => const AjustesPage()),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
        children: _items.map(_buildCard).toList(),
      ),
    );
  }

  Widget _buildCard(_PanelItem item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: item.onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: 56,
                color: AppColors.primary, 
                // o: color: Colors.indigo,
              ),
              const SizedBox(height: 12),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====== EJEMPLOS DE PANTALLAS DESTINO (placeholders) ======

class CarrerasPage extends StatelessWidget {
  const CarrerasPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Carreras')));
}

class ProfesoresPage extends StatelessWidget {
  const ProfesoresPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Profesores')));
}

class EstudiantesPage extends StatelessWidget {
  const EstudiantesPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Estudiantes')));
}

class ClasesPage extends StatelessWidget {
  const ClasesPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Clases')));
}

class AjustesPage extends StatelessWidget {
  const AjustesPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Ajustes')));
}
