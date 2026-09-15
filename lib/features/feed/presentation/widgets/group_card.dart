import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/subject_model.dart';
import '../../../../core/models/group_model.dart';
import '../../../../core/models/user_model.dart';

class GroupCard extends StatelessWidget {

  final GroupModel group;
  final SubjectModel? subject;
  final UserModel? user;
  final String? academicYear;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  const GroupCard({
    super.key,
    required this.group,
    this.subject,
    this.user,
    this.academicYear,
    this.onEditPressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final rawYear = academicYear ?? group.academicYear ?? user?.academicYear;
    final bool hasYear = rawYear != null && rawYear.trim().isNotEmpty && rawYear != 'N/A';
    final String displayYear = hasYear ? rawYear : '';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // '${group.groupName} - ${subject?.academicYear ?? "N/A"}',
                // '${group.groupName} - $displayYear',
                hasYear ? '${group.groupName} - $displayYear' : group.groupName,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
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
          SizedBox(height:15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xFF1D61FF).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      // '187',
                      '${group.membersCount}',
                      style: GoogleFonts.inter(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height:2),
                    Text(
                      'Members',
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xFF1D61FF).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      // '145',
                      '${subject?.postCount ?? 0}',
                      style: GoogleFonts.inter(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height:2),
                    Text(
                      'Posts',
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xFF1D61FF).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      // 'Y1',
                      // subject?.academicYear ?? 'N/A',
                      displayYear.isNotEmpty ? displayYear : 'N/A',
                      // displayYear,
                      style: GoogleFonts.inter(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height:2),
                    Text(
                      'Year',
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}