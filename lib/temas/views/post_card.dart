import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(post.date);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.requestType, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text("📘 Clase: ${post.courseName}"),
            Text("🎓 Carrera: ${post.career}"),
            Text("🕒 Horario sugerido: ${post.schedule}"),
            Text("🏫 Lugar solicitado: ${post.location}"),
            Divider(),
            Text("👤 Autor: ${post.author} (${post.role})"),
            Text("💬 Comentario: ${post.comment}"),
            Text("📅 Fecha: $formattedDate", style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
