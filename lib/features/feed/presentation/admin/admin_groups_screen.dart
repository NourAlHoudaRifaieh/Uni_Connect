import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/group_model.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import 'package:uni_connect/features/auth/data/group_repository.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/models/subject_model.dart';
import '../widgets/group_card.dart';
import 'create_group_screen.dart';

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

 void _deleteGroup(String? groupId) async{
   if(groupId == null) return;
   final confirm = await showDialog<bool>(
       context: context,
       builder: (context) => AlertDialog(
         title: Text('Delete Group'),
         content: Text('Are you sure you want to delete this group?'),
         actions:[
           TextButton(
               onPressed: (){
                 Navigator.pop(context, false);
               },
               child: Text('Cancel'),
           ),
           TextButton(
               onPressed: (){
                 Navigator.pop(context, true);
               },
               child: Text('Delete', style: GoogleFonts.inter(color: Colors.red)),
           ),
         ],
       ),
   );
   if(confirm == true){
     await _groupRepository.deleteGroup(groupId);
   }
 }


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
                      CustomElevatedButton(
                          text: 'Create New Group',
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
                            final groups = snapshot.data ?? [];
                            if(groups.isEmpty){
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(40),
                                  child: Text('No groups found.'),
                                ),
                              );
                            }
                            return Column(
                              children: groups.map((group){
                                return Padding(
                                  padding: EdgeInsets.all(16),
                                  child: GroupCard(
                                      group: group,
                                      academicYear: group.academicYear,
                                    onEditPressed: (){},
                                    onDeletePressed: (){
                                        _deleteGroup(group.groupId);
                                    },
                                  ),
                                );
                              }).toList(),
                            );
                          }
                      ),
                      // for (var group in MockData.groups) ...[
                      //   GroupCard(
                      //     group: group,
                      //     academicYear: group.academicYear,
                      //     subject: MockData.subjects.cast<SubjectModel?>().firstWhere(
                      //           (s) => s?.subjectId == group.subjectId,
                      //       orElse: () => null,
                      //     ),
                      //     onEditPressed: () {},
                      //     onDeletePressed: () {},
                      //   ),
                      //   SizedBox(height: 16),
                      // ],
                      // SizedBox(height: 20),
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