import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uni_connect/core/models/group_model.dart';
import 'package:uni_connect/core/models/reply_model.dart';
import 'package:uni_connect/core/models/subject_model.dart';
import 'package:uni_connect/core/models/user_model.dart';

import '../models/notification_model.dart';
import '../models/post_model.dart';

class MockData {

  // raw JSON list matching local storage format
  static final List<Map<String, dynamic>> subjectsJson = [
    {
      'subjectId': 'sub_1',
      'subjectName': 'Theses Project',
      'subjectCode': 'THE601',
      'academicYear': 'Year 5',
      'postCount': 5,
    },
    {
      'subjectId': 'sub_2',
      'subjectName': 'Advanced Data Analysis',
      'subjectCode': 'ADA601',
      'academicYear': 'Year 4',
      'postCount': 9,
    },
    {
      'subjectId': 'sub_3',
      'subjectName': 'Leadership & Innovation',
      'subjectCode': 'LDR601',
      'academicYear': 'Year 3',
      'postCount': 5,
    },
  ];
  //Parsed Subject List using SubjectModel.fromJson
  // static List<SubjectModel> get subjects {
  //   return subjectsJson.map((json)=> SubjectModel.fromJson(json)).toList();
  // }
  static final List<SubjectModel> _subjectList =
    subjectsJson.map((json) => SubjectModel .fromJson(json)).toList();

  static List <SubjectModel> get subjects => _subjectList;
  //Add a new subject
  static void addSubject(SubjectModel newSubject){
    _subjectList.insert(0, newSubject);
  }
  static void deleteSubject(String subjectId){
    _subjectList.removeWhere((s) => s.subjectId == subjectId);
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
      'isLiked': false,
    },
    {
      'postId': 'post_2',
      'title': 'Python OOP — Inheritance Pattern for AI Assignment',
      'description': "For the AI assignment I structured my neural network using Python inheritance: Layer → DenseLayer...",
      'userId': 'user_2',
      'authorName': 'Rami Farhat',
      'categoryId': 'cat_2',
      'categoryName': 'Programming',
      'subjectId': 'sub_2',
      'subjectCode': 'DB105',
      'createdAt': DateTime.now().subtract(Duration(hours: 1)).toIso8601String(),
      'likes': 2,
      'comments': 2,
      'isLiked':false,
    },
    {
      'postId': 'post_3',
      'title': 'Database Normalization - Final Exam Tips',
      'description': "Hey everyone! The final exam is next week. Professor Hajj mentioned that 3NF will be heavily tested on the test. Make sure to review functional dependencies, canonical covers, and candidate key decompositions carefully. Let's set up a study group in the campus library this Thursday around 4 PM if anyone wants to practice past exam questions together!",
      'userId': 'user_3',
      'authorName': 'Ahmad Khoury',
      'categoryId': 'cat_1',
      'categoryName': 'Exams',
      'subjectId': 'sub_3',
      'subjectCode': 'DB201',
      'createdAt': DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
      'likes': 7,
      'comments': 1,
      'isLiked': false,
    },
  ];
  //Parsed Subject List using SubjectModel.fromJson
  // static List<PostModel> get posts {
  //   return postsJson.map((json)=> PostModel.fromJson(json)).toList();
  // }
  //in memory persistent list for posts
  static final List<PostModel> _postList = postsJson.map((json) => PostModel.fromJson(json)).toList();
  static List<PostModel> get posts => _postList;
  //adds new post to the top of the in-memory list
   static void addPost(PostModel newPost){
      posts.insert(0, newPost);
   }
  // static void toggleLike(String postId) {
  //   final index = postsJson.indexWhere((json) => json['postId'] == postId);
  //   if (index != -1) {
  //     // Toggles between adding and removing a like dynamically
  //     final isLiked = postsJson[index]['isLiked'] ?? false;
  //     final currentLikes = postsJson[index]['likes'] as int? ?? 0;
  //
  //     postsJson[index]['isLiked'] = !isLiked;
  //     postsJson[index]['likes'] = isLiked ? currentLikes - 1 : currentLikes + 1;
  //   }
  static void toggleLike(String postId) {
    final index = _postList.indexWhere((post) => post.postId == postId);
    if (index != -1) {
      final post = _postList[index];
      final newIsLiked = !post.isLiked;
      final newLikes = newIsLiked ? post.likes + 1 : post.likes - 1;

      _postList[index] = PostModel(
        postId: post.postId,
        title: post.title,
        description: post.description,
        userId: post.userId,
        authorName: post.authorName,
        categoryId: post.categoryId,
        categoryName: post.categoryName,
        subjectId: post.subjectId,
        subjectCode: post.subjectCode,
        createdAt: post.createdAt,
        likes: newLikes,
        comments: post.comments,
        isLiked: newIsLiked,
      );
    }
  }


  //raw JSON list for users (students,admin)
  static final List<Map<String, dynamic>> usersJson = [
    {
      'userId': 'user_1',
      'fullName': 'Lara Haddad',
      'email': "lara.haddad@st.ul.edu.lb",
      'role': 'student',
      'faculty': 'Business Administration',
      'academicYear': 'Year 2',
      'major': 'Business Computer',
      'postCount': 5,
    },
    {
      'userId': 'user_2',
      'fullName': 'Rami Farhat',
      'email': "rami.farhat@st.ul.edu.lb",
      'role': 'student',
      'faculty': 'Business Administration',
      'academicYear': 'Year 3',
      'major': 'Management',
      'postCount': 22,
    },
    {
      'userId': 'user_3',
      'fullName': 'Ahmad Khoury',
      'email': "ahmad.khouryt@st.ul.edu.lb",
      'role': 'student',
      'faculty': 'Marketing',
      'academicYear': 'Year 4',
      'major': 'Accounting and Auditing',
      'postCount': 15,
    },
    {
      'userId': 'user_4',
      'fullName': 'Sara Mourad',
      'email': "sara.mourad@st.ul.edu.lb",
      'role': 'student',
      'faculty': 'Business Administration',
      'academicYear': 'Year 2',
      'major': 'Management',
      'postCount': 3,
    },
    {
      'userId': 'user_5',
      'fullName': 'Khalil Abi-Saab',
      'email': "khalil.abisaab@st.ul.edu.lb",
      'role': 'student',
      'faculty': 'Business Administration',
      'academicYear': 'Year 3',
      'major': 'Marketing',
      'postCount': 8,
    },
  ];
  //Parsed Users List
  static List<UserModel> get users {
    return usersJson.map((json) => UserModel.fromJson(json)).toList();
  }
  static List<UserModel> get students{
    return users.where((user) => user.isStudent).toList();
  }
  static List<UserModel> get admins{
    return users.where((user) => user.isAdmin).toList();
  }


  static final List<Map<String,dynamic>> repliesJson =[
    {
      'replyId':'reply_1',
      'postId': 'post_1',
      'userId': 'user_1',
      'authorName': 'Lara Haddad',
      'content': 'This is so helpful! Do you have practice questions too?',
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
    },
    {
      'replyId':'reply_2',
      'postId': 'post_1',
      'userId': 'user_2',
      'authorName': 'Rami Farhat',
      'content': 'What about BCNF - is that include in the exam?',
      'createdAt': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
    },
  ];
  //parsed replies List using ReplyModel.fromJson
  static List<ReplyModel> get replies{
    return repliesJson.map((json) => ReplyModel.fromJson(json)).toList();  }



  // Raw notifications JSON inside MockData
  static final List<Map<String, dynamic>> notificationsJson = [
    {
      'notificationId': 'notif_1',
      'content': 'Ahmad Khoury commented on your post "Assignment 3 — ER Diagram Help"',
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'isRead': false,
      // 'initials': 'AK',
      'userId': 'user_3',
    },
    {
      'notificationId': 'notif_2',
      'content': 'Sara Mourad and 3 others liked your post about ER diagrams',
      'createdAt': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      'isRead': false,
      // 'initials': 'SM',
      'userId': 'user_4',
    },
    {
      'notificationId': 'notif_4',
      'content': 'Rami Farhat replied to your comment on the Python OOP post',
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'isRead': true,
      // 'initials': 'RF',
      'userId':'user_2',
    },
    {
      'notificationId': 'notif_6',
      'content': 'Khalil Abi-Saab commented on the Statistics Midterm summary',
      'createdAt': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      'isRead': true,
      // 'initials': 'KA',
      'userId': 'user_5',
    },
  ];
  static final List<NotificationModel> _notificationList = notificationsJson
      .map((json) => NotificationModel.fromJson(json))
      .toList();

  static List<NotificationModel> get notifications => _notificationList;
  static void markNotificationAsRead(String notificationId) {
    final index = _notificationList.indexWhere((n) => n.notificationId == notificationId);
    if (index != -1) {
      _notificationList[index] = _notificationList[index].copyWith(isRead: true);
    }
  }
  static void markAllNotificationsAsRead() {
    for (int i = 0; i < _notificationList.length; i++) {
      _notificationList[i] = _notificationList[i].copyWith(isRead: true);
    }
  }



  // raw JSON list matching local storage format
  static final List<Map<String, dynamic>> groupsJson = [
    {
      'groupId': 'group_1',
      'groupName': 'Business Computer',
      'subjectId': 'sub_1',
      'membersCount': 187,
      'academicYear': 'Year 2',
    },
    {
      'groupId': 'group_2',
      'groupName': 'Management',
      'subjectId': 'sub_2',
      'membersCount': 203,
      'academicYear': 'Year 3',
    },
    {
      'groupId': 'group_3',
      'groupName': 'Marketing',
      'subjectId': 'sub_3',
      'membersCount': 142,
      'academicYear': 'Year 4',
    },
  ];
 // in memory persistent list for groups
  static final List<GroupModel> _groupList =
      groupsJson.map((json) => GroupModel.fromJson(json)).toList();

  static List<GroupModel> get groups => _groupList;
  //add new group
  static void addGroup(GroupModel newGroup){
    _groupList.insert(0, newGroup);
  }



}
