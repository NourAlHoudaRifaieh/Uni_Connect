import 'package:flutter/material.dart';
import 'nav_item.dart';

class CustomTopNavBar extends StatelessWidget{
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomTopNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height:70,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
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
            icon: Icons.bar_chart_outlined,
            activeIcon: Icons.bar_chart_rounded,
            label:'Dashboard',
            onTap: onTap,
          ),
          NavItem(
            index:1,
            currentIndex: currentIndex,
            icon: Icons.people_alt_outlined,
            activeIcon: Icons.people_alt_rounded,
            label: 'Groups',
            onTap: onTap,
          ),
          NavItem(
            index: 2,
            currentIndex: currentIndex,
            icon: Icons.menu_book_outlined,
            activeIcon: Icons.menu_book_rounded,
            label: 'Subjects',
            onTap: onTap,
          ),
          NavItem(
            index:3,
            currentIndex: currentIndex,
            icon: Icons.article_outlined,
            activeIcon: Icons.article_rounded,
            label: 'Posts',
            onTap: onTap,
          ),
          NavItem(
            index:4,
            currentIndex: currentIndex,
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: 'Users',
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}