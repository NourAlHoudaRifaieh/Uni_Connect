import 'package:flutter/material.dart';
import 'nav_item.dart';

class CustomBottomNavBar extends StatelessWidget{
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCreatePost;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onCreatePost,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height:72,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFF1F5F9),
            width:1.5,
          ),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0,-4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavItem(
            index:0,
            currentIndex: currentIndex,
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label:'Home',
            onTap: onTap,
          ),
          NavItem(
            index:1,
            currentIndex: currentIndex,
            icon: Icons.menu_book_outlined,
            activeIcon: Icons.menu_book_rounded,
            label: 'Subjects',
            onTap: onTap,
          ),
          //Center Plus Button
          Transform.translate(
            offset: Offset(0, -5),
            child: GestureDetector(
              onTap: onCreatePost,
              child: Container(
                width:50,
                height:50,
                decoration: BoxDecoration(
                  color: Color(0xFF1D61FF),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF1D61FF).withOpacity(0.35),
                      blurRadius: 12,
                      offset: Offset(0,6),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Color(0xFF1D61FF),
                    foregroundColor: Colors.white,
                    elevation:5,
                    shadowColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  icon: Icon(Icons.add_rounded, size:25),
                  onPressed: onCreatePost,
                ),
              ),
            ),
          ),
          NavItem(
            index: 2,
            currentIndex: currentIndex,
            icon: Icons.search_rounded,
            activeIcon: Icons.search_rounded,
            label: 'Search',
            onTap: onTap,
          ),
          NavItem(
            index:3,
            currentIndex: currentIndex,
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: 'Profile',
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}