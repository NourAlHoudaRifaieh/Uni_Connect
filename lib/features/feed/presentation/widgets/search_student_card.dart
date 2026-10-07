import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/group_model.dart';
import 'package:uni_connect/core/models/user_model.dart';
import 'package:uni_connect/features/auth/data/group_repository.dart';

class SearchStudentCard extends StatelessWidget {

  final UserModel user;
  final GroupRepository _groupRepository = GroupRepository();

  SearchStudentCard({
    super.key,
    required this.user,
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
              SizedBox(width:10),
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
                    SizedBox(height:2),
                    user.role == 'admin'
                      ? Text(
                          'Admin',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:Color(0xFF2563EB),
                          ),
                        )
                      : user.groupId != null && user.groupId!.isNotEmpty
                        ? FutureBuilder<GroupModel?>(
                            future: _groupRepository.getGroupById(user.groupId!),
                            builder: (context, snapshot){
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return Text(
                                  'Loading group...',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey.shade400,
                                    fontStyle:  FontStyle.italic,
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
                                if(group.groupName.isNotEmpty) group.displayName,
                              ].join(' - ');
                              return Text(
                                details.isNotEmpty ? details : 'No details provided',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              );
                            },
                          )
                        : Text(
                            'No group assigned',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontStyle: FontStyle.italic,
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
