import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/post_model.dart';
import 'package:uni_connect/features/auth/data/post_repository.dart';
import 'package:uni_connect/features/auth/data/user_repository.dart';

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

  Future<void> _defaultToggleLike() async{
    final u = FirebaseAuth.instance.currentUser;
    if(u == null || post.postId == null) return;
    final name = (u.displayName != null && u.displayName!.trim().isNotEmpty)
        ? u.displayName!.trim()
        : (u.email?.split('@').first ?? 'User');
    await PostRepository().toggleLike(post.postId!, u.uid, name);
  }

  @override
  Widget build(BuildContext context){
    final authUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final currentUserId = UserRepository.cachedDocId ?? authUid;
    final liked = post.isLikedBy(currentUserId) || post.isLikedBy(authUid);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom:14),
        padding: EdgeInsets.all(14),
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
                SizedBox(width:10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              post.authorName,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if(post.authorRole == 'admin')
                            Container(
                              margin: EdgeInsets.only(left:6),
                              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color:Color(0xFF2563EB).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Admin',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            )
                        ],
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
                          if(post.isEdited)
                            Text(
                              '(Edited)',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey.shade500,
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
                  offset: Offset(-5, 30),
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
                          Icon(Icons.edit_outlined, color: Color(0xFF2563EB), size: 15),
                          SizedBox(width: 8),
                          Text(
                            'Edit',
                            style: GoogleFonts.inter(
                              color: Color(0xFF2563EB),
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
                          Icon(Icons.delete_outline, color: Colors.redAccent, size: 15),
                          SizedBox(width: 8),
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
                  child: Icon(Icons.more_vert, size: 20, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height:10),
            Text(
              post.description,
              maxLines:3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize:13,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height:15),
            Row(
              children: [
                if (post.categoryName != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal:20, vertical:4),
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
                    if(post.postId == null || currentUserId.isEmpty) return;
                      if(onLikeTap !=null){
                        onLikeTap!();
                      }else{
                        _defaultToggleLike();
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