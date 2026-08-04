import 'package:flutter/material.dart';
import 'package:uni_connect/core/widgets/custom_bottom_nav_bar.dart';
import 'package:uni_connect/features/feed/presentation/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
    Center(
      child: Text('Subjects Screen',
        style: GoogleFonts.inter(
          fontSize:20,
        ),
      ),
    ),
    Center(
      child: Text('Search Screen',
        style: GoogleFonts.inter(
          fontSize:20,
        ),
      ),
    ),
    Center(
      child: Text('Profile Screen',
        style: GoogleFonts.inter(
          fontSize:20,
        ),
      ),
    ),
  ];
  //action when pressing the add button
  void _handleCreatePost(){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (context) =>
          Container(
            padding: EdgeInsets.all(20),
            height: 250,
            child: Center(
              child: Text('Create Post Sheet'),
            ),
          ),
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