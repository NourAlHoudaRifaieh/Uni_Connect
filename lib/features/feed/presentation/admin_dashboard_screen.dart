import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/data/auth_repository.dart';

class AdminDashboardScreen extends StatefulWidget {
  AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() {
    return _AdminDashboardScreenState();
  }
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(100),
        child: Column(
          children: [
            Text('welcome to admin dashboard'),
            GestureDetector(
              onTap: ()async{
                // onPressed: () async{
                await AuthRepository().logout();
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('remember_me');
                await prefs.remove('saved_email');
                if(context.mounted){
                  context.go('/login');
                }
                // },
              },
              // borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.blue,
                      size:16,
                    ),
                    SizedBox(width:6),
                    Text(
                      'Sign Out',
                      style: GoogleFonts.inter(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}