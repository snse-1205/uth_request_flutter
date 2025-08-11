import 'package:flutter/material.dart';
import '../models/post_model.dart';
import 'widgets/post_card.dart';

class CommunityView extends StatelessWidget {
  final List<PostModel> posts = [
    PostModel(
      author: "Carlos Méndez",
      role: "Estudiante",
      requestType: "Petición de clase",
      courseName: "Estructura de datos",
      career: "Ingeniería en Sistemas",
      schedule: "Lunes y miércoles 2:00 PM - 4:00 PM",
      location: "Laboratorio 3",
      comment: "Muchos estudiantes queremos esta clase en este horario.",
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    PostModel(
      author: "Dra. López",
      role: "Catedrático",
      requestType: "Disponibilidad para impartir clase",
      courseName: "Programación móvil",
      career: "Multimedia",
      schedule: "Martes y jueves 8:00 AM - 10:00 AM",
      location: "Aula 4",
      comment: "Estoy disponible para impartir esta clase este periodo.",
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comunidad Académica")),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (_, index) => PostCard(post: posts[index]),
      ),
    );
  }
}
