import 'package:flutter/material.dart';

class ReplyModel{
  final String replyId;
  final String postId;
  final String userId;
  final String authorName;
  final String content;
  final DateTime createdAt;

  ReplyModel({
    required this.replyId,
    required this.postId,
    required this.userId,
    required this.authorName,
    required this.content,
    required this.createdAt,
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
    if (difference.inMinutes < 60) {
      final mins = difference.inMinutes <= 0 ? 1 : difference.inMinutes;
      return '${mins}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  factory ReplyModel.fromJson(Map<String, dynamic> json){
    return ReplyModel(
        replyId: json['replyId'] ?? '',
        postId: json['postId'] ?? '',
        authorName: json['authorName'] ?? '',
        userId: json['userId']?? '',
        content: json['content'] ?? '',
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
      if( replyId != null) 'replyId': replyId,
      'postId': postId,
      if(userId != null) 'userId': userId,
      'authorName': authorName,
      'authorInitials': authorInitials,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }


}