import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uth_request_flutter_application/temas/controllers/temas_controller.dart';
import 'package:uth_request_flutter_application/temas/models/post_model.dart';

class CrearTemaPage extends StatelessWidget {
  CrearTemaPage({
    super.key,
    required this.comentario,
  });

  final bool comentario;
  final TextEditingController mensajeController = TextEditingController();
  final PostController postController = Get.find();

  Future<void> publicarTema() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'Debes iniciar sesion para publicar');
      return;
    }

    final post = PostModel(
      id: '',
      uid: user.uid,
      mensaje: mensajeController.text,
      carrera: '',
      nombre: '',
      verificado: false,
      likes: [],
      comentarios: 0,
      principal: true,
      comentario: false,
      fechaCreacion: DateTime.now().toIso8601String(),
      tiempo: 'Ahora',
    );

    await postController.addPost(post);
    Get.back();
  }

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
            onPressed: publicarTema,
            child: Text('Publicar', style: TextStyle(color: AppColors.onHighlightText)),
          ),
        ],
      ),
      backgroundColor: AppColors.onBackgroundDefault,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: mensajeController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: comentario ? "Comenta..." : '¿Qué está pasando?',
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
