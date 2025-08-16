import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/temas/controllers/comentarios_controller.dart';
import 'package:uth_request_flutter_application/temas/models/comment_model.dart';
import 'package:uth_request_flutter_application/temas/views/card_comentario.dart';
import 'package:uth_request_flutter_application/temas/views/card_tema.dart';

class PostDetailPage extends StatelessWidget {
  final String postId;
  final String nombre;
  final String mensaje;
  final String tiempo;
  final int likes;
  final int comentarios;
  final bool principal;
  final bool comentario;
  final bool verificado;
  final String fechaCreacion;

  PostDetailPage({
    super.key,
    required this.postId,
    required this.nombre,
    required this.mensaje,
    required this.tiempo,
    required this.likes,
    required this.comentarios,
    required this.principal,
    required this.comentario,
    required this.verificado,
    required this.fechaCreacion,
  });

  final CommentController commentController = Get.find();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Cargar comentarios al iniciar
    commentController.fetchComments(postId);

    return Scaffold(
      backgroundColor: AppColors.onBackgroundDefault,
      appBar: AppBar(
        title: Text("TEMA DE $nombre".toUpperCase()),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onSurface,
      ),
      body: Column(
        children: [
          // Post principal
          CardTema(
            postId: postId,
            nombre: nombre,
            mensaje: mensaje,
            tiempo: tiempo,
            comentarios: comentarios,
            principal: principal,
            comentario: comentario,
            fechaCreacion: fechaCreacion,
            verificado: verificado,
          ),
          Divider(color: AppColors.onLineDivider),

          // Lista de comentarios
          Expanded(
            child: Obx(() {
              if (commentController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              // Mostrar mensaje si no hay comentarios
              if (commentController.comments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.comment,
                        size: 40,
                        color: AppColors.onSecondaryText,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "No hay comentarios aún",
                        style: TextStyle(
                          color: AppColors.onSecondaryText,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                itemCount: commentController.comments.length,
                separatorBuilder: (_, __) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final comment = commentController.comments[index];
                  return CommentCard(comment: comment);
                },
              );
            }),
          ),

          // Campo para agregar comentario
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Comentar...",
                      filled: true,
                      fillColor: AppColors.onSurface,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: AppColors.primary),
                  onPressed: () async {
                    if (_commentController.text.trim().isEmpty) return;

                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      Get.snackbar("Error", "No hay usuario logueado");
                      return;
                    }

                    final uid = user.uid;

                    // Obtener nombre desde la colección 'estudiantes'
                    final userDoc = await FirebaseFirestore.instance
                        .collection('estudiantes')
                        .doc(uid)
                        .get();

                    final nombre = userDoc.data()?['nombre'] ?? 'Usuario';

                    final newComment = CommentModel(
                      id: '',
                      uid: uid,
                      postId: postId,
                      nombre: nombre,
                      verificado: false,
                      mensaje: _commentController.text.trim(),
                      fechaCreacion: DateTime.now().toString(),
                    );

                    await commentController.addComment(newComment);

                    _commentController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}