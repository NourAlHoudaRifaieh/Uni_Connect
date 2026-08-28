import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_connect/core/widgets/custom_top_nav_bar.dart';
import 'package:uni_connect/features/feed/presentation/admin/admin_dashboard_screen.dart';
import 'package:uni_connect/features/feed/presentation/admin/admin_groups_screen.dart';
import 'package:uni_connect/features/feed/presentation/admin/admin_posts_screen.dart';
import 'package:uni_connect/features/feed/presentation/admin/admin_subjects_screen.dart';
import 'package:uni_connect/features/feed/presentation/admin/admin_users_screen.dart';

import '../../features/auth/data/auth_repository.dart';

class AdminLayoutScreen extends StatefulWidget{
  const AdminLayoutScreen({super.key});

  @override
  State<AdminLayoutScreen> createState() => _AdminLayoutScreenState();
}

class _AdminLayoutScreenState extends State <AdminLayoutScreen>{
  int _currentIndex =0;
  late final List<Widget> _screens= [
    AdminDashboardScreen(),
    AdminGroupsScreen(),
    AdminPostsScreen(),
    AdminSubjectsScreen(),
    AdminUsersScreen(),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20,50,20,20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment : CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dashboard',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize:25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height:5),
                            Text(
                              'Lebanese University - Admin',
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.7),
                                fontSize:15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: ()async{
                            await AuthRepository().logout();
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove('remember_me');
                            await prefs.remove('saved_email');
                            if(context.mounted){
                              context.go('/login');
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size:16,
                                ),
                                SizedBox(width:6),
                                Text(
                                  'Sign Out',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
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
                  ],
                ),
              ),
              CustomTopNavBar(
                  currentIndex: _currentIndex,
                  onTap: (index){
                    setState(() {
                      _currentIndex = index;
                    });
                  },
              ),
              Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _screens,
                  ),
              ),
            ],
          ),
      ),
    );
  }

}