import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';

import '../../../../core/models/subject_model.dart';

class DeleteSubjectDialog extends StatelessWidget {

  final SubjectModel subject;
  final VoidCallback onDeleteConfirmed;

  DeleteSubjectDialog({
    super.key,
    required this.subject,
    required this.onDeleteConfirmed,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(20),
      ),
      titlePadding: EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.close, size:20, color: Colors.grey),
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:  EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.red,
                  ),
                ),
                child: Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.redAccent,
                  size:22,
                ),
              ),
              SizedBox(height:10),
              Text(
                'Delete Subject?',
                style: GoogleFonts.inter(
                  fontSize:18,
                  fontWeight:FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height:10),
              Text(
                subject.subjectName ?? '',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight:FontWeight.w600,
                  color:Colors.black87,
                ),
              ),
              SizedBox(height:10),
              Text(
                'This will permanently remove the subject and all its associated data.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:Colors.grey.shade600,
                ),
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
                        text: 'Delete',
                        backgroundColor: Colors.redAccent,
                        onPressed: (){
                          Navigator.pop(context);
                          onDeleteConfirmed();
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
