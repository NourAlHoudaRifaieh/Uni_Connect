import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel{
  final String? postId;
  // final String title;
  final String description;
  final String? userId;
  final String authorName;
  final String? categoryId;
  final String? categoryName;
  final String? subjectId;
  final String? subjectCode;
  final DateTime createdAt;
  final String? groupId;
  final int comments;
  final List<dynamic> likedBy;
  final bool isEdited;
  final String authorRole;

  PostModel({
    this.postId,
    // required this.title,
    required this.description,
    required this.authorName,
    this.userId,
    this.categoryId,
    this.categoryName,
    this.subjectId,
    this.subjectCode,
    required this.createdAt,
    this.groupId,
    this.isEdited = false,
    this.comments =0,
    this.likedBy = const[],
    this.authorRole = 'student',
  });

  PostModel copyWith({
    String? postId,
    // String? title,
    String? description,
    String? userId,
    String? authorName,
    String? categoryId,
    String? categoryName,
    String? subjectId,
    String? subjectCode,
    String? groupId,
    DateTime? createdAt,
    int? comments,
    List<dynamic>? likedBy,
    bool? isEdited,
    String? authorRole,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      // title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      authorName: authorName ?? this.authorName,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      subjectId: subjectId ?? this.subjectId,
      subjectCode: subjectCode ?? this.subjectCode,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
      comments: comments ?? this.comments,
      likedBy: likedBy ?? this.likedBy,
      isEdited: isEdited ?? this.isEdited,
      authorRole: authorRole ?? this.authorRole,
    );
  }

  int get likes => likedBy.length;
  // bool isLikedBy(String userId) => likedBy.contains(userId);
  bool isLikedBy(String userId) => likedBy.any((item) {
    if(item is Map){
      return item['userId'] == userId;
    }
    return item == userId;
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
      // title: json['title'] ?? '',
      description: json['description'] ?? '',
      userId: json['userId'] ?? '',
      authorName: json['authorName'] ?? '',
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      subjectId: json['subjectId'] as String?,
      subjectCode: json['subjectCode'] as String?,
      groupId: json['groupId'] as String?,
      comments: json['comments'] ?? 0,
      likedBy: json['likedBy'] ?? [],
      isEdited:  json['isEdited'] == true,
      authorRole: json['authorRole'] ?? 'student',
      createdAt: json['createdAt'] is DateTime
        ? json['createdAt']
        : (json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now()
        ),
    );
  }

  factory PostModel.fromFirestore(Map<String, dynamic> data, String id){
    return PostModel(
      postId: id,
      // title: data['title'] ?? '',
      description: data['description'] ?? '',
      userId: data['userId'] as String?,
      authorName: data['authorName'] ?? '',
      categoryId: data['categoryId'] as String?,
      categoryName: data['categoryName'] as String?,
      subjectId: data['subjectId'] as String?,
      subjectCode: data['subjectCode'] as String?,
      groupId: data['groupId'] as String?,
      comments: data['comments'] ?? 0,
      isEdited:  data['isEdited'] == true,
      authorRole: data['authorRole'] ?? 'student',
      likedBy: (data['likedBy'] as List<dynamic>? ?? []),
      createdAt: data['createdAt'] is Timestamp
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      // 'title': title,
      'description': description,
      if(userId!= null) 'userId': userId,
      'authorName': authorName,
      if(categoryId != null) 'categoryId': categoryId,
      if(categoryName != null) 'categoryName': categoryName,
      if(subjectId != null) 'subjectId': subjectId,
      if(subjectCode != null) 'subjectCode': subjectCode,
      if(groupId != null) 'groupId': groupId,
      'comments': comments,
      'likedBy': likedBy,
      'isEdited': isEdited,
      'authorRole': authorRole,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }


}