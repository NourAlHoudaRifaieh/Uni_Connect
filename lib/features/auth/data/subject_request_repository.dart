import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_connect/features/auth/data/group_repository.dart';
import 'package:uni_connect/features/auth/data/notification_repository.dart';
import '../../../core/models/subject_model.dart';
import '../../../core/models/user_model.dart';

/// Year helpers shared by the request flow and the validations.
int? yearNumber(String? year) {
  if (year == null) return null;
  return int.tryParse(year.replaceAll(RegExp(r'[^0-9]'), ''));
}

/// Years 4 and 5 may NEVER hold subjects from another year.
bool isLockedYear(String? year) {
  final n = yearNumber(year);
  return n == 4 || n == 5;
}

class SubjectRequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationRepository _notifications = NotificationRepository();

  /// Returns an error message, or null when the request is allowed.
  String? validateRequest(UserModel user, SubjectModel subject) {
    if (isLockedYear(user.academicYear)) {
      return 'Year 4 and Year 5 students cannot take subjects from another year.';
    }
    if (isLockedYear(subject.academicYear)) {
      return 'Subjects of Year 4 and Year 5 cannot be requested.';
    }
    if (subject.academicYear == user.academicYear) {
      return 'This subject is already part of your own year.';
    }
    if (user.extraSubjectIds.contains(subject.subjectId)) {
      return 'You already have this subject.';
    }
    return null;
  }
  
  Future<String?> createRequest({
    required UserModel user,
    required SubjectModel subject,
  }) async{
    final error = validateRequest(user, subject);
    if(error != null) return error;
    
    final existing = await _firestore
        .collection('subjectRequests')
        .where('userId', isEqualTo: user.userId)
        .where('subjectId', isEqualTo: subject.subjectId)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();
    
    if(existing.docs.isNotEmpty){
      return 'You already sent a pending request for this subject.';
    }
    
    final subjectGroup = subject.groupId.isNotEmpty
      ? await GroupRepository().getGroupById(subject.groupId)
      : null;
    
    final userGroup = (user.groupId != null && user.groupId!.isNotEmpty)
      ? await GroupRepository().getGroupById(user.groupId!)
      : null;
    
    await _firestore.collection('subjectRequests').add({
      'userGroupName': userGroup?.displayName ?? (user.major ?? ''),
      'subjectGroupId': subject.groupId,
      'subjectGroupName': subjectGroup?.displayName ?? '',
      'userId': user.userId,
      'userName': user.fullName,
      'userYear':user.academicYear,
      'userGroupId': user.groupId,
      'subjectId': subject.subjectId,
      'subjectName': subject.subjectName,
      'subjectYear': subject.academicYear,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    //tell every admin there is a new request
    try{
      final admins= await _firestore.collection('users').where('role', isEqualTo: 'admin').get();
      for(final a in admins.docs){
        await _notifications.send(
          toUserDocId:a.id,
          content: '${user.fullName} (${user.academicYear}) asked to see "${subject.subjectName}" (${subject.academicYear}).',
          senderName: user.fullName,
          type: 'subject_request',
        );
      }
    }catch(_){
      return null;
    }
  }

  Stream<List<Map<String, dynamic>>> watchPending() {
    return _firestore
        .collection('subjectRequests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((s) => s.docs.map((d) => {...d.data(), 'id': d.id}).toList());
  }

  Stream<List<Map<String, dynamic>>> watchForUser(String userId) {
    return _firestore
        .collection('subjectRequests')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((s) => s.docs.map((d) => {...d.data(), 'id': d.id}).toList());
  }

  //Admin accepts: the subject and its posts now appear for that student
  Future<String?> accept (Map<String, dynamic> request) async{
    final userRef = _firestore.collection('users').doc(request['userId']);
    final userDoc = await userRef.get();
    if(!userDoc.exists) return 'User no longer exists.';
    final user = UserModel.fromFirestore(userDoc.data()!, userDoc.id);

    //for year 4 and year 5 never get a subject from another year
    if(isLockedYear(user.academicYear) || isLockedYear(request['subjectYear'] as String?)){
      await _firestore.collection('subjectRequests').doc(request['id']).update({'status': 'rejected'});
      return 'Rejected automatically: Year 4/5 restriction.';
    }
    await userRef.update({
      'extraSubjectIds': FieldValue.arrayUnion([request['subjectId']]),
    });
    await _firestore
        .collection('subjectRequests')
        .doc(request['id'])
        .update({
      'status': 'accepted',
      'decidedAt': FieldValue.serverTimestamp()
    });
    await _notifications.send(
      toUserDocId: request['userId'],
      content: 'Your request for "${request['subjectName']}" was accepted.',
      senderName: 'Admin',
      type: 'request_accepted',
    );
    return null;
  }

  Future <void> reject (Map<String, dynamic> request) async{
    await _firestore
        .collection('subjectRequests')
        .doc(request['id'])
        .update({
      'status': 'rejected',
      'decidedAt': FieldValue.serverTimestamp(),
    });
    await _notifications.send(
      toUserDocId: request['userId'],
      content: 'Your request for "${request['subjectName']}" was rejected.',
      senderName: 'Admin',
      type: 'request_rejected',
    );
  }

}