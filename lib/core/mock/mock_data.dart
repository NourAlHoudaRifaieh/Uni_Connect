import 'package:flutter/material.dart';
import 'package:uni_connect/core/models/subject_model.dart';

class MockData {

  // raw JSON list matching local storage format
  static final List<Map<String, dynamic>> subjectsJson = [
    {
      'subjectName': 'Theses Project',
      'subjectCode': 'THE601',
      'academicYear': 'Master 2',
      'postCount': 5,
      'colorHex': Colors.red.value.toString(),
      'iconCode': Icons.menu_book.codePoint,
    },
    {
      'subjectName': 'Advanced Data Analysis',
      'subjectCode': 'ADA601',
      'academicYear': 'Master 1',
      'postCount': 9,
      'colorHex': Colors.green.value.toString(),
      'iconCode': Icons.menu_book.codePoint,
    },
    {
      'subjectName': 'Leadership & Innovation',
      'subjectCode': 'LDR601',
      'academicYear': 'Year 3',
      'postCount': 5,
      'colorHex': Colors.blue.value.toString(),
      'iconCode': Icons.menu_book.codePoint,
    },
  ];

  //Parsed Subject List using SubjectModel.fromJson
  static List<SubjectModel> get subjects {
    return subjectsJson.map((json)=> SubjectModel.fromJson(json)).toList();
  }

}