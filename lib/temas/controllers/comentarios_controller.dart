import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uth_request_flutter_application/temas/models/comment_model.dart';

class CommentController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var comments = <CommentModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchComments(String postId) async {
    isLoading.value = true;
    try {
      final snapshot = await _db
          .collection('comments')
          .where('postId', isEqualTo: postId)
          .orderBy('fechaCreacion', descending: true)
          .get();

      List<CommentModel> loadedComments = [];

      for (var doc in snapshot.docs) {
        final commentData = doc.data();
        final uid = commentData['uid'];

        // Obtener datos del usuario
        final userDoc = await _db.collection('estudiantes').doc(uid).get();
        final userData = userDoc.data() ?? {};

        loadedComments.add(CommentModel.fromMap(doc.id, commentData, userData));
      }

      comments.value = loadedComments;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addComment(CommentModel comment) async {
    await _db.collection('comments').add(comment.toMap());
    fetchComments(comment.postId);
  }
}