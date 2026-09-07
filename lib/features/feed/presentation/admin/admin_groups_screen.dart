import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/models/subject_model.dart';
import '../widgets/group_card.dart';
import 'create_goup_screen.dart';

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
      backgroundColor: widget.isStandalone
          ? Colors.white
          : Colors.white.withOpacity(0.02),
      // appBar: widget.isStandalone
      //     ? AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.black87),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: Text(
      //     'Manage Groups',
      //     style: GoogleFonts.inter(
      //       color: Colors.black87,
      //       fontWeight: FontWeight.bold,
      //       fontSize: 18,
      //     ),
      //   ),
      // )
      //     : null,
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
                      for (var group in MockData.groups) ...[
                        GroupCard(
                          group: group,
                          academicYear: group.academicYear,
                          subject: MockData.subjects.cast<SubjectModel?>().firstWhere(
                                (s) => s?.subjectId == group.subjectId,
                            orElse: () => null,
                          ),
                          onEditPressed: () {},
                          onDeletePressed: () {},
                        ),
                        SizedBox(height: 16),
                      ],
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