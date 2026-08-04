import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_connect/core/widgets/main_layout_screen.dart';
// import 'package:uni_connect/features/feed/presentation/home_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation//register_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => MainLayoutScreen(),
        // builder: (context, state) => HomeScreen(),

        // builder: (context, state) => const Scaffold(
        //   body: Center(
        //     child: Text('Home Screen coming soon')
        //   ),
        // ),
      ),
    ],
);