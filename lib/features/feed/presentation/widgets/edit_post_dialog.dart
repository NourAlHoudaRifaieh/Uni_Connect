import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/services/ai_category_service.dart';

import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_form_field.dart';

class EditPostDialog extends StatefulWidget {
  final String initialDescription;
  final Function(String updatedDescription, String updatedCategory) onUpdateConfirmed;

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
  final AiCategoryService _aiCategoryService = AiCategoryService();
  bool _isAnalyzing = false;

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

  Future<void> _handleSave() async{
    final newText = _descriptionController.text.trim();
    if(newText.isEmpty) return;
    setState(() {
      _isAnalyzing = true;
    });

    try{
      final aiResult = await _aiCategoryService.categorizeDetailed(newText);
      if(!mounted) return;
      Navigator.pop(context);
      widget.onUpdateConfirmed(newText, aiResult.category);
    }catch(e){
      if(!mounted) return;
      setState(() {
        _isAnalyzing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to analyze with AI: $e')),
      );
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
              SizedBox(height:16),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFF2563EB).withValues(alpha: 0.13)
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Color(0xFF2563EB), size: 16),
                    SizedBox(width:8),
                    Expanded(
                      child: Text(
                        'AI will re-categorize your post automatically upon saving.',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
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
                        text: 'Save',
                        backgroundColor: Color(0xFF2563EB),
                        onPressed: _handleSave,
                        // onPressed: (){
                        //   Navigator.pop(context);
                        //   widget.onUpdateConfirmed(
                        //     _descriptionController.text.trim(),
                        //   );
                        // }
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