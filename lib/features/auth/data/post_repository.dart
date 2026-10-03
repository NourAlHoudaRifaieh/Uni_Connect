import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_connect/core/utils/sequential_id_service.dart';
import 'package:uni_connect/features/auth/data/subject_repository.dart';
import 'package:uni_connect/features/auth/data/user_repository.dart';

import '../../../core/models/post_model.dart';

class PostRepository {
  final _firestore = FirebaseFirestore.instance;
  final _subjectRepository = SubjectRepository();
  final _userRepository = UserRepository();
  final SequentialIdService _ids = SequentialIdService();

  Future<String> _generatePostId() {
    return _ids.nextId('posts', 'post_');
  }

  //all posts, news first - used by Home feed
  Stream<List<PostModel>> watchAllPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs
            .map((doc) => PostModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Stream<PostModel?> watchPostById(String postId) {
    return _firestore.collection('posts').doc(postId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return PostModel.fromFirestore(doc.data()!, doc.id);
    });
  }

  //posts for one specific subject - used by subject Details
  Stream<List<PostModel>> watchPostsForSubject(String subjectId) {
    return _firestore
        .collection('posts')
        .where('subjectId', isEqualTo: subjectId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs
            .map((doc) => PostModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Stream<List<PostModel>> watchPostsByGroup(String groupId) {
    return _firestore
        .collection('posts')
        .where('groupId', isEqualTo: groupId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs
            .map((doc) => PostModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Stream<List<PostModel>> watchPostsForStudentGroup(String groupId) {
    return _firestore
        .collection('posts')
        .where('groupId', isEqualTo: groupId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs
            .map((doc) => PostModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Create a new Post, and bump the subject's post count at the same time
  Future<void> createPost(PostModel post) async {
    final newPostId = await _generatePostId();

    String correctUserId = post.userId ?? '';
    String authorRole = 'student';
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.email != null) {
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: currentUser.email)
          .limit(1)
          .get();
      if (userQuery.docs.isNotEmpty) {
        correctUserId = userQuery.docs.first.id;
        authorRole =
            (userQuery.docs.first.data()['role'] ?? 'student').toString();
      }
    }
    final correctedPost = post.copyWith(
        userId: correctUserId, postId: newPostId, authorRole: authorRole);

    await _firestore.collection('posts').doc(newPostId).set(
        correctedPost.toJson());

    // await _firestore.collection('posts').add(correctedPost.toJson());
    if (correctedPost.subjectId != null &&
        correctedPost.subjectId!.isNotEmpty) {
      await _subjectRepository.incrementPostCount(correctedPost.subjectId!);
    }
    if (correctUserId.isNotEmpty) {
      await _userRepository.incrementUserPostCount(correctUserId);
    }
    // keep the group's postCount in sync (shown in the Admin Panel)
    if (correctedPost.groupId != null && correctedPost.groupId!.isNotEmpty) {
      await _firestore.collection('groups').doc(correctedPost.groupId).set(
          {'postCount': FieldValue.increment(1)}, SetOptions(merge: true));
    }

}

  //toggle like/unlike for a specific user, safely even with concurrent taps
  Future<void> toggleLike(String postId, String userId, String userName) async{
    // likes are stored with the user NUMBER (users/{id}, e.g. user_3),
    // never with the Firebase Auth uid.
    final me = await _userRepository.getCurrentUserModel();
    final likerId = me?.userId ?? userId;
    final likerName = (me != null && me.fullName.trim().isNotEmpty) ? me.fullName.trim() : userName;
    final authUid = FirebaseAuth.instance.currentUser?.uid;

    final postRef = _firestore.collection('posts').doc(postId);
    final postDoc = await postRef.get();
    if(!postDoc.exists) return;
    List<dynamic> likedBy = List<dynamic>.from(postDoc.data()?['likedBy'] ?? []);
    // old likes may have been saved with the auth uid: treat them as the same person
    bool isMe(dynamic item) => item is Map &&
        (item['userId'] == likerId || (authUid != null && item['userId'] == authUid));
    if (likedBy.any(isMe)){
      likedBy.removeWhere(isMe);
    }else{
      likedBy.add({'userId': likerId, 'userName': likerName});
    }
    await postRef.update({
      'likedBy': likedBy,
      'likes': likedBy.length,
    });
  }

  Future<void> updatePost(String postId, {
    required String description,
    String? categoryId,
    String? categoryName,
  }) async {
    await _firestore.collection('posts').doc(postId).update({
      'description': description.trim(),
      if (categoryId != null) 'categoryId': categoryId,
      if (categoryName != null) 'categoryName': categoryName,
      'isEdited': true,
      'editedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<PostModel>> getRecentPosts({int limit = 20}) async {
    final snap = await _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs
        .map((d) => PostModel.fromFirestore(d.data(), d.id))
        .toList();
  }

  Future<void> deletePost(String postId,
      {String? subjectId, String? userId, String? groupId}) async {
    await _firestore.collection('posts').doc(postId).delete();
    if (groupId != null && groupId.isNotEmpty) {
      await _firestore.collection('groups').doc(groupId).set(
        {'postCount': FieldValue.increment(-1)},
        SetOptions(merge: true),
      );
    }
    if (subjectId != null && subjectId.isNotEmpty) {
      await _subjectRepository.decrementPostCount(subjectId);
    }
    if (userId != null && userId.isNotEmpty) {
      await _userRepository.decrementUserPostCount(userId);
    }
  }
}