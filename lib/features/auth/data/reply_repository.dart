import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_connect/core/models/reply_model.dart';
import 'package:uni_connect/core/utils/sequential_id_service.dart';


class ReplyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SequentialIdService _ids = SequentialIdService();

  Stream <List<ReplyModel>> watchRepliesForPost(String postId){
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('replies')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
          .map((doc) => ReplyModel.fromFirestore(doc.data(), doc.id)).toList());
  }

  //Add a reply under a specific post & increment the posts's comment count
  Future<void> addReply({
    required String postId,
    required ReplyModel reply,
  }) async {
    final postRef = _firestore.collection('posts').doc(postId);
    final replyId = await _ids.nextId('replies', 'reply_');
    final replyRef = postRef.collection('replies').doc(replyId);
    final batch = _firestore.batch();

    //Add reply document to sub-collection
    //role of the author so admin replies can show an admin badge
    String role = 'student';
    try{
      final u = await _firestore.collection('users').doc(reply.userId).get();
      role = (u.data()?['role'] ?? 'student').toString();
    }catch(_){
      batch.set(replyRef, {...reply.toJson(), 'replyId': replyId, 'authorRole': role});
      batch.update(postRef,{
        'comments': FieldValue.increment(1),
      });
      await batch.commit();
    }

  }

  //Delete a reply & decrement the post's comment count
  Future<void> deleteReply({
    required String postId,
    required String replyId,
  }) async {
    final postRef = _firestore.collection('posts').doc(postId);
    final replyRef = postRef.collection('replies').doc(replyId);
    final batch = _firestore.batch();
    //Delete reply document
    batch.delete(replyRef);
    //Decrement comment count on the post parent document -1
    batch.update(postRef, {
      'comments': FieldValue.increment(-1),
    });
    await batch.commit();
  }
}