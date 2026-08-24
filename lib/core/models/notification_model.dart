class NotificationModel {
  final String notificationId;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final String? initials; 

  NotificationModel({
    required this.notificationId,
    required this.content,
    required this.createdAt,
    this.isRead = false,
    this.initials,
  });

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
      initials: json['initials'],
      createdAt: json['createdAt'] is DateTime
          ? json['createdAt']
          : (json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now()
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'initials': initials,
    };
  }

  NotificationModel copyWith({
    String? notificationId,
    String? content,
    DateTime? createdAt,
    bool? isRead,
    String? initials,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      initials: initials ?? this.initials,
    );
  }
}