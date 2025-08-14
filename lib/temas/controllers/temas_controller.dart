import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var posts = <PostModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _db
        .collection('posts')
        .orderBy('fechaCreacion', descending: true)
        .snapshots()
        .listen((snapshot) async {
          isLoading.value = true;
          List<PostModel> loadedPosts = [];

          for (var doc in snapshot.docs) {
            final postData = doc.data();
            final uid = postData['uid'];
            final userDoc = await _db.collection('estudiantes').doc(uid).get();
            final userData = userDoc.data() ?? {};
            loadedPosts.add(PostModel.fromMap(doc.id, postData, userData));
          }

          posts.value = loadedPosts;
          isLoading.value = false;
        });
  }

  Future<void> fetchPosts() async {
    isLoading.value = true;
    try {
      final snapshot = await _db
          .collection('posts')
          .orderBy('fechaCreacion', descending: true)
          .get();

      List<PostModel> loadedPosts = [];

      for (var doc in snapshot.docs) {
        final postData = doc.data();
        final uid = postData['uid'];

        final userDoc = await _db.collection('estudiantes').doc(uid).get();
        final userData = userDoc.data() ?? {};

        loadedPosts.add(PostModel.fromMap(doc.id, postData, userData));
      }

      posts.value = loadedPosts;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPost(PostModel post) async {
    await _db.collection('posts').add(post.toMap());
    fetchPosts();
  }

  // Metodo para dar like o quitarlo
  Future<void> toggleLike(String postId) async {
    final String currentUid = _auth.currentUser!.uid;
    final postRef = _db.collection('posts').doc(postId);

    final snapshot = await postRef.get();
    if (!snapshot.exists) return;

    final List<dynamic> currentLikes = snapshot.data()!['likes'] ?? [];

    if (currentLikes.contains(currentUid)) {
      // Si ya dio like, quitarlo
      await postRef.update({
        'likes': FieldValue.arrayRemove([currentUid]),
      });
    } else {
      // Si no ha dado like, agregarlo
      await postRef.update({
        'likes': FieldValue.arrayUnion([currentUid]),
      });
    }
  }

  // Stream para escuchar likes en tiempo real
  Stream<int> getLikesCount(String postId) {
    return _db
        .collection('posts')
        .doc(postId)
        .snapshots()
        .map((doc) => List<String>.from(doc.data()?['likes'] ?? []).length);
  }

  // Saber si el usuario actual ha dado like
  Stream<bool> hasLiked(String postId) {
    final String currentUid = _auth.currentUser!.uid;
    return _db
        .collection('posts')
        .doc(postId)
        .snapshots()
        .map((doc) {
      final likes = List<String>.from(doc.data()?['likes'] ?? []);
      return likes.contains(currentUid);
    });
  }

}
