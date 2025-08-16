import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/Peticiones/Controllers/controller.dart';
import 'package:uth_request_flutter_application/components/Peticiones/Models/createRequestModel.dart';
import 'package:uth_request_flutter_application/components/Peticiones/Views/subjectSelectionScreen.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class CreateRequest extends StatefulWidget {
  const CreateRequest({super.key});

  @override
  State<CreateRequest> createState() => _CreateRequestState();
}

class _CreateRequestState extends State<CreateRequest> {
  String requestType = 'APERTURA DE CLASE';
  String? selectedSubject;
  String? selectedDay;
  String modality = 'Presencial';
  TimeOfDay startTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 0, minute: 0);

  final List<String> requestTypes = ['APERTURA DE CLASE', 'OTRA OPCIÓN'];
  final List<String> days = ['Semana lunes-jueves', 'Fin de semana'];

  // ======= LÓGICA AÑADIDA =======
  // final _storage = GetStorage(); // si manejas cuenta/ID localmente
  final _reqController = ClassRequestController();
  bool _sending = false;

  String _fmt(TimeOfDay t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  String? _validate() {
    if (selectedSubject == null || selectedSubject!.isEmpty) {
      return "Selecciona una asignatura";
    }
    if (selectedDay == null || selectedDay!.isEmpty) {
      return "Selecciona un día";
    }
    final start = startTime.hour * 60 + startTime.minute;
    final end   = endTime.hour * 60 + endTime.minute;
    if (start == 0 && end == 0) {
      return "Selecciona hora de inicio y fin";
    }
    if (end <= start) {
      return "La hora fin debe ser mayor que la hora inicio";
    }
    return null;
  }

  Future<void> _enviarPeticion() async {
    final err = _validate();
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }

    setState(() => _sending = true);
    try {
      // Obtén el id/cuenta del estudiante como lo manejes en tu app:
      // final estudianteId = (_storage.read('cuenta') ?? '').toString().trim();
      final estudianteId = ''; // <- pon aquí tu lógica real

      final payload = PeticionCreate(
        tipo: requestType,
        claseId: selectedSubject!,       // viene de SubjectSelectionScreen
        modalidad: modality,             // 'Presencial' o 'Presencial-ZOOM'
        dia: selectedDay!,               // 'Semana lunes-jueves' | 'Fin de semana'
        horaInicio: _fmt(startTime),     // 'HH:mm'
        horaFin: _fmt(endTime),          // 'HH:mm'
        estudianteId: estudianteId,      // tu id/cuenta
        estado: 'espera aprobación',     // estado inicial
        dateCreate: Timestamp.now(),     // o usa serverTimestamp en el backend
      );

      await _reqController.createRequest(payload);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Petición enviada")),
      );
      Navigator.pop(context); // cierra la pantalla si deseas
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al enviar petición: $e")),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }
  // ======= FIN LÓGICA AÑADIDA =======

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? startTime : endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown de tipo de petición
            Card(
              color: AppColors.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButtonFormField<String>(
                  value: requestType,
                  items: requestTypes
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      requestType = value!;
                    });
                  },
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
            SizedBox(height: 10),

            // Dropdown de asignatura
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubjectSelectionScreen(),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      selectedSubject = result;
                    });
                  }
                },
                child: Card(
                  color: AppColors.onSurface,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      selectedSubject ?? 'Selecciona una asignatura',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            // Radio buttons de modalidad
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
                          onChanged: (value) {
                            setState(() {
                              modality = value!;
                            });
                          },
                          fillColor: WidgetStateProperty.all(AppColors.primary),
                        ),
                        Text(CreateRequest_ModalidadPresencial),
                        Radio<String>(
                          value: 'Presencial-ZOOM',
                          groupValue: modality,
                          onChanged: (value) {
                            setState(() {
                              modality = value!;
                            });
                          },
                          fillColor: WidgetStateProperty.all(AppColors.primary),
                        ),
                        Text(CreateRequest_ModalidadZoom),
                      ],
                    ),
                    Text(
                      CreateRequest_ModalidadInfo,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            // Dropdown de días
            Card(
              color: AppColors.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButtonFormField<String>(
                  value: selectedDay,
                  items: days
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDay = value;
                    });
                  },
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

            SizedBox(height: 10),

            // Selección de hora de inicio y fin
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: AppColors.onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: InkWell(
                        onTap: () => _selectTime(context, true),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: CreateRequest_InicioLabel,
                            border: InputBorder.none,
                          ),
                          child: Text(
                            startTime.format(context),
                            style: TextStyle(color: AppColors.onPrimaryText),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    color: AppColors.onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: InkWell(
                        onTap: () => _selectTime(context, false),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: CreateRequest_FinLabel,
                            border: InputBorder.none,
                          ),
                          child: Text(
                            endTime.format(context),
                            style: TextStyle(color: AppColors.onPrimaryText),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Spacer(),

            // Botón de enviar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(AppColors.primary),
                  foregroundColor: WidgetStatePropertyAll(AppColors.onSurface),
                ),
                onPressed: _sending ? null : _enviarPeticion, // <-- aquí enviamos
                child: Text(
                  _sending ? "Enviando..." : CreateRequest_EnviarPeticionButton,
                ),
              ),
            ),

            SizedBox(height: 8),
            Text(
              CreateRequest_EnviarPeticionNota,
              style: TextStyle(fontSize: 11, color: AppColors.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
