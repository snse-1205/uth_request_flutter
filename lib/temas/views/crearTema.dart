import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class CrearTemaPage extends StatelessWidget {
  const CrearTemaPage({
    super.key,
    required this.nombre,
    required this.apellido,
    required this.comentario,
  });
  final String nombre;
  final String apellido;
  final bool comentario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: comentario ? Text('Comenta') : Text('Crear Tema'),
        foregroundColor: AppColors.onSurface,
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (comentario) {
                Get.snackbar(
                  'Comentario creado',
                  'Aquí iría la accion de comentario por tema.',
                );
              } else {
                Get.snackbar(
                  'Tema creado',
                  'Aquí iría la accion de publicar tema.',
                );
              }
            },

            child: Text(
              'Publicar',
              style: TextStyle(color: AppColors.onHighlightText),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.onBackgroundDefault,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.nonSelectedItem,
                  child: Icon(Icons.person_2, color: AppColors.primary),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '$nombre $apellido',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primaryVariant,
                        ),
                      ),
                      Text(
                        "Usa internet con respeto: sigue las netiquetas",
                        style: TextStyle(color: AppColors.onSecondaryText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: comentario ? "Comenta..." : '¿Que esta pasando?',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
