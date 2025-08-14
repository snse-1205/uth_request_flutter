import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uth_request_flutter_application/components/utils/alerts.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class VincularClaseCarrerasTab extends StatefulWidget {
  const VincularClaseCarrerasTab({super.key});
  @override
  State<VincularClaseCarrerasTab> createState() => _VincularClaseCarrerasTabState();
}

class _VincularClaseCarrerasTabState extends State<VincularClaseCarrerasTab> {
  /// Clase seleccionada (como referencia)
  DocumentReference? _claseRef;

  /// Carreras seleccionadas
  List<DocumentReference> _carrerasSeleccionadas = [];

  /// Requisito (ref a Clases) – OPCIONAL
  DocumentReference? _requisitoRef;

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c, width: 1.2),
      );

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

  Future<void> _abrirSelectorClase() async {
    final ref = await showModalBottomSheet<DocumentReference?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.onSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => const _ClaseSearchSheet(),
    );
    if (ref != null) setState(() => _claseRef = ref);
  }

  Future<void> _abrirSelectorRequisito() async {
    final ref = await showModalBottomSheet<DocumentReference?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.onSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => const _ClaseSearchSheet(),
    );
    if (ref != null) setState(() => _requisitoRef = ref);
  }

  Future<void> _guardarVinculo() async {
    if (_claseRef == null) {
      showSnackcError("Selecciona la clase a vincular");
      return;
    }
    if (_carrerasSeleccionadas.isEmpty) {
      showSnackcError("Selecciona al menos una carrera");
      return;
    }

    try {
      // ID automático (una clase puede tener múltiples registros por carrera)
      final intermediaRef =
          FirebaseFirestore.instance.collection('ClasesPorCarrera').doc();

      final data = <String, dynamic>{
        'clase': _claseRef,
        'carreras': _carrerasSeleccionadas,
        'horarios': <Map<String, dynamic>>[],
        'dateCreate': FieldValue.serverTimestamp(),
      };
      if (_requisitoRef != null) data['requisito'] = _requisitoRef; // opcional

      await intermediaRef.set(data);

      showSnackcSuccess("Vínculo guardado");
      setState(() {
        _carrerasSeleccionadas = [];
        _requisitoRef = null;
        // Si quieres mantener la clase seleccionada, no la limpies:
        // _claseRef = null;
      });
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
              const Text('Vincular clase con carreras',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onPrimaryText)),
              const SizedBox(height: 16),

              // === Clase (selector por buscador) ===
              ElevatedButton.icon(
                onPressed: _abrirSelectorClase,
                icon: const Icon(Icons.search),
                label: const Text('Seleccionar clase'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              if (_claseRef != null) ...[
                const SizedBox(height: 8),
                FutureBuilder<DocumentSnapshot>(
                  future: _claseRef!.get(),
                  builder: (context, s) {
                    final label = s.hasData
                        ? "${_claseRef!.id} — ${((s.data!.data() as Map<String, dynamic>?)?['nombre'] ?? '')}"
                        : _claseRef!.id;
                    return Chip(
                      label: Text(label),
                      onDeleted: () => setState(() => _claseRef = null),
                    );
                  },
                ),
              ],

              const SizedBox(height: 12),

              // === Carreras (multi‑select) ===
              ElevatedButton.icon(
                onPressed: _abrirSelectorCarreras,
                icon: const Icon(Icons.list),
                label: const Text('Seleccionar carreras'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),

              if (_carrerasSeleccionadas.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _carrerasSeleccionadas.map((ref) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: ref.get(),
                      builder: (context, s) {
                        final label = s.hasData
                            ? ((s.data!.data() as Map<String, dynamic>?)?['nombre'] ?? ref.id)
                            : ref.id;
                        return Chip(
                          label: Text(label),
                          onDeleted: () => setState(
                              () => _carrerasSeleccionadas.remove(ref)),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 16),

              // === Requisito (OPCIONAL) ===
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _abrirSelectorRequisito,
                      icon: const Icon(Icons.search),
                      label: const Text("Seleccionar requisito (opcional)"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              if (_requisitoRef != null) ...[
                const SizedBox(height: 8),
                FutureBuilder<DocumentSnapshot>(
                  future: _requisitoRef!.get(),
                  builder: (context, s) {
                    final label = s.hasData
                        ? "${_requisitoRef!.id} — ${((s.data!.data() as Map<String, dynamic>?)?['nombre'] ?? '')}"
                        : _requisitoRef!.id;
                    return Chip(
                      label: Text(label),
                      onDeleted: () => setState(() => _requisitoRef = null),
                    );
                  },
                ),
              ],

              const Spacer(),

              // === Guardar ===
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _guardarVinculo,
                  icon: const Icon(Icons.save_alt),
                  label: const Text('Guardar Vínculo',
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

/// Modal multi‑select de Carreras -> List<DocumentReference>
class _CarreraMultiSelectSheet extends StatefulWidget {
  const _CarreraMultiSelectSheet();
  @override
  State<_CarreraMultiSelectSheet> createState() => _CarreraMultiSelectSheetState();
}

class _CarreraMultiSelectSheetState extends State<_CarreraMultiSelectSheet> {
  final _seleccion = <DocumentReference, bool>{};

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).viewInsets + const EdgeInsets.all(16);
    return Padding(
      padding: padding,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4, width: 60, margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.onBorderTextField,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text('Selecciona carreras',
                style: TextStyle(
                    color: AppColors.onPrimaryText,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
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
                      child: Text('No hay carreras registradas',
                          style: TextStyle(color: AppColors.onSecondaryText)),
                    );
                  }
                  final docs = snap.data!.docs;
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: docs.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: AppColors.onLineDivider, height: 1),
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
                        title: Text(nombre,
                            style:
                                const TextStyle(color: AppColors.onPrimaryText)),
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
                        child: const Text('Cancelar'))),
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
                )),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// Modal con buscador de clases; retorna UNA referencia (clase o requisito)
class _ClaseSearchSheet extends StatefulWidget {
  const _ClaseSearchSheet();

  @override
  State<_ClaseSearchSheet> createState() => _ClaseSearchSheetState();
}

class _ClaseSearchSheetState extends State<_ClaseSearchSheet> {
  final _queryCtl = TextEditingController();
  String _q = "";

  @override
  void initState() {
    super.initState();
    _queryCtl.addListener(
        () => setState(() => _q = _queryCtl.text.trim().toLowerCase()));
  }

  @override
  void dispose() {
    _queryCtl.dispose();
    super.dispose();
  }

  bool _match(String id, Map<String, dynamic> data) {
    final nombre = (data['nombre'] ?? '').toString().toLowerCase();
    final q = _q;
    if (q.isEmpty) return true;
    // Búsqueda simple: contiene en nombre o empieza por ID
    return nombre.contains(q) || id.toLowerCase().startsWith(q);
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).viewInsets +
        const EdgeInsets.fromLTRB(16, 16, 16, 16);
    return Padding(
      padding: pad,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4, width: 60, margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.onBorderTextField,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text('Buscar clase',
                style: TextStyle(
                    color: AppColors.onPrimaryText,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
            const SizedBox(height: 8),

            TextField(
              controller: _queryCtl,
              decoration: InputDecoration(
                hintText: 'Código (ID) o nombre...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.onSurface,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: AppColors.onBorderTextField, width: 1.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.2),
                ),
              ),
            ),
            const SizedBox(height: 8),

            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                // Traemos todas y filtramos en cliente.
                stream: FirebaseFirestore.instance
                    .collection('Clases')
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
                      child: Text('No hay clases registradas',
                          style: TextStyle(color: AppColors.onSecondaryText)),
                    );
                  }

                  final filtered = snap.data!.docs
                      .where((d) =>
                          _match(d.id, d.data() as Map<String, dynamic>))
                      .toList();

                  if (filtered.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text('Sin resultados',
                          style: TextStyle(color: AppColors.onSecondaryText)),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: AppColors.onLineDivider, height: 1),
                    itemBuilder: (context, i) {
                      final d = filtered[i];
                      final data = d.data() as Map<String, dynamic>;
                      final nombre = data['nombre'] ?? '';
                      return ListTile(
                        title: Text("${d.id} — $nombre",
                            style: const TextStyle(color: AppColors.onPrimaryText)),
                        trailing: const Icon(Icons.check_circle_outline),
                        onTap: () => Navigator.pop(context, d.reference),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("Cancelar"),
            ),
          ],
        ),
      ),
    );
  }
}
