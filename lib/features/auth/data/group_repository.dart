import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_connect/core/models/group_model.dart';

class GroupRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> _generateGroupId() async{
    final querySnapshot = await _firestore.collection('groups').get();
    int maxId = 0;
    for(var doc in querySnapshot.docs){
      final id= doc.id;
      if(id.startsWith('group_')){
        final numberPart = int.tryParse(id.replaceFirst('group_', '')) ?? 0;
        if(numberPart > maxId){
          maxId = numberPart;
        }
      }
    }
    return 'group_${maxId + 1}';
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

  //Delete a group
  Future <void> deleteGroup(String groupId) async{
    await _firestore.collection('groups').doc(groupId).delete();
  }

}