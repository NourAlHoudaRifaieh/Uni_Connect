import 'package:flutter/material.dart';
import 'package:uni_connect/core/models/subject_model.dart';

import '../models/post_model.dart';

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

  //raw JSON list for post
  static final List<Map<String, dynamic>> postsJson = [
    {
      'postId': 'post_1',
      'title': 'Assignment 3 - ER Diagram help Needed',
      'description': "I'm stuck on the ER Diagram Help Needed",
      'userId': 'user_1',
      'authorName': 'Lara Haddad',
      'categoryId': 'cat_1',
      'categoryName': 'Assignments',
      'subjectId': 'sub_1',
      'subjectCode': 'D109',
      'createdAt': DateTime.now().subtract(Duration(hours: 5)).toIso8601String(),
      'likes': 7,
      'comments': 2,
    },
    {
      'postId': 'post_2',
      'title': 'Python OOP — Inheritance Pattern for AI Assignment',
      'description': "For the AI assignment I structured my neural network using Python inheritance: Layer → DenseLayer...",
      'userId': 'user_2',
      'authorName': 'Rami Farhat',
      'categoryId': 'cat_2',
      'categoryName': 'Programming',
      'subjectId': 'sub_1',
      'subjectCode': 'DB105',
      'createdAt': DateTime.now().subtract(Duration(hours: 1)).toIso8601String(),
      'likes': 2,
      'comments': 2,
    },
    {
      'postId': 'post_id',
      'title': 'Database Normalization - Final Exam Tips',
      'description': "Hey everyone! The final exam is next week. Professor Hajj mentioned that 3NF will be heavily testes...",
      'userId': 'user_3',
      'authorName': 'Ahmad Khoury',
      'categoryId': 'cat_1',
      'categoryName': 'Exams',
      'subjectId': 'sub_1',
      'subjectCode': 'DB201',
      'createdAt': DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
      'likes': 7,
      'comments': 1,
    },
  ];

  //Parsed Subject List using SubjectModel.fromJson
  static List<PostModel> get posts {
    return postsJson.map((json)=> PostModel.fromJson(json)).toList();
  }

}