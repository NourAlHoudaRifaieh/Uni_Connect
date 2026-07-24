import 'package:flutter/material.dart';
import '../../../core/widgets/custom_form_field.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_connect/core/widgets/auth_header.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _isLoading = false;


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

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    //firebase Auth logic goes here
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        label: 'Email',
                        hint: 'name@ul.edu.lb',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if( value == null || value.isEmpty){
                            return 'Email is required';
                          }
                          if(!value.contains('@')){
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height:18),
                      //CustomFormField for password
                      CustomFormField(
                        label: 'password',
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
                      const SizedBox(height:8),
                      //Forgot Password
                      Align(
                        alignment:Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            //to handle the forgot password later
                          },
                          child: const Text('Forgot password?'),
                        ),
                      ),
                      SizedBox(height:8),
                      //Login Button
                      SizedBox(
                        height:50,
                        child:ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:16,
                            ) ,
                          ),
                        ),
                      ),
                      const SizedBox(height:16),
                      //Register link
                      Row(
                        mainAxisAlignment : MainAxisAlignment.center,
                        children :[
                          const Text(" Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              //navigate to register screen next
                              context.go('/register');
                            },
                            child: const Text(
                              ' Register',
                              style: TextStyle(
                                color: Color(0xFF2563EB),
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