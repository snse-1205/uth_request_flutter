import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/temas/models/comment_model.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: AppColors.onSurface,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera con avatar, nombre y carrera
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(
                    Icons.person_2,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            comment.nombre,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 4),
                          if (comment.verificado)
                            Icon(
                              Icons.verified,
                              color: AppColors.onHighlightText,
                              size: 16,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                 _fmtDate(comment.fechaCreacion),
                  style: TextStyle(
                    color: AppColors.onSecondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            // Mensaje
            Text(comment.mensaje, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  String _fmtDate(String a) {
    DateTime d = DateTime.tryParse(a) ?? DateTime.now();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return '$dd/$mm/$yy';
  }
}