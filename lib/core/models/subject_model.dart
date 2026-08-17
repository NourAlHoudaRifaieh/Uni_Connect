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
    required this.color,
    required this.icon,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json){
    return SubjectModel(
        subjectId: json['subjectId'] ?? '',
        subjectCode: json['subjectCode'] ?? '',
      subjectName: json['subjectName'] ?? '',
        academicYear: json['academicYear'] ?? '',
        postCount: json['postCount'] ?? 0,
        color: Colors.blue,
        icon: Icons.menu_book,
    );
  }
}