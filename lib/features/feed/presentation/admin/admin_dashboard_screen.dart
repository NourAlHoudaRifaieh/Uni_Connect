import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/post_model.dart';
import 'package:uni_connect/core/models/subject_model.dart';
import 'package:uni_connect/core/models/user_model.dart';
import 'package:uni_connect/features/auth/data/group_repository.dart';
import 'package:uni_connect/features/auth/data/post_repository.dart';
import 'package:uni_connect/features/auth/data/subject_repository.dart';
import 'package:uni_connect/features/auth/data/user_repository.dart';
import 'package:uni_connect/features/feed/presentation/admin/admin_groups_screen.dart';
import 'package:uni_connect/features/feed/presentation/admin/admin_posts_screen.dart';
import 'package:uni_connect/features/feed/presentation/admin/admin_subjects_screen.dart';
import 'package:uni_connect/features/feed/presentation/student/create_post_screen.dart';
import 'package:uni_connect/features/feed/presentation/widgets/dashboard_manage_stat_card.dart';
import 'package:uni_connect/features/feed/presentation/widgets/dashboard_stat_card.dart';

import '../../../../core/models/group_model.dart';

class AdminDashboardScreen extends StatefulWidget {
  AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() {
    return _AdminDashboardScreenState();
  }
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final UserRepository _userRepository = UserRepository();
  final SubjectRepository _subjectRepository = SubjectRepository();
  final PostRepository _postRepository = PostRepository();
  final GroupRepository _groupRepository = GroupRepository();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFF1D61FF).withOpacity(0.02),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Top Stats Cards
              StreamBuilder<List<UserModel>>(
                  stream: _userRepository.watchAllUsers(),
                  builder: (context, userSnap){
                    final userCount = userSnap.data?.length ?? 0;
                    return StreamBuilder<List<SubjectModel>>(
                      stream: _subjectRepository.watchAllSubjects(),
                      builder: (context, subjectSnap){
                        final subjectCount = subjectSnap.data?.length ?? 0;
                        return StreamBuilder<List<PostModel>>(
                            stream: _postRepository.watchAllPosts(),
                            builder: (context, postSnap){
                              final postCount = postSnap.data?.length ?? 0;
                              return StreamBuilder<List<GroupModel>>(
                                  stream: _groupRepository.watchAllGroups(),
                                  builder: (context, groupSnap){
                                    final groupCount = groupSnap.data?.length ?? 0;
                                    return GridView.count(
                                      crossAxisCount: 2,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15,
                                      childAspectRatio: 1.20,
                                      children: [
                                        DashboardStatCard(
                                          icon: Icons.people_alt_outlined,
                                          title: '$userCount',
                                          subTitle: 'Total Students',
                                          // isPrimary:  true,
                                        ),
                                        DashboardStatCard(
                                          icon: Icons.menu_book_outlined,
                                          title: '$subjectCount',
                                          subTitle: 'Total Subjects',
                                        ),
                                        DashboardStatCard(
                                          icon: Icons.article_outlined,
                                          title: '$postCount',
                                          subTitle: 'Total Posts',
                                        ),
                                        DashboardStatCard(
                                          icon: Icons.groups_outlined,
                                          title: '$groupCount',
                                          subTitle: 'Active Groups',
                                        ),
                                      ],
                                    );
                                  }
                              );
                            }
                        );
                      },
                    );
                  }
              ),
              SizedBox(height:15),
              StreamBuilder<List<GroupModel>>(
                  stream: _groupRepository.watchAllGroups(),
                  builder: (context, groupSnap){
                    final groupsCount = groupSnap.data?.length ?? 0;
                    return StreamBuilder<List<SubjectModel>>(
                        stream: _subjectRepository.watchAllSubjects(),
                        builder: (context, subjectSnap){
                          final subjectsCount = subjectSnap.data?.length ?? 0;
                          return StreamBuilder<List<PostModel>>(
                              stream: _postRepository.watchAllPosts(),
                              builder: (context, postSnap){
                                final postsCount = postSnap.data?.length ?? 0;
                                return  GridView.count(
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
                                      subTitle: '$groupsCount academic groups',
                                      isPrimary: true,
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => AdminGroupsScreen(isStandalone: true)),
                                        );
                                        if(mounted){
                                          setState(() {

                                          });
                                        }
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
                                      subTitle: '$subjectsCount subjects',
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context)=> AdminSubjectsScreen(isStandalone: true)),
                                        );
                                        if(mounted){
                                          setState(() {

                                          });
                                        }
                                      },
                                    ),
                                    DashboardManageStatCard(
                                      icon: Icons.article_outlined,
                                      title: 'Manage Posts',
                                      subTitle: '$postsCount posts',
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context)=> AdminPostsScreen(isStandalone: true,)),
                                        );
                                        if(mounted){
                                          setState(() {

                                          });
                                        }
                                      },
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
                                        if(mounted){
                                          setState(() {

                                          });
                                        }
                                      },
                                    ),
                                  ],
                                );
                              }
                          );
                        }
                    );
                  }
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
              // Recent Activity Container
              StreamBuilder<List<PostModel>>(
                stream: _postRepository.watchAllPosts(),
                builder: (context, snapshot){
                  final recentPosts = (snapshot.data ?? []).take(3).toList();
                  if(recentPosts.isEmpty){
                    return Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Center(
                        child: Text('No recent activity recorded yet.'),
                      ),
                    );
                  }
                  return Container(
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
                      children:List.generate(recentPosts.length, (index) {
                        final post = recentPosts[index];
                        final isLast = index == recentPosts.length -1;

                        return Column(
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
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'New Post: ${post.title}',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF333333),
                                            height: 1.3,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '3 min ago',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: Color(0xFF94A3B8),
                                          ),
                                        ),
                                      ],
                                    ),
                                ),
                                if(!isLast) const Divider(),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}