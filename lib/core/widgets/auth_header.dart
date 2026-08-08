import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final VoidCallback? onBack;
  final String? backLabel;
  final Widget? progressBar;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.onBack,
    this.backLabel,
    this.progressBar,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24,70,24,24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          //back button
          if (onBack !=null && backLabel != null) ...[
            GestureDetector(
              onTap: onBack,
              child: Row(
                children:[
                  const Icon(Icons.chevron_left, color: Colors.white, size:22),
                  Text(
                    backLabel!,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize:15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height:24),
          ],
          //Icon Container
          if(icon != null) ...[
            const SizedBox(height: 8),
            Container(
              width: 55,
              height:55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border:Border.all(
                  color: Colors.white,
                  width:2.0,
                ),
              ),
              child: Icon(icon, color: Colors.white, size:28),
            ),
          ],
          const SizedBox(height:40),
          //Title
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
                fontSize:30,
                fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height:6),
          //Subtitle
          Text(
            subtitle,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.85),
              fontSize:16,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (progressBar != null) ...[
            const SizedBox(height:16),
            progressBar!,
          ],
        ],
      ),
    );
  }
}
