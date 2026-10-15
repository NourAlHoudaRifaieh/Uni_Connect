import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestStatusChip extends StatelessWidget {
  final String status;
  RequestStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final map = {
      'pending': ['Pending', Colors.orange],
      'accepted': ['Accepted', Colors.green],
      'rejected': ['Rejected', Colors.red],
    };

    final v = map[status] ?? ['Pending', Colors.orange];
    final color = v[1] as Color;
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        v[0] as String,
        style: GoogleFonts.inter(
          fontSize:12,
          fontWeight:FontWeight.bold,
          color:color,
        ),
      ),
    );
  }
}
