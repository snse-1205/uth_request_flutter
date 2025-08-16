import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/auth/register/controllers/registrar_controller.dart';
import 'package:uth_request_flutter_application/components/auth/register/models/estudiantes_models.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/controllers/campusController.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/controllers/carrerasController.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/models/campusModel.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/models/carrerasModel.dart';
import 'package:uth_request_flutter_application/components/utils/alerts.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class CrearUsuarioTab extends StatefulWidget {
  const CrearUsuarioTab({super.key});

  @override
  State<CrearUsuarioTab> createState() => _CrearUsuarioTabState();
}

class _CrearUsuarioTabState extends State<CrearUsuarioTab> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _cuentaController = TextEditingController();
  final CarreraController _controllercarrera = CarreraController();
  final CampusController _controllercampus = CampusController();
  List<DocumentReference> _carrerasSeleccionadas = [];
  String? _rolSeleccionado;
  String? _carreraSeleccionado;
  String? _campusSeleccionado;
  bool _saving = false;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: 1.2),
  );

  Future<void> _guardarUsuario() async {
    final nombre = _nombreController.text.trim();
    final apellido = _apellidoController.text.trim();
    final correo = _correoController.text.trim();
    final contrasena = _contrasenaController.text.trim();
    final cuenta = _cuentaController.text.trim();
    DocumentReference campusRef = FirebaseFirestore.instance
        .collection('Campus')
        .doc(_campusSeleccionado);

    final controller = Get.find<RegisterController>();
    final estudiante = EstudianteModel(
      nombre: nombre,
      apellido: apellido,
      correo: correo,
      campus: campusRef,
      carrera: _carrerasSeleccionadas,
      cuenta: cuenta,
      rol: _rolSeleccionado.toString(),
    );

    if (nombre.isEmpty ||
        apellido.isEmpty ||
        correo.isEmpty ||
        contrasena.isEmpty) {
      showSnackcError("Complete todos los campos");
      return;
    }
    if (_rolSeleccionado == null) {
      showSnackcError("Seleccione un rol");
      return;
    }

    setState(() => _saving = true);

    try {
      String? error = await controller.registrarEstudiante(
        correo: correo,
        contrasena: contrasena,
        estudiante: estudiante,
      );

      showSnackcSuccess("Usuario registrado correctamente");
      _nombreController.clear();
      _apellidoController.clear();
      _correoController.clear();
      _contrasenaController.clear();
      setState(() => _rolSeleccionado = null);
    } catch (e) {
      showSnackcError("Error al registrar: $e");
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Registrar nuevo usuario",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onPrimaryText,
                  ),
                ),
                SizedBox(height: 20),

                // NOMBRE
                TextField(
                  controller: _cuentaController,
                  decoration: InputDecoration(
                    labelText: "Cuenta Estudiantil",
                    prefixIcon: Icon(Icons.person, color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.onSurface,
                    enabledBorder: _border(AppColors.onBorderTextField),
                    focusedBorder: _border(AppColors.primary),
                  ),
                ),
                SizedBox(height: 16),

                // NOMBRE
                TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    labelText: "Nombre",
                    prefixIcon: Icon(Icons.person, color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.onSurface,
                    enabledBorder: _border(AppColors.onBorderTextField),
                    focusedBorder: _border(AppColors.primary),
                  ),
                ),
                SizedBox(height: 16),

                // APELLIDO
                TextField(
                  controller: _apellidoController,
                  decoration: InputDecoration(
                    labelText: "Apellido",
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: AppColors.primary,
                    ),
                    filled: true,
                    fillColor: AppColors.onSurface,
                    enabledBorder: _border(AppColors.onBorderTextField),
                    focusedBorder: _border(AppColors.primary),
                  ),
                ),
                SizedBox(height: 16),

                // CORREO
                TextField(
                  controller: _correoController,
                  decoration: InputDecoration(
                    labelText: "Correo electrónico",
                    prefixIcon: Icon(Icons.email, color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.onSurface,
                    enabledBorder: _border(AppColors.onBorderTextField),
                    focusedBorder: _border(AppColors.primary),
                  ),
                ),
                SizedBox(height: 16),

                // CONTRASEÑA
                TextField(
                  controller: _contrasenaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: AppColors.primary,
                    ),
                    filled: true,
                    fillColor: AppColors.onSurface,
                    enabledBorder: _border(AppColors.onBorderTextField),
                    focusedBorder: _border(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 16),

                StreamBuilder<List<CampusModel>>(
                  stream: _controllercampus.streamAll(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final campus = snapshot.data!;

                    return DropdownButtonFormField<String>(
                      value: _campusSeleccionado,
                      items: campus.map((c) {
                        return DropdownMenuItem<String>(
                          value:
                              c.id, // o c.nombre, según lo que quieras guardar
                          child: Text(c.id),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _campusSeleccionado = value),
                      decoration: InputDecoration(
                        labelText: "Campus",
                        prefixIcon: const Icon(
                          Icons.school,
                          color: AppColors.primary,
                        ),
                        filled: true,
                        fillColor: AppColors.onSurface,
                        enabledBorder: _border(AppColors.onBorderTextField),
                        focusedBorder: _border(AppColors.primary),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _abrirSelectorCarreras,
                      icon: const Icon(Icons.list),
                      label: const Text('Seleccionar Carreras'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
                if (_carrerasSeleccionadas.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _carrerasSeleccionadas.map((ref) {
                      return FutureBuilder<DocumentSnapshot>(
                        future: ref.get(),
                        builder: (context, snapshot) {
                          final nombre = snapshot.hasData
                              ? ((snapshot.data!.data()
                                            as Map<String, dynamic>?)?['nombre']
                                        as String?) ??
                                    ref.id
                              : ref.id;

                          return Chip(
                            label: Text(nombre),
                            onDeleted: () {
                              setState(
                                () => _carrerasSeleccionadas.remove(ref),
                              );
                            },
                            backgroundColor: AppColors.primaryLight.withOpacity(
                              0.2,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),

                // DROPDOWN ROL
                DropdownButtonFormField<String>(
                  value: _rolSeleccionado,
                  items: const [
                    DropdownMenuItem(
                      value: "estudiante",
                      child: Text("Estudiante"),
                    ),
                    DropdownMenuItem(
                      value: "administrador",
                      child: Text("Administrador"),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => _rolSeleccionado = value),
                  decoration: InputDecoration(
                    labelText: "Rol",
                    prefixIcon: const Icon(
                      Icons.verified_user,
                      color: AppColors.primary,
                    ),
                    filled: true,
                    fillColor: AppColors.onSurface,
                    enabledBorder: _border(AppColors.onBorderTextField),
                    focusedBorder: _border(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 24),

                // BOTÓN GUARDAR
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(_saving ? "Guardando..." : "Guardar Usuario"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _saving ? null : _guardarUsuario,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _abrirSelectorCarreras() async {
    final seleccion = await showModalBottomSheet<List<DocumentReference>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.onSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => const _CarreraMultiSelectSheet(),
    );
    if (seleccion != null) {
      setState(() => _carrerasSeleccionadas = seleccion);
    }
  }
}

class _CarreraMultiSelectSheet extends StatefulWidget {
  const _CarreraMultiSelectSheet();
  @override
  State<_CarreraMultiSelectSheet> createState() =>
      _CarreraMultiSelectSheetState();
}

class _CarreraMultiSelectSheetState extends State<_CarreraMultiSelectSheet> {
  final _seleccion = <DocumentReference, bool>{};

  @override
  Widget build(BuildContext context) {
    final padding =
        MediaQuery.of(context).viewInsets + const EdgeInsets.all(16);
    return Padding(
      padding: padding,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 60,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.onBorderTextField,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Selecciona carreras',
              style: TextStyle(
                color: AppColors.onPrimaryText,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Carreras')
                    .orderBy(FieldPath.documentId)
                    .snapshots(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (!snap.hasData || snap.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        'No hay carreras registradas',
                        style: TextStyle(color: AppColors.onSecondaryText),
                      ),
                    );
                  }
                  final docs = snap.data!.docs;
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const Divider(
                      color: AppColors.onLineDivider,
                      height: 1,
                    ),
                    itemBuilder: (context, i) {
                      final d = docs[i];
                      final ref = d.reference;
                      final data = d.data() as Map<String, dynamic>;
                      final nombre = data['nombre'] ?? d.id;
                      final checked = _seleccion[ref] ?? false;
                      return CheckboxListTile(
                        value: checked,
                        onChanged: (v) =>
                            setState(() => _seleccion[ref] = v ?? false),
                        title: Text(
                          nombre,
                          style: const TextStyle(
                            color: AppColors.onPrimaryText,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppColors.primary,
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final seleccionadas = _seleccion.entries
                          .where((e) => e.value)
                          .map((e) => e.key)
                          .toList();
                      if (seleccionadas.isEmpty) {
                        showSnackcError("Selecciona al menos una carrera");
                        return;
                      }
                      Navigator.pop(context, seleccionadas);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Aceptar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
