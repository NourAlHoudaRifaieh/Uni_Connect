import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/mock/mock_data.dart';
import 'package:uni_connect/features/feed/presentation/student/post_details_screen.dart';
import '../../../../core/models/post_model.dart';

class PostCard extends StatelessWidget{
  final PostModel post;
  final VoidCallback? onTap;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  const PostCard({
    super.key,
    this.onTap,
    required this.post,
    this.onLikeTap,
    this.onCommentTap,
    this.onEditPressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context){
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return GestureDetector(
      // onTap: () async{
      //   //Get the updated post object from MockData
      //   final currentPost = MockData.posts.firstWhere(
      //       (p) => p.postId == post.postId,
      //     orElse: () => post,
      //   );
      //   await Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context)=> PostDetailsScreen(post:post)),
      //   );
      //   if(onTap != null) onTap!();
      // },
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom:14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset:Offset(0,8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF1D61FF),
                  child: Text(
                    post.authorInitials,
                    style: GoogleFonts.inter(
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
                        post.authorName,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize:14
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                           post.timeAgo,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey.shade600
                            ),
                          ),
                          if(post.subjectCode !=null && post.subjectCode!.isNotEmpty) ...[
                            Text(
                              ' . ',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey.shade600
                              ),
                            ),
                            Text(
                              post.subjectCode!,
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey.shade600
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                  ),
                  color: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  offset: const Offset(-5, 30),
                  onSelected: (value) {
                    if (value == 'edit' && onEditPressed != null) {
                      onEditPressed!();
                    } else if (value == 'delete' && onDeletePressed != null) {
                      onDeletePressed!();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined, color: Color(0xFF2563EB), size: 15),
                          const SizedBox(width: 8),
                          Text(
                            'Edit',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF2563EB),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, color: Colors.redAccent, size: 15),
                          const SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: GoogleFonts.inter(
                              color: Colors.redAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  child: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                ),
                // GestureDetector(
                //   behavior: HitTestBehavior.opaque,
                //   onTap: (){},
                //   child: Icon(Icons.more_vert, size: 20),
                // ),
              ],
            ),
            const SizedBox(height:10),
            Text(
              post.title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize:15,
              ),
            ),
            const SizedBox(height:4),
            Text(
              post.description,
              maxLines:3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize:13,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height:20),
            Row(
              children: [
                if (post.categoryName != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal:20, vertical:4),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D61FF).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      post.categoryName!,
                      style: GoogleFonts.inter(
                        color: Color(0xFF1D61FF),
                        fontWeight: FontWeight.bold,
                        fontSize:13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Spacer(),
                GestureDetector(
                  onTap: (){
                    if(post.postId != null && currentUserId.isNotEmpty){
                      MockData.toggleLike(post.postId!, currentUserId);
                      if(onLikeTap !=null) onLikeTap!();
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Icon(
                        post.isLikedBy(currentUserId) ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: post.isLikedBy(currentUserId) ? Colors.red : Colors.grey.shade600,
                      ),
                      SizedBox(width:4),
                      Text(
                        '${post.likes}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: post.isLikedBy(currentUserId) ? FontWeight.bold : FontWeight.normal,
                          color:post.isLikedBy(currentUserId) ? Colors.red: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Icon(Icons.favorite_border, size: 16, color: Colors.grey.shade600),
                // SizedBox(width:4),
                // Text('${post.likes}', style: TextStyle(fontSize:12, color: Colors.grey.shade600)),
                SizedBox(width:10),
                Icon(Icons.mode_comment_outlined, size:16, color: Colors.grey.shade600),
                SizedBox(width:4),
                Text('${post.comments}', style: TextStyle(fontSize:12, color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}