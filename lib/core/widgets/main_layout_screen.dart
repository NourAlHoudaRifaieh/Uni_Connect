import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_connect/core/widgets/custom_bottom_nav_bar.dart';
import 'package:uni_connect/features/auth/data/auth_repository.dart';
import 'package:uni_connect/features/feed/presentation/student/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/features/feed/presentation/student/profile_screen.dart';
import 'package:uni_connect/features/feed/presentation/student/search_screen.dart';
import 'package:uni_connect/features/feed/presentation/student/subject_screen.dart';

import '../../features/feed/presentation/student/create_post_screen.dart';

class MainLayoutScreen extends StatefulWidget{
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State <MainLayoutScreen>{
  // to track which tab is currently selected
  int _currentIndex =0;
  //the list of screens of each tab index
  late final List<Widget> _screens= [
    HomeScreen(),
    SubjectScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];
  void _handleCreatePost(){
    // context.push('/create-post');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePostScreen()),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          onCreatePost: _handleCreatePost,
      ),
    );
  }

}