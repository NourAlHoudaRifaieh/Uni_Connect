import 'package:flutter/material.dart';

class PostModel{
  final String? postId;
  final String title;
  final String description;
  final String? userId;
  final String authorName;
  final String? categoryId;
  final String? categoryName;
  final String? subjectId;
  final String? subjectCode;
  final DateTime createdAt;
  final int likes;
  final int comments;

  PostModel({
    this.postId,
    required this.title,
    required this.description,
    required this.authorName,
    this.userId,
    this.categoryId,
    this.categoryName,
    this.subjectId,
    this.subjectCode,
    required this.createdAt,
    this.likes =0,
    this.comments =0,
  });

  String get authorInitials {
    final trimmedName = authorName.trim();
    if(trimmedName.isEmpty) return 'U';
    final parts = trimmedName.split(RegExp(r'\s+'));
    if(parts.length ==1 ) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length -1][0]}'.toUpperCase();
  }

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    if(difference.inMinutes <60){
      final mins = difference.inMinutes <= 0 ? 1 : difference.inMinutes;
      return '${mins}m ago';
    }else if (difference.inHours < 24){
      return '${difference.inHours}h ago';
    }else{
      return '${difference.inDays}d ago';
    }
  }

  factory PostModel.fromJson(Map<String, dynamic> json){
    return PostModel(
      postId: json['postId'] as String?,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      userId: json['userId'] ?? '',
      authorName: json['authorName'] ?? 0,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      subjectId: json['subjectId'] as String?,
      subjectCode: json['subjectCode'] as String?,
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      createdAt: json['createdAt'] is DateTime
        ? json['createdAt']
        : (json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now()
        ),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      if(postId != null) 'postId': postId,
      'title': title,
      'description': description,
      'userId': userId,
      'authorName': authorName,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'authorInitials': authorInitials,
      if(categoryId != null) 'categoryId': categoryId,
      if(categoryName != null) 'categoryName': categoryName,
      if(subjectId != null) 'subjectId': subjectId,
      if(subjectCode != null) 'subjectCode': subjectCode,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
    };
  }


}