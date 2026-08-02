import 'package:flutter/material.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_form_field.dart';
import "package:google_fonts/google_fonts.dart";

class PersonalInfoStep extends StatelessWidget {

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
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Personal Information',
              style: GoogleFonts.inter(
                fontSize:16,
                fontWeight: FontWeight.bold,
              ),
              // style: TextStyle(
              //   fontSize:16,
              //   fontWeight:FontWeight.bold,
              // ),
            ),
            const SizedBox(height: 16),
            CustomFormField(
              label: 'Full Name',
              hint: 'e.g. Nour Al Houda Ghazi Rifaieh',
              color: Colors.white30,
              controller: fullNameController,
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Full name is required';
                }
                return null;
              },
            ),
            const SizedBox(height:18),
            CustomFormField(
              label:'University Email',
              hint: 'nour@ul.edu.lb',
              controller: emailController,
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
                return null;
              },
            ),
            const SizedBox(height:18),
            CustomFormField(
              label:'Password',
              hint: 'Min. 6 characters',
              controller: passwordController,
              obscureText: true,
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Password is required';
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
                    if(formKey.currentState?.validate() ?? false){
                      onContinue();
                    }
                  },
              ),
              // child: ElevatedButton(
              //   onPressed: onContinue,
              //   style:ElevatedButton.styleFrom(
              //     backgroundColor: const Color(0xFF2563EB),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     elevation:5,
              //     shadowColor:Colors.blue,
              //   ),
              //   child: const Text(
              //     'Continue',
              //     style: TextStyle(
              //       color:Colors.white,
              //       fontWeight: FontWeight.bold,
              //       fontSize:16,
              //     ),
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
