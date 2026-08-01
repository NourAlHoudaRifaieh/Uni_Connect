import 'package:flutter/material.dart';

class PostCardData{
  final String authorName;
  final String authorInitials;
  final Color avatarColor;
  final String subjectCode;
  final String timeAgo;
  final String category;
  final Color categoryColor;
  final String title;
  final String preview;
  final int likes;
  final int comments;

  PostCardData({
    required this.title,
    required this.authorInitials,
    required this.authorName,
    required this.avatarColor,
    required this.category,
    required this.categoryColor,
    required this.comments,
    required this.likes,
    required this.preview,
    required this.subjectCode,
    required this.timeAgo,
  });
}

class PostCard extends StatelessWidget{
  final PostCardData data;
  final VoidCallback? onTap;

  const PostCard({
    super.key,
    this.onTap, required this.data
  });

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom:12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor:  data.avatarColor,
                  child: Text(
                    data.authorInitials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:13,
                    ),
                  ),
                ),
                const SizedBox(width:10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.authorName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:14
                        ),
                      ),
                      Text(
                        data.timeAgo + ' . ' + data.subjectCode,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal:10, vertical:4),
                  decoration: BoxDecoration(
                    color: data.categoryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data.category,
                    style: TextStyle(
                      color: data.categoryColor,
                      fontWeight: FontWeight.w600,
                      fontSize:12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height:10),
            Text(
              data.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:15,
              ),
            ),
            const SizedBox(height:4),
            Text(
              data.preview,
              maxLines:3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize:13,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height:10),

            Row(
              children: [
                Icon(Icons.favorite_border, size: 16, color: Colors.grey.shade600),
                SizedBox(width:4),
                Text('${data.likes}', style: TextStyle(fontSize:12, color: Colors.grey.shade600)),
                SizedBox(width:16),
                Icon(Icons.mode_comment_outlined, size:16, color: Colors.grey.shade600),
                SizedBox(width:4),
                Text('${data.comments}', style: TextStyle(fontSize:12, color: Colors.grey.shade600)),

                // const Spacer(),
                // Icon(Icons.bookmark_border, size:18, color: Colors.grey.shade600),

              ],
            ),
          ],
        ),
      ),
    );
  }
}