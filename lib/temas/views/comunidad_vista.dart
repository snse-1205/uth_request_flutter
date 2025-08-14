import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/temas/controllers/temas_controller.dart';
import 'package:uth_request_flutter_application/temas/views/card_tema.dart';
import 'package:uth_request_flutter_application/temas/views/crearTema.dart';

class ListaTemasPage extends StatelessWidget {
  const ListaTemasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.put(PostController());

    return Scaffold(
      backgroundColor: AppColors.onBackgroundDefault,
      body: Column(
        children: [
          // Barra para escribir
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: InkWell(
              onTap: () {
                Get.to(
                  () => CrearTemaPage(comentario: false),
                  transition: Transition.downToUp,
                );
              },
              borderRadius: BorderRadius.circular(25.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.selectedNavbar),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      size: 18,
                      color: AppColors.onBorderTextField,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '¿Quieres crear un tema?',
                      style: TextStyle(
                        color: AppColors.onBorderTextField,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Divider(color: AppColors.onLineDivider),

          // Lista de temas en tiempo real
          Expanded(
            child: Obx(() {
              if (postController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (postController.posts.isEmpty) {
                return Center(child: Text('No hay temas aún'));
              }

              return ListView.builder(
                itemCount: postController.posts.length,
                itemBuilder: (context, index) {
                  final post = postController.posts[index];

                  return StreamBuilder<int>(
                    stream: postController.getLikesCount(
                      post.id,
                    ),
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;

                      return CardTema(
                        postId: post.id,
                        nombre: post.nombre,
                        mensaje: post.mensaje,
                        tiempo: post.tiempo,
                        comentarios: post.comentarios,
                        principal: post.principal,
                        comentario: post.comentario,
                        fechaCreacion: post.fechaCreacion,
                        verificado: post.verificado,
                        carrera: post.carrera,
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}