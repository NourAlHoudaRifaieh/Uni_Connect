import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import 'package:uni_connect/core/widgets/custom_form_field.dart';
import 'package:uni_connect/features/auth/data/auth_repository.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() {
    return _ForgotPasswordScreenState();
  }
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final AuthRepository _authRepository = AuthRepository();

  void _resetPassword() async{
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      try{
        await _authRepository.sendPasswordResentEmail(_emailController.text);
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password rest link sent! Check your email.')),
          );
          context.pop();
        }
      }catch(e){
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if(mounted){
          setState(() {
             _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:  IconButton(
            onPressed: (){
              context.pop();
            },
            icon: Icon(Icons.arrow_back_ios_new_outlined, color: Color(0xFF1E293B), size:20),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height:20),
              Text(
                'Reset Password',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height:8),
              Text(
                'Enter your university email address and we will send you a link to reset your password.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height:32),
              CustomFormField(
                  label: 'Email Address',
                  hint: 'name@st.ul.edu.lb',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.email_outlined),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return ' Please enter your email';
                    }
                    if(!value.contains('@')){
                      return 'Please enter a valid email';
                    }
                  },
              ),
              SizedBox(height:24),
              CustomElevatedButton(
                  text: 'Send Reset Link',
                  onPressed: _resetPassword,
                isLoading: _isLoading,
                  borderRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}