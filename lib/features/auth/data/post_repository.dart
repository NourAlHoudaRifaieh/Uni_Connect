import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_connect/features/auth/data/subject_repository.dart';

import '../../../core/models/post_model.dart';

class PostRepository {
  final _firestore = FirebaseFirestore.instance;
  final _subjectRepository = SubjectRepository();

  //all posts, news first - used by Home feed
  Stream<List<PostModel>> watchAllPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
          .map((doc) => PostModel.fromFirestore(doc.data(), doc.id)).toList());
  }

  //posts for one specific subject - used by subject Details
  Stream<List<PostModel>> watchPostsForSubject(String subjectId){
    return _firestore
        .collection('posts')
        .where('subjectId', isEqualTo: subjectId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromFirestore(doc.data(), doc.id)).toList());
  }

  // Create a new Post, and bump the subject's post count at the same time
  Future<void> createPost(PostModel post) async{
    await _firestore.collection('posts').add(post.toJson());
    if(post.subjectId != null){
      await _subjectRepository.incrementPostCount(post.subjectId!);
    }
  }

  //toggle like/unlike for a specific user, safely even with concurrent taps
  Future<void> toggleLike(String postId, String userId) async{
    final postRef = _firestore.collection('posts').doc(postId);
    final postDoc = await postRef.get();
    if(!postDoc.exists) return;
    final likedBy = List<String>.from(postDoc.data()?['likedBy'] ?? []);
    if(likedBy.contains(userId)){
      await postRef.update({
        'likedBy': FieldValue.arrayRemove([userId]),
      });
    } else{
      await postRef.update({
        'likedBy': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Future<void> deletePost(String postId, {String? subjectId}) async{
    await _firestore.collection('posts').doc(postId).delete();
    if(subjectId != null && subjectId.isNotEmpty){
      await _subjectRepository.decrementPostCount(subjectId);
    }
  }

}