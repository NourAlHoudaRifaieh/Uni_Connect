import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/features/feed/presentation/widgets/category_selector.dart';
import 'package:uni_connect/features/feed/presentation/widgets/post_card.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/models/post_model.dart';
import '../../../core/models/subject_model.dart';

class PostDetailsScreen extends StatefulWidget {

  final PostModel post;

  PostDetailsScreen({
    super.key,
    required this.post,
  });

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {

  SubjectModel? _getSubject(String subjectId) {
    try {
      return MockData.subjects.firstWhere(
            (subject) => subject.subjectId == subjectId,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final post = widget.post;
    final subject = _getSubject(post.subjectId ?? '');

    return Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.chevron_left, color: Color(0xFF2563EB), size:20),
                        Text('Back', style: GoogleFonts.inter(color: Color(0xFF2563EB), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  SizedBox(height:15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      SizedBox(width:8),
                      Row(
                        children: [
                          Container(
                            width:6,
                            height:6,
                            decoration: BoxDecoration(
                              color: Color(0xFF1D61FF),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width:6),
                          if (subject!= null)
                            Text(
                              subject.subjectName,
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize:13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height:15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( post.title,
                          style: GoogleFonts.inter(fontSize: 18, fontWeight:  FontWeight.bold)
                      ),
                    ],
                  ),
                  SizedBox(height:15),
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
                ],
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFF1F5F9),
                    width:1.5,
                  ),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset:Offset(0,8),
                  ),
                ],
              ),
            ),
            SizedBox(height:10),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top:10),
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
                  Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFF1F5F9),
                          width:1,
                        ),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset:Offset(0,8),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height:10),
                  Row(
                    children: [
                      Icon(Icons.favorite_border, size: 16, color: Colors.grey.shade600),
                      SizedBox(width:4),
                      Text('${post.likes} Likes', style: TextStyle(fontSize:12, color: Colors.grey.shade600)),
                      SizedBox(width:16),
                      Icon(Icons.mode_comment_outlined, size:16, color: Colors.grey.shade600),
                      SizedBox(width:4),
                      Text('${post.comments} Comments', style: TextStyle(fontSize:12, color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
