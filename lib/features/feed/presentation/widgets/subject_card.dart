import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/subject_model.dart';

import '../../../../core/mock/mock_data.dart';

class SubjectCard extends StatelessWidget {
  final SubjectModel? subject;
  final String? academicYear;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

   SubjectCard({
    super.key,
    this.subject,
    this.academicYear,
    this.onEditPressed,
    this.onDeletePressed,
  });
  // final List<SubjectModel> subjects = MockData.subjects;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(20),
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
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF1D61FF).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.menu_book, color: Color(0xFF1D61FF), size:20),
          ),
          SizedBox(width:10),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (subject?.subjectCode != null && subject!.subjectCode!.isNotEmpty)
                    Text(
                      subject!.subjectCode!,
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey.shade500
                      ),
                    ),
                    SizedBox(height:2),
                    Text(
                      subject?.subjectName ?? '',
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.bold
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height:2),
                    Text(
                        '${subject?.postCount ?? 0} posts',
                        style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500)
                    ),
                ],
              ),
          ),
          // Spacer(),
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
        ],
      ),
    );
  }
}
