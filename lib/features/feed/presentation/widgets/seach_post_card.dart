import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPostCardData{
  final String category;
  final Color categoryColor;
  final String subjectCode;
  final String title;
  final String preview;
  final String authorName;
  final int likes;
  final int comments;

  const SearchPostCardData({
    required this.category,
    required this.categoryColor,
    required this.subjectCode,
    required this.title,
    required this.preview,
    required this.likes,
    required this.comments,
    required this.authorName,
  });
}

class SearchPostCard extends StatelessWidget {
  final SearchPostCardData data;

  SearchPostCard({
    super.key,
    required this.data,
  });

  @override
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal:10, vertical:4),
                decoration: BoxDecoration(
                  color: Color(0xFF1D61FF).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data.category,
                  style: GoogleFonts.inter(
                    color: Color(0xFF1D61FF),
                    fontWeight: FontWeight.bold,
                    fontSize:13,
                  ),
                ),
              ),
              SizedBox(width:10),
              Text(
                '${data.subjectCode}',
                style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade600
                ),
              ),
            ],
          ),
          SizedBox(height:10),
          Text(data.title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 15
            ),
          ),
          SizedBox(height:5),
          Text(data.preview,
            // maxLines:3,
            // overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize:13,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height:10),
          Row(
            children: [
              Text(
                data.authorName,
                style: GoogleFonts.inter(
                    fontSize:14
                ),
              ),
              SizedBox(width:10),
              Text('${data.likes} likes', style: TextStyle(fontSize:12, color: Colors.grey.shade600)),
              SizedBox(width:10),
              Text('${data.comments} comments', style: TextStyle(fontSize:12, color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }
}
