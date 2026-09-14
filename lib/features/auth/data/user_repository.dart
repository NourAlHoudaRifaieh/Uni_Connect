import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_connect/core/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream current logged-in user profile real-time
  Stream<UserModel?> watchCurrentUser() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(null);

    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists && doc.data() != null
        ? UserModel.fromFirestore(doc.data()!, doc.id)
        : null);
  }

  // Fetch single user profile once by UID
  Future<UserModel?> getUserById(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromFirestore(doc.data()!, doc.id);
    }
    return null;
  }

  // Stream all users (for Admin User Management Dashboard)
  Stream<List<UserModel>> watchAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => UserModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Update user profile details
  Future<void> updateUserProfile(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.userId)
        .update(user.toJson());
  }

  // Increment user's total post count dynamically when they publish a post
  Future<void> incrementUserPostCount(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'postCount': FieldValue.increment(1),
    });
  }

  // Delete user document from Firestore (Admin action)
  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }
}