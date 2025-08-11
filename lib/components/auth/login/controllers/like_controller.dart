import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class LikeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> toggleLike(String postId, String userId) async {
    final postRef = _firestore.collection('posts').doc(postId);
    final postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      List<dynamic> likes = postSnapshot.data()?['likes'] ?? [];

      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
      }

      await postRef.update({'likes': likes});
    }
  }

  Future<bool> isLiked(String postId, String userId) async {
    final postSnapshot =
        await _firestore.collection('posts').doc(postId).get();
    final likes = postSnapshot.data()?['likes'] ?? [];
    return likes.contains(userId);
  }
}
