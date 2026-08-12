import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/auth_repository.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  final _authRepository = AuthRepository();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2300)).then((_){
        // context.go('/login');
      _decideWhereToGo();
    });
    super.initState();
  }

  void _decideWhereToGo() async {
    final shouldGoHome = await _authRepository.shouldAutoLogin();

    if (!mounted) return; // add this safety check

    if (shouldGoHome) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   width:90,
              //   height: 90,
              //   decoration: BoxDecoration(
              //     color: Colors.white38,
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: Icon(Icons.school, color: Colors.white, size:40),
              // ),
              // SizedBox(height:20),
              Text(
                'UniConnect',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height:10),
              Text(
                'Empowering students to connect, collaborate, and grow together!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 20,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height:10),
              Lottie.asset('assets/images/splash_animation_graduation.json', width: 240, height: 240),
              // Lottie.asset('assets/images/splash_animation_loading.json', width:100, height:100)
              // Lottie.asset('assets/images/splash_animation_education.json')
            ],
          ),
        ),
      ),
    );
  }
}