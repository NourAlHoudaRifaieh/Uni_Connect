import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_connect/features/feed/presentation/admin/admin_groups_screen.dart';
import 'package:uni_connect/features/feed/presentation/admin/admin_posts_screen.dart';
import 'package:uni_connect/features/feed/presentation/admin/admin_subjects_screen.dart';
import 'package:uni_connect/features/feed/presentation/admin/admin_users_screen.dart';
import 'package:uni_connect/features/feed/presentation/student/create_post_screen.dart';
import 'package:uni_connect/features/feed/presentation/widgets/dashboard_manage_stat_card.dart';
import 'package:uni_connect/features/feed/presentation/widgets/dashboard_stat_card.dart';

import '../../../../core/widgets/auth_header.dart';
import '../../../auth/data/auth_repository.dart';

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
      backgroundColor: Color(0xFF1D61FF).withOpacity(0.02),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.20,
                children: [
                  DashboardStatCard(
                    icon: Icons.people_alt_outlined,
                    title: '1,284',
                    subTitle: 'Total Students',
                    // isPrimary:  true,
                  ),
                  DashboardStatCard(
                    icon: Icons.menu_book_outlined,
                    title: '38',
                    subTitle: 'Total Subjects',
                  ),
                  DashboardStatCard(
                    icon: Icons.article_outlined,
                    title: '3,421',
                    subTitle: 'Total Posts',
                  ),
                  DashboardStatCard(
                    icon: Icons.groups_outlined,
                    title: '15',
                    subTitle: 'Active Groups',
                  ),
                ],
              ),
              SizedBox(height:15),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.60,
                children: [
                  // DashboardManageStatCard(
                  //   icon: Icons.person_2_outlined,
                  //   title: 'Manage Users',
                  //   subTitle: '1,284 students',
                  //   // onTap: (){
                  //   //   Navigator.push(
                  //   //       context,
                  //   //       MaterialPageRoute(builder: (context)=> AdminUsersScreen()),
                  //   //   );
                  //   // },
                  // ),
                  DashboardManageStatCard(
                    icon: Icons.people_alt_outlined,
                    title: 'Manage Groups',
                    subTitle: '15 academic groups',
                    isPrimary: true,
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminGroupsScreen(isStandalone: true)),
                      );
                    },
                    // onTap: (){
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context)=> AdminGroupsScreen()),
                    //   );
                    // },
                  ),
                  DashboardManageStatCard(
                    icon: Icons.menu_book_outlined,
                    title: 'Manage Subjects',
                    subTitle: '35 subjects',
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> AdminSubjectsScreen(isStandalone: true)),
                      );
                    },
                  ),
                  DashboardManageStatCard(
                    icon: Icons.article_outlined,
                    title: 'Manage Posts',
                    subTitle: '3,421 posts',
                    // onTap: (){
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context)=> AdminPostsScreen()),
                    //   );
                    // },
                  ),
                  DashboardManageStatCard(
                    icon: Icons.add_outlined,
                    title: 'Create Post',
                    subTitle: 'AI categorization',
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> CreatePostScreen()),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height:15),
              Text(
                'Recent Activity',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height:15),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color:Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset:Offset(0,8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1D61FF),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width:7),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New student registered Ziad Gemayed (Year 1)',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF333333),
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '2 min ago',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1D61FF),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width:7),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Subject added: Digital Marketing (Year 3)',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF333333),
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '3 min ago',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1D61FF),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width:7),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Group "BA-Year2" reached 200 members',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF333333),
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '15 min ago',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}