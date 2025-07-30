import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';


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
  TimeOfDay startTime =  TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime =  TimeOfDay(hour: 0, minute: 0);

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
      appBar: AppBar(title: Text(CreateRequest_CrearPeticionTitle)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
              decoration:  InputDecoration(
                labelText: CreateRequest_TipoPeticionLabel,
              ),
            ),
             SizedBox(height: 10),

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
              decoration:  InputDecoration(
                labelText: CreateRequest_AsignaturaLabel,
              ),
            ),
             SizedBox(height: 10),

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
                 Text(CreateRequest_ModalidadPresencial),
                Radio<String>(
                  value: 'Presencial-ZOOM',
                  groupValue: modality,
                  onChanged: (value) {
                    setState(() {
                      modality = value!;
                    });
                  },
                ),
                 Text(CreateRequest_ModalidadZoom),
              ],
            ),
             Text(CreateRequest_ModalidadInfo,
              style: TextStyle(fontSize: 12),
            ),
             SizedBox(height: 10),

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
              decoration:  InputDecoration(
                labelText: CreateRequest_FechaLabel,
              ),
            ),
             SizedBox(height: 10),

            // Selección de hora de inicio y fin
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context, true),
                    child: InputDecorator(
                      decoration:  InputDecoration(
                        labelText: CreateRequest_InicioLabel,
                      ),
                      child: Text(startTime.format(context)),
                    ),
                  ),
                ),
                 SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context, false),
                    child: InputDecorator(
                      decoration:  InputDecoration(
                        labelText: CreateRequest_FinLabel,
                      ),
                      child: Text(endTime.format(context)),
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
                onPressed: () {
                  // Aquí podrías validar y enviar la petición
                  print('Petición enviada');
                },
                child:  Text(CreateRequest_EnviarPeticionButton),
              ),
            ),
             SizedBox(height: 8),
             Text(CreateRequest_EnviarPeticionNota,
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
