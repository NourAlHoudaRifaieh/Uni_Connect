class NotificationModel {
  final String notificationId;
  final String title;
  final String timeAgo;
  final bool isRead;
  final String? initials; 

  NotificationModel({
    required this.notificationId,
    required this.title,
    required this.timeAgo,
    this.isRead = false,
    this.initials,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] ?? '',
      title: json['title'] ?? '',
      timeAgo: json['timeAgo'] ?? '',
      isRead: json['isRead'] ?? false,
      initials: json['initials'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'title': title,
      'timeAgo': timeAgo,
      'isRead': isRead,
      'initials': initials,
    };
  }

  NotificationModel copyWith({
    String? notificationId,
    String? title,
    String? timeAgo,
    bool? isRead,
    String? initials,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      timeAgo: timeAgo ?? this.timeAgo,
      isRead: isRead ?? this.isRead,
      initials: initials ?? this.initials,
    );
  }
}