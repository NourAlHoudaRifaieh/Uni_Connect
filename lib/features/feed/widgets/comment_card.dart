import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/reply_model.dart';
import 'package:uni_connect/features/auth/data/user_repository.dart';

class CommentCard extends StatelessWidget {

  final ReplyModel reply;

  const CommentCard({
    super.key,
    required this.reply,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final me = UserRepository.cachedDocId;
    final isMine = reply.userId.isNotEmpty && (reply.userId == me || reply.userId == FirebaseAuth.instance.currentUser?.uid);
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
                  if(reply.authorRole == 'admin')
                    Container(
                      margin: EdgeInsets.only(left:6),
                      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color:Color(0xFF2563EB).withValues(alpha:0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Admin',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color:Color(0xFF2563EB),
                        ),
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