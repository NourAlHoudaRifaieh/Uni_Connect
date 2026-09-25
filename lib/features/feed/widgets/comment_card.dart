import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/reply_model.dart';

class CommentCard extends StatelessWidget {

  final ReplyModel reply;

  const CommentCard({
    super.key,
    required this.reply,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final authorName = reply.authorName.isNotEmpty ? reply.authorName : 'Anonymous';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding:  EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Color(0xFF1D61FF),
                    child: Text(
                      reply.authorInitials,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  SizedBox(width:8),
                  Text(
                    reply.formattedAuthorName,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      // color: Color(0xFF1D61FF)
                    ),
                  ),
                ],
              ),
              Text(
                reply.timeAgo,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            reply.content,
            style: GoogleFonts.inter(
              fontSize: 13,
              // color: Colors.
            ),
          ),
        ],
      ),
    );
  }
}