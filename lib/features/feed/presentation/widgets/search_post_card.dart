import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/models/post_model.dart';


class SearchPostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onTap;

  SearchPostCard({
    super.key,
    required this.post,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
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
              children: [
                if (post.categoryName != null) ...[
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
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal:10, vertical:4),
                  //   decoration: BoxDecoration(
                  //     color: Color(0xFF1D61FF).withOpacity(0.15),
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: Text(
                  //     post.categoryName!,
                  //     style: GoogleFonts.inter(
                  //       color: Color(0xFF1D61FF),
                  //       fontWeight: FontWeight.bold,
                  //       fontSize:13,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(width:10),
                ],
                Text(
                  '${post.subjectCode}',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade600
                  ),
                ),
              ],
            ),
            SizedBox(height:10),
            Text(post.title,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),
            ),
            SizedBox(height:5),
            Text(post.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize:13,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height:10),
            Row(
              children: [
                Text(
                  post.authorName,
                  style: GoogleFonts.inter(
                      fontSize:14,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Spacer(),
                // SizedBox(width:15),
                Text('${post.likes} likes', style: TextStyle(fontSize:12, color: Colors.grey.shade600)),
                SizedBox(width:15),
                Text('${post.comments} comments', style: TextStyle(fontSize:12, color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
