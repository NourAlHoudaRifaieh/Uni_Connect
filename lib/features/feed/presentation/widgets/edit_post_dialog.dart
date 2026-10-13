import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_form_field.dart';

class EditPostDialog extends StatefulWidget {
  final String initialDescription;
  final Function(String updatedDescription) onUpdateConfirmed;

  EditPostDialog({
    super.key,
    required this.initialDescription,
    required this.onUpdateConfirmed,
  });

  @override
  _EditPostDialogState createState() {
    return _EditPostDialogState();
  }
}

class _EditPostDialogState extends State<EditPostDialog> {
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
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
            'Edit Post',
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
                label:'Description',
                hint: 'Enter post description',
                controller: _descriptionController,
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
                        onPressed: (){
                          Navigator.pop(context);
                          widget.onUpdateConfirmed(
                            _descriptionController.text.trim(),
                          );
                        }
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