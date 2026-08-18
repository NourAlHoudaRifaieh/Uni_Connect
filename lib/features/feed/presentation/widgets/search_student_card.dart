import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/features/feed/presentation/widgets/seach_post_card.dart';

class SearchStudentCardData{
  // final String category;
  final String authorInitials;
  final Color avatarColor;
  // final Color categoryColor;
  // final String subjectCode;
  // final String title;
  // final String preview;
  final String authorName;
  // final int likes;
  // final int comments;
  final String email;
  final String faculty;
  final String year;
  final int postCount;

  const SearchStudentCardData({
    // required this.category,
    // required this.categoryColor,
    // required this.subjectCode,
    required this.authorInitials,
    required this.avatarColor,
    // required this.title,
    // required this.preview,
    // required this.likes,
    // required this.comments,
    required this.authorName,
    required this.email,
    required this.faculty,
    required this.year,
    required this.postCount,
  });
}

class SearchStudentCard extends StatelessWidget {

  final SearchStudentCardData data;

  SearchStudentCard({
    super.key,
    required this.data,
  });

  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
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
                backgroundColor:Color(0xFF1D61FF),
                child: Text(
                  data.authorName,
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
                      data.authorInitials,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize:14
                      ),
                    ),
                    Text(
                      data.email,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600
                      ),
                    ),
                    Text(
                      '${data.faculty} - ${data.year}',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment:  CrossAxisAlignment.end,
                children: [
                  Text(
                    '${data.postCount}',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize:14
                    ),
                  ),
                  Text(
                    'Posts',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade600
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
