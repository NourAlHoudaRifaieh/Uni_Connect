import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String notificationId;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final String userId;
  // final String? initials;
  final String senderName;
  final String type;

  NotificationModel({
    required this.notificationId,
    required this.content,
    required this.createdAt,
    this.isRead = false,
    // this.initials,
    required this.userId,
    this.senderName = '',
    this.type = 'general',
  });

  String get initials {
    final parts = senderName.trim().split(RegExp(r'\s+'));
    if (senderName.trim().isEmpty) return 'UC';
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
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

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] ?? '',
      content: json['content'] ?? '',
      isRead: json['isRead'] ?? false,
      // initials: json['initials'],
      userId: json['userId'] ?? '',
      senderName: json['senderName'] ?? '',
      type: json['type'] ?? 'general',
      createdAt: json['createdAt'] is DateTime
          ? json['createdAt']
          : (json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now()
      ),
    );
  }

  factory NotificationModel.fromFirestore(Map<String, dynamic> data, String id){
    return NotificationModel(
        notificationId: id,
        content: data['content'] ?? '',
        isRead: data['isRead'] ?? false,
        userId: data['userId'] ?? '',
        senderName: data['senderName'] ?? '',
        type: data['type'] ?? 'general',
        createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      // 'initials': initials,
      'userId': userId,
      'senderName': senderName,
      'type': type,
    };
  }

  NotificationModel copyWith({
    String? notificationId,
    String? content,
    DateTime? createdAt,
    bool? isRead,
    // String? initials,
    String? userId,
    String? senderName,
    String? type,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      // initials: initials ?? this.initials,
      userId:  userId ?? this.userId,
      senderName:  senderName ?? this.senderName,
      type:  type ?? this.type,
    );
  }
}