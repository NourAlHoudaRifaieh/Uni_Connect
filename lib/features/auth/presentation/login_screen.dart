import 'package:flutter/material.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/custom_form_field.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_connect/core/widgets/auth_header.dart';
import 'package:uni_connect/features/auth/data/auth_repository.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool isChecked = false;

  final _authRepository = AuthRepository();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

      setState(() {
        _isLoading= true;
      });

      final error = await _authRepository.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if(!mounted) return;
      setState(() {
        _isLoading= false;
      });

      if(error != null){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red
          ),
        );
      }else{
        context.go('/home');// the placeholder route, I'll build the home next
      }
    // //firebase Auth logic goes here
    // print('Email: ${_emailController.text}');
    // print('Password: ${_passwordController.text}');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // padding: const EdgeInsets.symmetric(horizontal: 24),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               AuthHeader(
                icon: Icons.school,
                title: 'Welcome back!',
                subtitle: 'Sign in to your LU account',
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //CustomFormField for Email
                      CustomFormField(
                        label: 'University Email',
                        hint: 'name@ul.edu.lb',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if( value == null || value.isEmpty){
                            return 'Email is required';
                          }
                          final email = value.toLowerCase();
                          final isStudent = email.endsWith('@st.ul.edu.lb');
                          final isAdmin = email.endsWith('@admin.ul.edu.lb');
                          if (!isStudent && !isAdmin) {
                            return 'Use your university email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height:18),
                      //CustomFormField for password
                      CustomFormField(
                        label: 'Password',
                        hint: 'Enter your password',
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty){
                            return 'Password is required';
                          }
                          if(value.length <6){
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height:38),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Remember Me
                          Row(
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: isChecked,
                                  activeColor: const Color(0xFF2563EB),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      isChecked = value ?? false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Remember Me",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2F3A4A),
                                ),
                              ),
                            ],
                          ),
                          //Forgot Password
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Color(0xFF2563EB),
                            ).copyWith(
                              overlayColor: WidgetStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () {
                              //to handle the forgot password later
                            },
                            child: Text('Forgot password?',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:8),
                      //Login Button
                      SizedBox(
                        height:50,
                        child: CustomElevatedButton(
                            text: 'Sign In',
                            onPressed: _handleLogin,
                            isLoading: _isLoading,
                        ),
                        // child:ElevatedButton(
                        //   onPressed: _isLoading ? null : _handleLogin,
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: const Color(0xFF2563EB),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(20),
                        //     ),
                        //     elevation: 5,
                        //     shadowColor: Colors.blue,
                        //   ),
                        //   child: _isLoading
                        //       ? const CircularProgressIndicator(color: Colors.white)
                        //       : const Text(
                        //     'Sign In',
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize:16,
                        //     ) ,
                        //   ),
                        // ),
                      ),
                      const SizedBox(height:16),
                      //Register link
                      Row(
                        mainAxisAlignment : MainAxisAlignment.center,
                        children :[
                          Text(" Don't have an account?",
                            style: GoogleFonts.inter(
                              fontSize:16,
                              color: Color(0xFF2F3A4A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //navigate to register screen next
                              context.go('/register');
                            },
                            child: Text(
                              ' Register',
                              style: GoogleFonts.inter(
                                color: Color(0xFF2563EB),
                                fontSize:16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}