import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_connect/core/widgets/custom_bottom_nav_bar.dart';
import 'package:uni_connect/features/auth/data/auth_repository.dart';
import 'package:uni_connect/features/feed/presentation/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/features/feed/presentation/profile_screen.dart';
import 'package:uni_connect/features/feed/presentation/search_screen.dart';
import 'package:uni_connect/features/feed/presentation/subject_screen.dart';

import '../../features/feed/presentation/create_post_screen.dart';

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
    // Center(
    //   child: Text('Subjects Screen',
    //     style: GoogleFonts.inter(
    //       fontSize:20,
    //     ),
    //   ),
    // ),
    SearchScreen(),
    // Center(
    //   child: Text('Search Screen',
    //     style: GoogleFonts.inter(
    //       fontSize:20,
    //     ),
    //   ),
    // ),

    ProfileScreen(),

    // Center(
    //   child: ElevatedButton(
    //       onPressed: () async{
    //         await AuthRepository().logout();
    //         final prefs = await SharedPreferences.getInstance();
    //         await prefs.remove('remember_me');
    //         await prefs.remove('saved_email');
    //         if(context.mounted){
    //           context.go('/login');
    //         }
    //       },
    //       child: Text('Logout(test button)'),
    //   ),
    // ),

    // Center(
    //   child: Text('Profile Screen',
    //     style: GoogleFonts.inter(
    //       fontSize:20,
    //     ),
    //   ),
    // ),
  ];
  //action when pressing the add button
  // void _handleCreatePost(){
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(
  //           top: Radius.circular(20),
  //         ),
  //       ),
  //       builder: (context) =>
  //         Container(
  //           padding: EdgeInsets.all(20),
  //           height: 250,
  //           child: Center(
  //             child: Text('Create Post Sheet'),
  //           ),
  //         ),
  //   );
  // }

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