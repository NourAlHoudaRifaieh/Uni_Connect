import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/models/user_model.dart';

class AdminSearchStudentCard extends StatelessWidget {

  final UserModel user;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

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
      margin: const EdgeInsets.only(bottom: 14),
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
              const SizedBox(width:10),
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
                    Text(
                      '${user.faculty} - ${user.academicYear}',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600
                      ),
                    ),
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
              // Column(
              //   crossAxisAlignment:  CrossAxisAlignment.end,
              //   children: [
              //     Container(
              //       height:28,
              //       decoration: BoxDecoration(
              //         border: Border.all(
              //           color: Color(0xFF1D61FF),
              //         ),
              //         borderRadius: BorderRadius.circular(20),
              //         color: Color(0xFF1D61FF).withOpacity(0.03),
              //       ),
              //       child: TextButton(
              //         onPressed: (){
              //
              //         },
              //         child: Text(
              //           'Edit',
              //           style:GoogleFonts.inter(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 12,
              //             color: Color(0xFF1D61FF),
              //           ),
              //         ),
              //       ),
              //     ),
              //     SizedBox(height:5),
              //     Container(
              //       padding: EdgeInsets.zero,
              //       height:28,
              //       decoration: BoxDecoration(
              //         border: Border.all(
              //           color: Colors.red,
              //         ),
              //         borderRadius: BorderRadius.circular(20),
              //         color: Colors.red.withOpacity(0.03),
              //       ),
              //       child: TextButton(
              //         onPressed: (){
              //
              //         },
              //         child: Text(
              //           'Remove',
              //           style:GoogleFonts.inter(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 12,
              //             color: Colors.red,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
