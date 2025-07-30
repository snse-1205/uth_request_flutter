import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class SubjectSelectionScreen extends StatelessWidget {
  const SubjectSelectionScreen({super.key});

  final List<String> options = const [
    'Matematica I',
    'Administraicon I',
    'Introduccion a la ingenieria computacional',
    'Español I',
    'Analisis y diselo de algoritmos'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onBackgroundDefault,
      appBar: AppBar(
        foregroundColor: AppColors.onSurface,
        backgroundColor: AppColors.primary,
        title: const Text('Seleccionar asignatura'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: options.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Card(
            color: AppColors.onSurface,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                options[index],
                style: const TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context, options[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
