import 'package:flutter/material.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/models/subject_model.dart';
import '../../../../core/models/user_model.dart';
import '../widgets/group_card.dart';

class AdminGroupsScreen extends StatefulWidget {
  AdminGroupsScreen({Key? key}) : super(key: key);

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
      backgroundColor: Color(0xFF1D61FF).withOpacity(0.02),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomElevatedButton(
                  text: 'Create New Group',
                  onPressed: (){}
              ),
              SizedBox(height:20),
              for (var group in MockData.groups) ...[
                GroupCard(
                  group: group,
                  // creator: MockData.users.cast<UserModel?>().firstWhere(
                  //       (u) => u?.userId == group.userId,
                  //   orElse: () => null,
                  // ),
                  subject: MockData.subjects.cast<SubjectModel?>().firstWhere(
                        (s) => s?.subjectId == group.subjectId,
                    orElse: () => null,
                  ),
                  onEditPressed: () {},
                  onDeletePressed: () {},
                ),
                SizedBox(height: 16),
              ],
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}