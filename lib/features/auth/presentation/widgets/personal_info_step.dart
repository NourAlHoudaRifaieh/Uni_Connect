import 'package:flutter/material.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import 'package:uni_connect/core/widgets/custom_form_field.dart';
import "package:google_fonts/google_fonts.dart";

class PersonalInfoStep extends StatefulWidget {

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onContinue;


  const PersonalInfoStep({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.fullNameController,
    required this.onContinue,
    required this.passwordController,
  });

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Personal Information',
              style: GoogleFonts.inter(
                fontSize:16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            CustomFormField(
              label: 'Full Name',
              hint: 'Enter your full name',
              color: Colors.white30,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: widget.fullNameController,
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Full name is required';
                }
                if(RegExp(r'[0-9]').hasMatch(value)){
                  return 'Full name cannot contain numbers';
                }
                return null;
              },
            ),
            const SizedBox(height:18),
            CustomFormField(
              label:'University Email',
              hint: 'Enter your university email',
              controller: widget.emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Email is required';
                }
                final email = value.toLowerCase();
                final isStudent = email.endsWith('@st.ul.edu.lb');
                final isAdmin = email.endsWith('@admin.ul.edu.lb');
                if(!isStudent && !isAdmin){
                  return 'Use your university email';
                }
                // final usernamePart = email.split('@')[0];
                // if (RegExp(r'[0-9]').hasMatch(usernamePart)) {
                //   return 'Email username cannot contain numbers';
                // }
                return null;
              },
            ),
            SizedBox(height:10),
            Text(
              'Must end with @st.ul.edu.lb (Students) or @admin.ul.edu.lb (Admins)',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height:18),
            CustomFormField(
              label:'Password',
              hint: 'Min. 8 characters',
              controller: widget.passwordController,
              obscureText: _obscureText,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              suffixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Password is required';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                if (!value.contains(RegExp(r'[A-Z]'))) {
                  return 'Must contain at least one uppercase letter';
                }
                if (!value.contains(RegExp(r'[0-9]'))) {
                  return 'Must contain at least one number';
                }
                if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                  return 'Must contain at least one special character';
                }
                return null;
              },
            ),
            const SizedBox(height:24),
            SizedBox(
              height:50,
              child: CustomElevatedButton(
                  text: 'Continue',
                  onPressed: (){
                    if(widget.formKey.currentState?.validate() ?? false){
                      widget.onContinue();
                    }
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
