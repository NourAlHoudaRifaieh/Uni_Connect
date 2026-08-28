import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardManageStatCard extends StatelessWidget {

  final IconData icon;
  final String title;
  final String subTitle;
  final VoidCallback? onTap;
  final bool isPrimary;

  DashboardManageStatCard({
    super.key,
    required this.title,
    required this.icon,
    required this.subTitle,
    this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          // color: Colors.white,
          color: isPrimary ? Color(0xFF2563EB) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          // border: Border.all(color: Colors.grey.shade200),
          border: isPrimary ? null : Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset:Offset(0,8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Icon(
                icon,
                size:25,
                // color: Color(0xFF1D61FF),
               color: isPrimary ? Colors.white : Color(0xFF2563EB),
             ),
            SizedBox(height:7),
            Text(
              title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                // color: Colors.black,
                color: isPrimary ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height:5),
            Text(
              subTitle,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                // color: Colors.grey.shade400,
                color: isPrimary ? Colors.white70 : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}