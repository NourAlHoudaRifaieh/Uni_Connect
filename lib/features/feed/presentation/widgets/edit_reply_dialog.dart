import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/reply_model.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import 'package:uni_connect/core/widgets/custom_form_field.dart';
import 'package:uni_connect/features/auth/data/reply_repository.dart';

class EditReplyDialog extends StatefulWidget {
  final ReplyModel reply;
  final Function(String updateContent) onUpdateConfirmed;

  EditReplyDialog({
    super.key,
    required this.reply,
    required this.onUpdateConfirmed,
  });

  @override
  _EditReplyDialogState createState() {
    return _EditReplyDialogState();
  }
}

class _EditReplyDialogState extends State<EditReplyDialog> {
  TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _replyController = TextEditingController(text: widget.reply.content);
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async{
    final newText = _replyController.text.trim();
    if(newText.isEmpty || newText == widget.reply.content.trim()){
      Navigator.pop(context);
      widget.onUpdateConfirmed(newText);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titlePadding:  EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: EdgeInsets.fromLTRB(20, 16, 20, 20),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Edit Reply',
            style: GoogleFonts.inter(
              fontSize:18,
              fontWeight:FontWeight.bold,
              color:Color(0xFF1E293B),
            ),
          ),
          IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, size: 20, color: Colors.grey),
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormField(
                label:'Reply',
                hint: 'Enter your reply...',
                controller: _replyController,
              ),
              SizedBox(height:24),
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                        text: 'Cancel',
                        type: ButtonType.outlined,
                        backgroundColor: Colors.grey.shade700,
                        textColor: Colors.black87,
                        onPressed: (){
                          Navigator.pop(context);
                        }
                    ),
                  ),
                  SizedBox(width:12),
                  Expanded(
                    child: CustomElevatedButton(
                      text: 'Save',
                      backgroundColor: Color(0xFF2563EB),
                      onPressed: _handleSave,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}