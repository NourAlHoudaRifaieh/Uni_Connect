import 'package:cloud_firestore/cloud_firestore.dart';

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
  // final int likes;
  final int comments;
  // final bool isLiked;
  final List<String> likedBy;

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
    // this.likes =0,
    this.comments =0,
    // this.isLiked = false,
    this.likedBy = const[],
  });

  PostModel copyWith({
    String? postId,
    String? title,
    String? description,
    String? userId,
    String? authorName,
    String? categoryId,
    String? categoryName,
    String? subjectId,
    String? subjectCode,
    DateTime? createdAt,
    int? comments,
    List<String>? likedBy,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      authorName: authorName ?? this.authorName,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      subjectId: subjectId ?? this.subjectId,
      subjectCode: subjectCode ?? this.subjectCode,
      createdAt: createdAt ?? this.createdAt,
      comments: comments ?? this.comments,
      likedBy: likedBy ?? this.likedBy,
    );
  }

  int get likes => likedBy.length;
  bool isLikedBy(String userId) => likedBy.contains(userId);

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
      authorName: json['authorName'] ?? '',
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      subjectId: json['subjectId'] as String?,
      subjectCode: json['subjectCode'] as String?,
      // likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      // isLiked: json['isLiked'] ??  false,
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
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      userId: data['userId'] as String?,
      authorName: data['authorName'] ?? '',
      categoryId: data['categoryId'] as String?,
      categoryName: data['categoryName'] as String?,
      subjectId: data['subjectId'] as String?,
      subjectCode: data['subjectCode'] as String?,
      comments: data['comments'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      createdAt: data['createdAt'] is Timestamp
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      // if(postId != null) 'postId': postId,
      'title': title,
      'description': description,
      // 'userId': userId,
      if(userId!= null) 'userId': userId,
      'authorName': authorName,
      // 'categoryId': categoryId,
      // 'categoryName': categoryName,
      // 'authorInitials': authorInitials,
      if(categoryId != null) 'categoryId': categoryId,
      if(categoryName != null) 'categoryName': categoryName,
      if(subjectId != null) 'subjectId': subjectId,
      if(subjectCode != null) 'subjectCode': subjectCode,
      // 'likes': likes,
      'comments': comments,
      // 'isLiked': isLiked,
      // 'createdAt': createdAt.toIso8601String(),
      'likedBy': likedBy,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }


}