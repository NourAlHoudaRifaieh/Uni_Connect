import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/reply_model.dart';
import 'package:uni_connect/features/auth/data/reply_repository.dart';
import 'package:uni_connect/features/auth/data/user_repository.dart';
import 'package:uni_connect/features/feed/presentation/widgets/content_owner_menu.dart';
import 'package:uni_connect/features/feed/presentation/widgets/delete_reply_dialog.dart';
import 'package:uni_connect/features/feed/presentation/widgets/edit_reply_dialog.dart';

class CommentCard extends StatelessWidget {

  final ReplyModel reply;
  final VoidCallback? onReply;

  const CommentCard({
    super.key,
    required this.reply,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final me = UserRepository.cachedDocId;
    final isMine = reply.userId.isNotEmpty && (reply.userId == me || reply.userId == FirebaseAuth.instance.currentUser?.uid);
    // final authorName = reply.authorName.isNotEmpty ? reply.authorName : 'Anonymous';

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
              Row(
                children: [
                  Text(
                    reply.timeAgo,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  if (reply.isEdited)
                    Text(
                      ' (Edited)',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  if (isMine)
                    ContentOwnerMenu(
                        ownerId: reply.userId,
                        onEdit: (){
                          showDialog(
                              context: context,
                              builder: (context) => EditReplyDialog(
                                  reply: reply,
                                  onUpdateConfirmed: (newContent) async{
                                    await ReplyRepository().editReply(
                                        postId: reply.postId,
                                        replyId: reply.replyId,
                                        newContent: newContent,
                                    );
                                  },
                              ),
                          );
                        },
                        onDelete: (){
                          showDialog(
                              context: context,
                              builder: (context)=> DeleteReplyDialog(
                                  onDeleteConfirmed: () async{
                                    await ReplyRepository().deleteReply(
                                        postId: reply.postId,
                                        replyId: reply.replyId,
                                    );
                                  },
                              ),
                          );
                        }
                    ),
                    // PopupMenuButton<String>(
                    //   style: IconButton.styleFrom(
                    //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //     padding: EdgeInsets.zero,
                    //     minimumSize: Size.zero,
                    //   ),
                    //   color: Colors.white,
                    //   elevation: 5,
                    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    //   offset: const Offset(-5, 30),
                    //   onSelected: (v) {
                    //     if (v == 'edit') {
                    //       showDialog(
                    //           context: context,
                    //           builder: (context) => EditReplyDialog(
                    //               reply: reply,
                    //               onUpdateConfirmed: (newContent) async{
                    //                 await ReplyRepository().editReply(
                    //                     postId: reply.postId,
                    //                     replyId: reply.replyId,
                    //                     newContent: newContent
                    //                 );
                    //               }
                    //           ),
                    //       );
                    //     } else if(v == 'delete'){
                    //       showDialog(
                    //           context: context,
                    //           builder: (context) => DeleteReplyDialog(
                    //               onDeleteConfirmed: () async{
                    //                 await ReplyRepository().deleteReply(
                    //                     postId: reply.postId,
                    //                     replyId: reply.replyId
                    //                 );
                    //               }
                    //           ),
                    //       );
                    //     }
                    //   },
                    //   itemBuilder: (context) => [
                    //     PopupMenuItem<String>(
                    //       value: 'edit',
                    //       child: Row(children: [
                    //         const Icon(Icons.edit_outlined, color: Color(0xFF2563EB), size: 15),
                    //         const SizedBox(width: 8),
                    //         Text('Edit', style: GoogleFonts.inter(color: const Color(0xFF2563EB), fontSize: 15, fontWeight: FontWeight.w600)),
                    //       ]),
                    //     ),
                    //     PopupMenuItem<String>(
                    //       value: 'delete',
                    //       child: Row(children: [
                    //         const Icon(Icons.delete_outline, color: Colors.redAccent, size: 15),
                    //         const SizedBox(width: 8),
                    //         Text('Delete', style: GoogleFonts.inter(color: Colors.redAccent, fontSize: 15, fontWeight: FontWeight.w600)),
                    //       ]),
                    //     ),
                    //   ],
                    // ),
                ],
              ),
              // Text(
              //   reply.timeAgo,
              //   style: GoogleFonts.inter(
              //     fontSize: 11,
              //     color: Colors.grey.shade500,
              //   ),
              // ),
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