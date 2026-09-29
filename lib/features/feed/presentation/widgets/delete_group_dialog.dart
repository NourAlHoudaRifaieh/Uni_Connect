import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/models/group_model.dart';
import '../../../../core/widgets/custom_elevated_button.dart';

class DeleteGroupDialog extends StatelessWidget {

  final GroupModel group;
  final VoidCallback onDeleteConfirmed;

  DeleteGroupDialog({
    super.key,
    required this.onDeleteConfirmed,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(20),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close, size:20, color: Colors.grey),
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
              // SizedBox(height:5),
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
              SizedBox(height:15),
              Text(
                'Delete Group?',
                style: GoogleFonts.inter(
                  fontSize:18,
                  fontWeight:FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height:10),
              Text(
                group.groupName ?? '',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight:FontWeight.w600,
                  color:Colors.black87,
                ),
              ),
              SizedBox(height:10),
              Text(
                'This will permanently remove the group and all its associated data.',
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
