import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardStatCard extends StatelessWidget {

  final IconData icon;
  final String title;
  final String subTitle;

  DashboardStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
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
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF1D61FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size:20,
              color: Color(0xFF1D61FF),
            ),
          ),
          SizedBox(height:7),
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.black,
            ),
          ),
          SizedBox(height:5),
          Text(
            subTitle,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
