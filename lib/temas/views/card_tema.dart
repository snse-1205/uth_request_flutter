import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/temas/controllers/temas_controller.dart';
import 'package:uth_request_flutter_application/temas/views/comentarios_view.dart';

class CardTema extends StatelessWidget {
  final String postId;
  final String nombre;
  final String mensaje;
  final String tiempo;
  final int comentarios;
  final bool principal;
  final bool comentario;
  final bool verificado;
  final String fechaCreacion;
  final String carrera;

  CardTema({
    super.key,
    required this.postId,
    required this.nombre,
    required this.mensaje,
    required this.tiempo,
    required this.comentarios,
    required this.principal,
    required this.comentario,
    required this.verificado,
    required this.fechaCreacion,
    required this.carrera,
  });

  final PostController postController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: AppColors.onSurface,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Cabecera con nombre y fecha ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.person_2, color: AppColors.primary),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              nombre,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          if (verificado)
                            Icon(
                              Icons.verified,
                              color: AppColors.onHighlightText,
                              size: 18,
                            ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        carrera,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  tiempo,
                  style: TextStyle(
                    color: AppColors.onSecondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            // --- Mensaje ---
            Text(mensaje, style: TextStyle(fontSize: 15)),

            SizedBox(height: 10),

            // --- Fecha ---
            if (principal)
              Text(
                fechaCreacion,
                style: TextStyle(
                  color: AppColors.onSecondaryText,
                  fontSize: 12,
                ),
              ),

            SizedBox(height: 8),

            // --- Reacciones ---
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Contador de likes
                StreamBuilder<int>(
                  stream: postController.getLikesCount(postId),
                  builder: (context, snapshot) {
                    final count = snapshot.data ?? 0;
                    return Text('$count');
                  },
                ),
                SizedBox(width: 8),

                // Boton de like
                StreamBuilder<bool>(
                  stream: postController.hasLiked(postId),
                  builder: (context, snapshot) {
                    final hasLiked = snapshot.data ?? false;
                    return IconButton(
                      icon: Icon(
                        hasLiked ? Icons.thumb_up : Icons.thumb_up,
                        color: hasLiked
                            ? AppColors.onHighlightText
                            : AppColors.onSecondaryText,
                      ),
                      onPressed: () => postController.toggleLike(postId),
                    );
                  },
                ),

                SizedBox(width: 16),

                // Boton de comentarios
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => PostDetailPage(
                        postId: postId,
                        nombre: nombre,
                        mensaje: mensaje,
                        tiempo: tiempo,
                        likes: 0,
                        comentarios: comentarios,
                        principal: principal,
                        comentario: comentario,
                        verificado: verificado,
                        fechaCreacion: fechaCreacion,
                        carrera: carrera,
                      ),
                      transition: Transition.downToUp,
                    );
                  },
                  child: Icon(
                    Icons.comment_outlined,
                    size: 22,
                    color: AppColors.onSecondaryText,
                  ),
                ),
                SizedBox(width: 4),
                Text('$comentarios'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
