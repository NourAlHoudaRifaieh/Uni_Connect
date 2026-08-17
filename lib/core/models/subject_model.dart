import 'package:flutter/material.dart';

class SubjectModel{
  final String? subjectId;
  final String subjectCode;
  final String subjectName;
  final String? academicYear;
  final int postCount;
  final Color color;
  final IconData icon;

  SubjectModel({
    this.subjectId,
    required this.subjectCode,
    required this.subjectName,
    this.academicYear,
    required this.postCount,
    this.color = Colors.blue,
    this.icon = Icons.menu_book,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json){
    return SubjectModel(
        subjectId: json['subjectId'] ?? '',
        subjectCode: json['subjectCode'] ?? '',
        subjectName: json['subjectName'] ?? '',
        academicYear: json['academicYear'] ?? '',
        postCount: json['postCount'] ?? 0,
        color: json['colorHex'] != null ? Color(int.parse(json['colorHex'])) : Colors.blue,
        icon: json['iconCode'] != null ? IconData(json['iconCode'], fontFamily: 'MaterialIcons') : Icons.menu_book,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'subjectId': subjectId,
      'subjectCode': subjectCode,
      'subjectName': subjectName,
      'academicYear': academicYear,
      'postCount': postCount,
      'color': color,
      'icon': icon.codePoint,
    };
  }

  //For firestore
  factory SubjectModel.fromFirestore(Map<String, dynamic> data, String id){
    return SubjectModel(
        subjectCode: data['subjectCode'] ?? '',
        subjectName: data['subjectName'] ?? '',
        postCount: data['postCount'] ?? 0,
    );
  }

}