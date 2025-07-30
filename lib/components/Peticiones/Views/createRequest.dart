import 'package:flutter/material.dart';

class CreateRequest extends StatefulWidget {
  const CreateRequest({super.key});

  @override
  State<CreateRequest> createState() => _CreateRequestState();
}

class _CreateRequestState extends State<CreateRequest> {
  // Controladores y variables de estado
  String requestType = 'APERTURA DE CLASE';
  String? selectedSubject;
  String? selectedDay;
  String modality = 'Presencial';
  TimeOfDay startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 0, minute: 0);

  final List<String> requestTypes = ['APERTURA DE CLASE', 'OTRA OPCIÓN'];
  final List<String> subjects = ['Asignatura 1', 'Asignatura 2', 'Asignatura 3'];
  final List<String> days = ['Semana lunes-jueves', 'Fin de semana'];

  // Método para seleccionar hora
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
      appBar: AppBar(title: const Text('CREAR PETICIÓN')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown de tipo de petición
            DropdownButtonFormField<String>(
              value: requestType,
              items: requestTypes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  requestType = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Tipo de Petición',
              ),
            ),
            const SizedBox(height: 10),

            const Text('PERIODO 03-2025'),

            // Dropdown de asignatura
            DropdownButtonFormField<String>(
              value: selectedSubject,
              items: subjects
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubject = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Asignatura',
              ),
            ),
            const SizedBox(height: 10),

            // Radio buttons de modalidad
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
                ),
                const Text('Presencial'),
                Radio<String>(
                  value: 'Presencial-ZOOM',
                  groupValue: modality,
                  onChanged: (value) {
                    setState(() {
                      modality = value!;
                    });
                  },
                ),
                const Text('Presencial-ZOOM'),
              ],
            ),
            const Text(
              '*Si elige presencial, automáticamente será en el campus de tu perfil seleccionado',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 10),

            // Dropdown de días
            DropdownButtonFormField<String>(
              value: selectedDay,
              items: days
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDay = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Fecha',
              ),
            ),
            const SizedBox(height: 10),

            // Selección de hora de inicio y fin
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context, true),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Inicio',
                      ),
                      child: Text(startTime.format(context)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context, false),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Fin',
                      ),
                      child: Text(endTime.format(context)),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),

            // Botón de enviar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aquí podrías validar y enviar la petición
                  print('Petición enviada');
                },
                child: const Text('ENVIAR PETICIÓN'),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '*Puede crear una petición, pero será cuestión del administrador aceptar la apertura de esta clase. Se le notificará al administrador de esta petición',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
