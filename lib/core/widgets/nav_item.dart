import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavItem extends StatelessWidget{
  final int index;
  final int currentIndex;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final ValueChanged<int> onTap;

  const NavItem({
    super.key,
    required this.onTap,
    required this.icon,
    required this.index,
    required this.activeIcon,
    required this.currentIndex,
    required this.label,
  });

  @override
  Widget build(BuildContext context){
    final bool isSelected = currentIndex == index;
    final color = isSelected ? Color(0xFF1D61FF) : Color(0xFF94A3B8);

    return InkWell(
      onTap: () => onTap(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon :icon,
            color: color,
            size:22,
          ),
          SizedBox(height:1),
          Text(
            label,
            style: GoogleFonts.inter(
              color: color,
              fontSize:11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}