// components/Peticiones/Views/create_request.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:uth_request_flutter_application/components/Peticiones/Controllers/controller.dart';
import 'package:uth_request_flutter_application/components/Peticiones/Models/createRequestModel.dart';
import 'package:uth_request_flutter_application/components/Peticiones/Views/subjectSelectionScreen.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class CreateRequest extends StatefulWidget {
  const CreateRequest({super.key});

  @override
  State<CreateRequest> createState() => _CreateRequestState();
}

class _CreateRequestState extends State<CreateRequest> {
  String requestType = 'APERTURA DE CLASE';
  String? selectedSubjectId;     // <-- código
  String? selectedSubjectName;   // <-- nombre visible
  String? selectedDay;
  String modality = 'Presencial';
  TimeOfDay startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime   = const TimeOfDay(hour: 0, minute: 0);

  final List<String> requestTypes = ['APERTURA DE CLASE'];
  final List<String> days = ['Semana lunes-jueves','Semana lunes-miercoles','Fin de semana viernes', 'Fin de semana sabado', 'Fin de semana domingo'];

  final _reqController = ClassRequestController();
  final _storage = GetStorage();
  bool _sending = false;

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String? _validate() {
    if (selectedSubjectId == null || selectedSubjectId!.isEmpty) {
      return "Selecciona una asignatura";
    }
    if (selectedDay == null || selectedDay!.isEmpty) {
      return "Selecciona un día";
    }
    final start = startTime.hour * 60 + startTime.minute;
    final end   = endTime.hour * 60 + endTime.minute;
    if (start == 0 && end == 0) return "Selecciona hora de inicio y fin";
    if (end <= start) return "La hora fin debe ser mayor que la hora inicio";
    return null;
  }

  Future<void> _enviarPeticion() async {
    final err = _validate();
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }

    final uid = (_storage.read('uid') ?? '').toString().trim();
    if (uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se encontró el UID del usuario.")),
      );
      return;
    }

    setState(() => _sending = true);
    try {
      final payload = PeticionCreate(
        uid: uid,
        tipo: requestType,
        claseId: selectedSubjectId!,          // ← código a Firestore
        nombreClase: selectedSubjectName ?? '', // ← nombre para UI de tarjetas
        modalidad: modality,
        dia: selectedDay!,
        horaInicio: _fmt(startTime),
        horaFin: _fmt(endTime),
        meta: 10,
        dateCreate: Timestamp.now(),
      );

      await _reqController.createRequest(payload);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Petición enviada")),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al enviar petición: $e")),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? startTime : endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) startTime = picked; else endTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onBackgroundDefault,
      appBar: AppBar(
        foregroundColor: AppColors.onSurface,
        backgroundColor: AppColors.primary,
        title: Text(CreateRequest_CrearPeticionTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tipo
            Card(
              color: AppColors.onSurface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButtonFormField<String>(
                  value: requestType,
                  items: requestTypes
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => requestType = value!),
                  decoration: InputDecoration(
                    labelText: CreateRequest_TipoPeticionLabel,
                    filled: true,
                    fillColor: AppColors.onSurface,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  dropdownColor: AppColors.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Asignatura (muestra NOMBRE pero guarda CÓDIGO)
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.push<Map<String, String>>(
                    context,
                    MaterialPageRoute(builder: (_) => const SubjectSelectionScreen()),
                  );
                  if (result != null) {
                    setState(() {
                      selectedSubjectId   = result['id'];
                      selectedSubjectName = result['nombre'];
                    });
                  }
                },
                child: Card(
                  color: AppColors.onSurface,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      selectedSubjectName == null
                          ? 'Selecciona una asignatura'
                          : 'Asignatura: $selectedSubjectName',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Modalidad
            Card(
              color: AppColors.onSurface,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Presencial',
                          groupValue: modality,
                          onChanged: (v) => setState(() => modality = v!),
                          fillColor: WidgetStateProperty.all(AppColors.primary),
                        ),
                        Text(CreateRequest_ModalidadPresencial),
                        Radio<String>(
                          value: 'Presencial-ZOOM',
                          groupValue: modality,
                          onChanged: (v) => setState(() => modality = v!),
                          fillColor: WidgetStateProperty.all(AppColors.primary),
                        ),
                        Text(CreateRequest_ModalidadZoom),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'La solicitud de ZOOM depende de cupo autorizado.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Día
            Card(
              color: AppColors.onSurface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButtonFormField<String>(
                  value: selectedDay,
                  items: days.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => selectedDay = v),
                  decoration: InputDecoration(
                    labelText: CreateRequest_FechaLabel,
                    filled: true,
                    fillColor: AppColors.onSurface,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  dropdownColor: AppColors.onSurface,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Horas
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: AppColors.onSurface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: InkWell(
                        onTap: () => _selectTime(context, true),
                        child: InputDecorator(
                          decoration: InputDecoration(labelText: CreateRequest_InicioLabel, border: InputBorder.none),
                          child: Text(startTime.format(context), style: TextStyle(color: AppColors.onPrimaryText)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    color: AppColors.onSurface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: InkWell(
                        onTap: () => _selectTime(context, false),
                        child: InputDecorator(
                          decoration: InputDecoration(labelText: CreateRequest_FinLabel, border: InputBorder.none),
                          child: Text(endTime.format(context), style: TextStyle(color: AppColors.onPrimaryText)),
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
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(AppColors.primary),
                  foregroundColor: const WidgetStatePropertyAll(Colors.white),
                ),
                onPressed: _sending ? null : _enviarPeticion,
                child: Text(_sending ? "Enviando..." : CreateRequest_EnviarPeticionButton),
              ),
            ),
            const SizedBox(height: 8),
            Text(CreateRequest_EnviarPeticionNota, style: TextStyle(fontSize: 11, color: AppColors.onSurface)),
          ],
        ),
      ),
    );
  }
}
