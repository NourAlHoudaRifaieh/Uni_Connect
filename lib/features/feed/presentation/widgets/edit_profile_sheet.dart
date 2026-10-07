import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/user_model.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import 'package:uni_connect/core/widgets/custom_form_field.dart';
import 'package:uni_connect/features/auth/data/user_repository.dart';

Future<void> showEditProfileSheet(BuildContext context, UserModel user){
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return EditProfileSheet(user: user);
      }
  );
}

class EditProfileSheet extends StatefulWidget {
  final UserModel user;

  EditProfileSheet({
    super.key,
    required this.user,
  });

  @override
  _EditProfileSheetState createState() {
    return _EditProfileSheetState();
  }
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late final TextEditingController _nameController ;
  late final TextEditingController _emailController ;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async{
    if(!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
    });
    try{
      final newName = _nameController.text.trim();
      await UserRepository().updateUserProfile(widget.user.copyWith(fullName: newName));
      //keep the author name of the existing posts consistent
      final posts = await FirebaseFirestore.instance
        .collection('posts')
        .where('userid', isEqualTo: widget.user.userId)
        .get();
      final batch = FirebaseFirestore.instance.batch();
      for (final d in posts.docs){
        batch.update(d.reference, {'authorName': newName});
      }
      await batch.commit();
      if(!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated'), backgroundColor: Colors.green,),
      );
    }catch(e){
      if(!mounted){
        setState(() {
          _saving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not update profile: $e'), backgroundColor: Colors.red,),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Profile',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close, size:20, color:Colors.grey),
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                  ),
                ],
              ),
              SizedBox(height:20),
              CustomFormField(
                label: 'Full name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                validator: (v){
                  return (v == null || v.trim().length < 2) ? 'Please enter your name' : null;
                },
              ),
              SizedBox(height:16),
              CustomFormField(
                label: 'Email',
                  hint: 'Email address',
                  controller: _emailController,
              ),
              SizedBox(height: 24),
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
                        text: _saving ? 'Saving...' : 'Save',
                        backgroundColor: Color(0xFF2563EB),
                        onPressed: _saving ? null : _save,
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
