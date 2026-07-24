import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  // AuthHeader({Key? key}) : super(key: key);
  final String title;
  final String subtitle;
  final IconData? icon;
  final VoidCallback? onBack;
  final String? backLabel;
  final Widget? progressBar;

  AuthHeader({
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
      padding: const EdgeInsets.fromLTRB(24,16,24,24),
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
          if (onBack !=null && backLabel != null)
            GestureDetector(
              onTap: onBack,
              child: Row(
                children:[
                  const Icon(Icons.chevron_left, color: Colors.white, size:20),
                  Text(
                    backLabel!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:14,
                    ),
                  ),
                ],
              ),
            ),
          if(icon != null) ...[
            const SizedBox(height: 8),
            Container(
              width: 55,
              height:55,
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border:Border.all(
                  color: Colors.white,
                  width:2.0,
                ),
              ),
              child: Icon(icon, color: Colors.white, size:28),
            ),
          ],
          const SizedBox(height:16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize:28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height:4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white70,
              fontSize:16,
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
