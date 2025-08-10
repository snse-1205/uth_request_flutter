import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CommentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> addComment(String postId, String userId, String text) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'userId': userId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteComment(String postId, String commentId) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }
}
