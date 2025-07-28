class PostModel {
  final String author;
  final String role; // estudiante o catedrático
  final String requestType; // Ej: "Petición de clase"
  final String courseName;
  final String career;
  final String schedule;
  final String location;
  final String comment;
  final DateTime date;

  PostModel({
    required this.author,
    required this.role,
    required this.requestType,
    required this.courseName,
    required this.career,
    required this.schedule,
    required this.location,
    required this.comment,
    required this.date,
  });
}
