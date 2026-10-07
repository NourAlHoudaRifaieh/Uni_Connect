import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/group_model.dart';
import 'package:uni_connect/core/models/post_model.dart';
import 'package:uni_connect/core/models/user_model.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import 'package:uni_connect/features/auth/data/group_repository.dart';
import 'package:uni_connect/features/auth/data/post_repository.dart';
import 'package:uni_connect/features/auth/data/user_repository.dart';
import 'package:uni_connect/features/feed/presentation/admin/create_group_screen.dart';
import 'package:uni_connect/features/feed/presentation/widgets/academic_year_selector.dart';
import 'package:uni_connect/features/feed/presentation/widgets/delete_group_dialog.dart';
import 'package:uni_connect/features/feed/presentation/widgets/edit_group_dialog.dart';
import 'package:uni_connect/features/feed/presentation/widgets/group_card.dart';

class AdminGroupsScreen extends StatefulWidget {

  final bool isStandalone;
  AdminGroupsScreen({
    super.key,
    this.isStandalone = false,
  });

  @override
  _AdminGroupsScreenState createState() {
    return _AdminGroupsScreenState();
  }
}

class _AdminGroupsScreenState extends State<AdminGroupsScreen> {
 final GroupRepository _groupRepository = GroupRepository();
 String _selectedYear = 'Year 1';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      backgroundColor: widget.isStandalone
          ? Colors.white
          : Color(0xFF1D61FF).withOpacity(0.02),
      body: SafeArea(
        child: Column(
          children: [
            if (widget.isStandalone) ...[
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.chevron_left, color: Color(0xFF2563EB), size:20),
                          Text('Cancel', style: GoogleFonts.inter(color: Color(0xFF2563EB), fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    SizedBox(height:10),
                    Text('Manage Group',
                        style: GoogleFonts.inter(fontSize: 20, fontWeight:  FontWeight.bold)
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFF1F5F9),
                      width:1.5,
                    ),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset:Offset(0,8),
                    ),
                  ],
                ),
              ),
            ],
            Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AcademicYearSelector(
                          selectedYear: _selectedYear,
                          onYearSelected: (year){
                            setState(() {
                              _selectedYear = year;
                            });
                          }
                      ),
                      SizedBox(height:20),
                      CustomElevatedButton(
                          text: 'Create New Group $_selectedYear',
                          onPressed: () async{
                            //await the result from createGroupScree
                            final result = await
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CreateGroupScreen()),
                            );
                            //rebuild screen if a group was created
                            if(result == true && mounted){
                              setState(() {

                              });
                            }
                          }
                      ),
                      SizedBox(height:20),
                      StreamBuilder<List<GroupModel>>(
                          stream: _groupRepository.watchAllGroups(),
                          builder: (context, snapshot){
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if(snapshot.hasError){
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }
                            final allGroups = snapshot.data ?? [];
                            // only the groups of the selected year
                            final groups = allGroups.where((g) => g.academicYear == _selectedYear).toList()
                                ..sort((a, b) => a.displayName.compareTo(b.displayName));
                            if(groups.isEmpty){
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: Text('No groups for $_selectedYear yet',
                                    style: GoogleFonts.inter(
                                      color:Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              );
                            }
                            if(groups.isEmpty){
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(40),
                                  child: Text('No groups found.'),
                                ),
                              );
                            }

                            return  StreamBuilder<List<UserModel>>(
                                stream: UserRepository().watchAllUsers(),
                                builder: (context, userSnap){
                                  final users = userSnap.data ?? [];
                                  return StreamBuilder<List<PostModel>>(
                                      stream: PostRepository().watchAllPosts(),
                                      builder: (context, postSnap){
                                        final posts = postSnap.data ?? [];
                                        return Column(
                                          children: groups.map((rawGroup){
                                            final group = rawGroup.copyWith(
                                              membersCount: users.where((u) => u.role != 'admin' && u.groupId == rawGroup.groupId).length,
                                              postCount: posts.where((p) => p.groupId == rawGroup.groupId).length,
                                            );
                                            return Padding(
                                              padding: EdgeInsets.all(10),
                                              child: GroupCard(
                                                  group: group,
                                                  // showAdminBadge: true,
                                                  academicYear: group.academicYear,
                                                  onEditPressed: (){
                                                    showDialog(
                                                        context: context,
                                                        builder: (context){
                                                          return EditGroupDialog(
                                                              group: group,
                                                              onUpdateConfirmed: (updatedName, updatedYear) async{
                                                                if(group.groupId != null){
                                                                  GroupModel updatedGroup = group.copyWith(
                                                                    groupName: updatedName,
                                                                    academicYear: updatedYear,
                                                                  );
                                                                  await _groupRepository.updateGroup(updatedGroup);
                                                                  if(mounted){
                                                                    setState(() {
                                                                    });
                                                                  }
                                                                }
                                                              }
                                                          );
                                                        }
                                                    );
                                                  },
                                                  onDeletePressed: (){
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return DeleteGroupDialog(
                                                          group: group,
                                                          onDeleteConfirmed: () async{
                                                            final id = group.groupId;
                                                            if(id == null) return;
                                                            // the group still has subjects and students
                                                            final blocker = await _groupRepository.groupDeletionBlocker(group);
                                                            if(blocker != null){
                                                              if(mounted){
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(blocker),
                                                                    backgroundColor: Colors.red,
                                                                  ),
                                                                );
                                                              }
                                                              return ;
                                                            }
                                                            await _groupRepository.deleteGroup(id);
                                                            if(mounted){
                                                              setState(() {
                                                              });
                                                            }
                                                          },
                                                        );
                                                      },
                                                    );
                                                  }
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      }
                                  );
                                }
                            );
                          }
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