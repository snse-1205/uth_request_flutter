import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uth_request_flutter_application/components/Peticiones/Controllers/controller.dart';
import 'package:uth_request_flutter_application/components/Peticiones/Models/createRequestModel.dart';

class CreateRequestView extends StatefulWidget {
  final String studentDocId; // id de documento en Estudiantes/{id}

  const CreateRequestView({super.key, required this.studentDocId});

  @override
  State<CreateRequestView> createState() => _CreateRequestViewState();
}

class _CreateRequestViewState extends State<CreateRequestView> {
  // Fijo
  static const String _requestType = 'APERTURA DE CLASE';

  // Estado de UI
  String? _selectedClassId;
  String _modality = 'Presencial';
  String? _selectedDay;
  TimeOfDay _startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 0, minute: 0);

  final _days = const ['Semana lunes-jueves', 'Fin de semana'];

  final _controller = ClassRequestController();
  late Future<List<ClaseItem>> _futureClasses;

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  String _fmt(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
    // Si quieres 12h con AM/PM, ajusta aquí.
  }

  @override
  void initState() {
    super.initState();
    _futureClasses = _controller.fetchAvailableClasses(widget.studentDocId);
  }

  Future<void> _onSubmit() async {
    if (_selectedClassId == null || _selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona clase, día y horarios')),
      );
      return;
    }

    final payload = PeticionCreate(
      tipo: _requestType,
      claseId: _selectedClassId!,
      modalidad: _modality,
      dia: _selectedDay!,
      horaInicio: _fmt(_startTime),
      horaFin: _fmt(_endTime),
      estudianteId: widget.studentDocId,
      estado: 'espera aprobación',
      dateCreate:
          Timestamp.now(), // o FieldValue.serverTimestamp() desde controller si prefieres
    );

    try {
      await _controller.createRequest(payload);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Petición creada')));
        Navigator.of(context).pop(); // opcional
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al crear petición: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reemplaza colores/estilos con los tuyos (AppColors, etc.) si lo deseas
    return Scaffold(
      appBar: AppBar(title: const Text('Crear petición')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tipo fijo
            Card(
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'APERTURA DE CLASE',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Dropdown de clases disponibles
            FutureBuilder<List<ClaseItem>>(
              future: _futureClasses,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Text('Error al cargar clases: ${snap.error}');
                }
                final classes = snap.data ?? [];
                if (classes.isEmpty) {
                  return const Text(
                    'No hay clases disponibles para solicitar.',
                  );
                }
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: DropdownButtonFormField<String>(
                      value: _selectedClassId,
                      items: classes
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.id,
                              child: Text('${c.nombre} (${c.id})'),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedClassId = v),
                      decoration: const InputDecoration(
                        labelText: 'Selecciona una asignatura',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // Modalidad
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Presencial',
                          groupValue: _modality,
                          onChanged: (v) => setState(() => _modality = v!),
                        ),
                        const Text('Presencial'),
                        const SizedBox(width: 12),
                        Radio<String>(
                          value: 'Presencial-ZOOM',
                          groupValue: _modality,
                          onChanged: (v) => setState(() => _modality = v!),
                        ),
                        const Text('Presencial-ZOOM'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Selecciona la modalidad de la clase.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Días
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButtonFormField<String>(
                  value: _selectedDay,
                  items: _days
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedDay = v),
                  decoration: const InputDecoration(
                    labelText: 'Días',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Horarios manuales
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: InkWell(
                        onTap: () => _pickTime(true),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Hora inicio',
                            border: InputBorder.none,
                          ),
                          child: Text(_fmt(_startTime)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: InkWell(
                        onTap: () => _pickTime(false),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Hora fin',
                            border: InputBorder.none,
                          ),
                          child: Text(_fmt(_endTime)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Enviar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSubmit,
                child: const Text('Enviar petición'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
