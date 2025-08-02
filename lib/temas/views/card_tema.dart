import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/temas/views/crearTema.dart';

class CardTema extends StatefulWidget {
  const CardTema({
    super.key,
    required this.nombre,
    required this.mensaje,
    required this.tiempo,
    required this.likes,
    required this.comentarios,
    required this.principal,
    required this.comentario,
    required this.fechaCreacion,
    required this.verificado,
    required this.carrera,
  });

  final String nombre;
  final String mensaje;
  final String tiempo;
  final int likes;
  final int comentarios;
  final bool principal;
  final bool comentario;
  final bool verificado;
  final String fechaCreacion;
  final String carrera;

  @override
  State<CardTema> createState() => _CardTemaState();
}

class _CardTemaState extends State<CardTema> {
  late int likeCount;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    likeCount = widget.likes;
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

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
                              widget.nombre,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          if (widget.verificado)
                            Icon(
                              Icons.verified,
                              color: AppColors.onHighlightText,
                              size: 18,
                            ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        widget.carrera,
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
                  widget.tiempo,
                  style: TextStyle(
                    color: AppColors.onSecondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            // Mensaje
            Text(widget.mensaje, style: TextStyle(fontSize: 15)),

            SizedBox(height: 10),

            // Fecha de creacion
            widget.principal
                ? Text(
                    widget.fechaCreacion,
                    style: TextStyle(
                      color: AppColors.onSecondaryText,
                      fontSize: 12,
                    ),
                  )
                : SizedBox(height: 2),

            SizedBox(height: 8),

            // Reacciones
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: toggleLike,
                  child: Icon(
                    isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                    size: 22,
                    color: isLiked
                        ? AppColors.onHighlightText
                        : AppColors.onSecondaryText,
                  ),
                ),
                SizedBox(width: 4),
                Text('$likeCount'),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => CrearTemaPage(
                        nombre: 'nombre',
                        apellido: 'apellido',
                        comentario: true,
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
                Text('${widget.comentarios}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
