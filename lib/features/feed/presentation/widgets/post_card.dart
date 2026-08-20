import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/features/feed/presentation/post_details_screen.dart';
import '../../../../core/models/post_model.dart';

class PostCard extends StatelessWidget{
  final PostModel post;
  final VoidCallback? onTap;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;

  const PostCard({
    super.key,
    this.onTap,
    required this.post,
    this.onLikeTap,
    this.onCommentTap,
  });

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=> PostDetailsScreen(post:post)),
        );
      },
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
                    padding: const EdgeInsets.symmetric(horizontal:10, vertical:4),
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
                Icon(Icons.favorite_border, size: 16, color: Colors.grey.shade600),
                SizedBox(width:4),
                Text('${post.likes}', style: TextStyle(fontSize:12, color: Colors.grey.shade600)),
                SizedBox(width:16),
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