import "package:flutter/material.dart";

class GroupModel{
  final String? groupId;
  final String groupName;
  final String? userId;// foreign key
  final String? subjectId; //foreign key
  // final String academicYear; --> need to use it from the user model
  final int membersCount;
  // final int postCount; --> need to use it from post moel


  GroupModel({
    this.groupId,
    required this.groupName,
    this.userId,
    this.subjectId,
    required this.membersCount,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json){
    return GroupModel(
        groupName: json['groupName'] ?? '',
        groupId: json['groupId'] ?? '',
        userId: json['userId'] ?? '',
        subjectId: json['subjectId'] ?? '',
        membersCount: json['membersCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      if(groupId != null) 'groupId': groupId,
      'groupName': groupName,
      if(userId != null) 'userId': userId,
      // 'userId': userId,
      'subjectId': subjectId,
      'membersCount': membersCount,
    };
  }

  factory GroupModel.fromFirestore(Map<String, dynamic> data, String id){
    return GroupModel(
        groupId: id,
        groupName: data['groupName'] ?? '',
        subjectId: data['subjectId'] ?? '',
        membersCount: data['membersCount'] ?? 0,
        userId: data['data'] as String?,
    );
  }
}