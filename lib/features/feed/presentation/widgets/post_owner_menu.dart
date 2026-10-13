import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/features/auth/data/post_repository.dart';
import 'package:uni_connect/features/auth/data/user_repository.dart';
import 'package:uni_connect/core/models/post_model.dart';
import 'package:uni_connect/features/feed/presentation/widgets/delete_post_dialog.dart';
import 'package:uni_connect/features/feed/presentation/widgets/edit_post_dialog.dart';

class PostOwnerMenu extends StatelessWidget {
  
  final PostModel post;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  
  PostOwnerMenu({
    super.key,
    required this.post,
    this.onDelete,
    this.onEdit,
  });

  Future<void> onEditPressed(BuildContext context) async{
    if(onEdit != null){
      onEdit!();
      return;
    }
    showDialog(
        context: context,
        builder: (context) =>
            EditPostDialog(
              initialDescription: post.description,
              onUpdateConfirmed: (newText) async{
                if(newText.trim().isEmpty || post.postId == null) return;
                if(newText.trim() == post.description.trim()) return;
                await PostRepository().updatePost(post.postId!, description: newText);
              },
            ),
    );
  }

  Future<void> onDeletePressed(BuildContext context) async{
    if(onDelete != null){
      onDelete!();
      return;
    }
    showDialog(
      context:context,
      builder: (context) => DeletePostDialog(
        onDeleteConfirmed :() async{
          if(post.postId == null) return;
          await PostRepository().deletePost(
            post.postId!,
            subjectId: post.userId,
            groupId: post.groupId,
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<String>(
      future: UserRepository().currentDocId(),
      initialData: UserRepository.cachedDocId,
      builder: (context, snap){
        final me = snap.data;
        final isOwner = me != null && me.isNotEmpty && post.userId == me;
        if(!isOwner) return SizedBox.shrink();

        return PopupMenuButton<String>(
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
          offset: Offset(-5, 30),
          onSelected: (value) {
            if (value == 'edit') {
              onEditPressed(context);
            } else if (value == 'delete') {
              onDeletePressed(context);
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
        );
      },
    );
  }
}
