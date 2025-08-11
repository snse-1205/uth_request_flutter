import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class VerificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isUserVerified(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc.data()?['verified'] ?? false;
  }
}
