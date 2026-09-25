import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/features/auth/data/user_repository.dart';
import 'package:uni_connect/features/feed/presentation/widgets/search_post_card.dart';

import '../../../../core/models/user_model.dart';

class SearchStudentCard extends StatelessWidget {

  final UserModel user;

  SearchStudentCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final facultyText = user.faculty ?? '';
    final yearText = user.academicYear ?? '';
    final metadataLine =[
      if(facultyText.isNotEmpty) facultyText,
      if(yearText.isNotEmpty) yearText,
    ].join('-');

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
                  user.authorInitials.isNotEmpty ? user.authorInitials : "U",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize:13,
                  ),
                  maxLines: 1,
                  overflow:  TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width:10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName ,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize:14
                      ),
                    ),
                    Text(
                      user.email,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600
                      ),
                      maxLines: 1,
                      overflow:  TextOverflow.ellipsis,
                    ),
                    Text(
                      metadataLine.isNotEmpty ? metadataLine : 'No details provided',
                      // '${user.faculty} - ${user.academicYear}',
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
                    '${user.postCount}',
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
