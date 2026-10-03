import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_connect/core/models/group_model.dart';
import 'package:uni_connect/core/utils/sequential_id_service.dart';

class GroupRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SequentialIdService _ids = SequentialIdService();

  Future<String> _generateGroupId() => _ids.nextId('groups', 'group_');

  Future<GroupModel?> getGroupById(String groupId) async{
    final doc = await _firestore.collection('groups').doc(groupId).get();
    if(doc.exists && doc.data() != null){
      return GroupModel.fromFirestore(doc.data()!, doc.id);
    }
    return null;
  }

  //Stream all groups across academic years
  Stream <List<GroupModel>> watchAllGroups(){
    return _firestore
        .collection('groups')
        .snapshots()
        .map((snapshot) => snapshot.docs
          .map((doc) => GroupModel.fromFirestore(doc.data(), doc.id))
          .toList());
  }

  //Stream groups filtered by student's academic year
  Stream <List<GroupModel>> watchGroupByYear(String academicYear){
    return _firestore
        .collection('groups')
        .where('academicYear', isEqualTo: academicYear)
        .snapshots()
        .map((snapshot) => snapshot.docs
          .map((doc) => GroupModel.fromFirestore(doc.data(), doc.id))
          .toList());
  }

  // true when a group with the same year + department (+ major) already exists
  Future<bool> groupExists({
    required String academicYear,
    required String department,
    String? major,
  }) async {
    Query<Map<String, dynamic>> q = _firestore
        .collection('groups')
        .where('academicYear', isEqualTo: academicYear)
        .where('department', isEqualTo: department);
    if (major != null) q = q.where('major', isEqualTo: major);
    final snap = await q.get();
    // when no major is given only an existing group WITHOUT major counts
    return snap.docs.any((d) => major != null || (d.data()['major'] == null));
  }

  //Create a new group
  Future<void> createGroup(GroupModel group) async{
    final String groupId = group.groupId ?? await _generateGroupId();
    final groupWithId = group.copyWith(groupId: groupId);
    await _firestore.collection('groups').doc(groupId).set(groupWithId.toJson());
  }

  //Update an existing group
  Future<void> updateGroup(GroupModel group) async{
    if(group.groupId == null ) return;
    await _firestore
      .collection('groups')
      .doc(group.groupId)
      .update(group.toJson());
  }

  Future<String?> groupDeletionBlocker(GroupModel group) async {
    final id = group.groupId;
    if (id == null || id.isEmpty) return 'This group cannot be deleted.';

    final subjects = await _firestore
        .collection('subjects')
        .where('groupId', isEqualTo: id)
        .limit(1)
        .get();
    if (subjects.docs.isNotEmpty) {
      return 'Cannot delete "${group.groupName}": it still has subjects.';
    }

    final students = await _firestore
        .collection('users')
        .where('groupId', isEqualTo: id)
        .limit(1)
        .get();
    if (students.docs.isNotEmpty) {
      return 'Cannot delete "${group.groupName}": it still has students.';
    }
    final posts = await _firestore
        .collection('posts')
        .where('groupId', isEqualTo: id)
        .limit(1)
        .get();
    if (posts.docs.isNotEmpty) {
      return 'Cannot delete "${group.groupName}": it still has posts.';
    }
    return null;
  }

  //Delete a group
  Future <void> deleteGroup(String groupId) async{
    await _firestore.collection('groups').doc(groupId).delete();
  }

}