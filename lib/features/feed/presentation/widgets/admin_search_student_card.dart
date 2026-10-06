import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/group_model.dart';
import 'package:uni_connect/core/models/user_model.dart';
import 'package:uni_connect/features/auth/data/group_repository.dart';

class AdminSearchStudentCard extends StatelessWidget {

  final UserModel user;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final GroupRepository _groupRepository = GroupRepository();

  AdminSearchStudentCard({
    super.key,
    required this.user,
    required this.onDeletePressed,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(14),
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
                  user.authorInitials,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize:13,
                  ),
                  maxLines: 1,
                  overflow:  TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width:10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
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
                    SizedBox(height:2),
                    user.groupId != null && user.groupId!.isNotEmpty
                      ? FutureBuilder<GroupModel?>(
                          future: _groupRepository.getGroupById(user.groupId!),
                          builder: (context, snapshot){
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text(
                                'Loading group...',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                  fontStyle: FontStyle.italic,
                                ),
                              );
                            }
                            final group = snapshot.data;
                            if(group == null){
                              return Text(
                                'Group not found',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.red.shade400,
                                ),
                              );
                            }
                            final details = [
                              if(group.faculty != null && group.faculty!.isNotEmpty) group.faculty!,
                              if(group.groupName.isNotEmpty) group.groupName,
                              if(group.academicYear != null) group.academicYear!,
                            ].join(' - ');
                            return Text(
                              details.isNotEmpty ? details : 'No details provided',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            );
                          }
                        )
                      : Text(
                        'No group assigned',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    // Text(
                    //   '${user.faculty} - ${user.academicYear}',
                    //   style: GoogleFonts.inter(
                    //       fontSize: 12,
                    //       color: Colors.grey.shade600
                    //   ),
                    // ),
                  ],
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
                offset:  Offset(-5, 30),
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
                        Icon(Icons.edit_outlined, color: Color(0xFF2563EB), size: 15),
                        SizedBox(width: 8),
                        Text(
                          'Edit',
                          style: GoogleFonts.inter(
                            color: Color(0xFF2563EB),
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
                        Icon(Icons.delete_outline, color: Colors.redAccent, size: 15),
                        SizedBox(width: 8),
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
                child: Icon(Icons.more_vert, size: 20, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
