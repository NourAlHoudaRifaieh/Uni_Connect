import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_connect/core/models/notification_model.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<NotificationModel>> watchForUser(String userDocId){
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userDocId)
        .snapshots()
        .map((s) {
          final list = s.docs
              .map((d) => NotificationModel.fromFirestore(d.data(), d.id))
              .toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
    });
  }

  Future<void> send({
    required String toUserDocId,
    required String content,
    String senderName = '',
    String type = 'general',
  }) async {
    if(toUserDocId.isEmpty) return;
    await _firestore.collection('notifications').add({
      'userId': toUserDocId,
      'content': content,
      'senderName': senderName,
      'type': type,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markAsRead(String notificationId) async{
    await _firestore
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  Future<void> markAllAsRead(String userDocId) async{
    final snap = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: (userDocId))
        .where('isRead', isEqualTo: false)
        .get();
    final batch = _firestore.batch();
    for(final d in snap.docs){
      batch.update(d.reference, {'isRead': true});
    }
    await batch.commit();

  }

}