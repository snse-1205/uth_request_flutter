class PostModel {
  final String id;
  final String content;
  final List<String> likes;

  PostModel({
    required this.id,
    required this.content,
    required this.likes,
  });

  factory PostModel.fromMap(String id, Map<String, dynamic> data) {
    return PostModel(
      id: id,
      content: data['content'] ?? '',
      likes: List<String>.from(data['likes'] ?? []),
    );
  }
}
