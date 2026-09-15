import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/group_model.dart';
import 'package:uni_connect/core/widgets/custom_form_field.dart';
import 'package:uni_connect/features/auth/data/group_repository.dart';

import '../../../../core/mock/mock_data.dart';
import '../../../../core/widgets/custom_elevated_button.dart';

const List<String> kAcademicYears = [
  'Year 1',
  'Year 2',
  'Year 3',
  'Year 4',
  'Year 5',
];


class CreateGroupScreen extends StatefulWidget {
  CreateGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateGroupScreenState createState() {
    return _CreateGroupScreenState();
  }
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _groupNameController = TextEditingController();

  String? selectedYear;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  void _onCreateGroup() async{
    if(_formKey.currentState !=null && _formKey.currentState!.validate()){
      if(selectedYear == null){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an academic year')),
        );
        return;
      }
      setState(() {
        isLoading = true;
      });
      try{
        final newGroup = GroupModel(
          groupName: _groupNameController.text.trim(),
          membersCount: 0,
          academicYear: selectedYear,
        );

        final groupRepository = GroupRepository();
        await groupRepository.createGroup(newGroup);

        if(mounted){
          Navigator.pop(context, true);
        }
      }catch(e){
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create group: $e')),
          );
        }
      }finally{
        if(mounted){
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24,40,24,24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.chevron_left, color: Colors.white.withOpacity(0.7), size:20),
                        Text('Groups', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  SizedBox(height:15),
                  Text(
                      'Create New Group',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight:  FontWeight.bold, color: Colors.white)
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child:SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomFormField(
                        label: 'Group Name',
                        hint: 'eg: Business Administration',
                        controller: _groupNameController,
                        validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter a group name' : null,
                      ),
                      SizedBox(height:20),
                      Text(
                        'Academic Year',
                        style: GoogleFonts.inter(
                          fontSize:16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2F3A4A),
                        ),
                      ),
                      SizedBox(height:10),
                      Wrap(
                        spacing: 15,
                        runSpacing: 15,
                        children: kAcademicYears.map((year) {
                          final bool selected = selectedYear == year;
                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedYear = year;
                              });
                            },
                            child: Container(
                              width: (MediaQuery.of(context).size.width - 24 * 2 - 10) / 2,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selected ?  Color(0xFF2563EB) : Color(0xFFF3F4F6),
                                border: Border.all(
                                  color: selected
                                      ?  Color(0xFFE2E8F0)
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                year,
                                style: TextStyle(
                                  color: selected ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height:50),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color:  Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xFF2563EB),
                            width:1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Auto-assignment',
                              style: GoogleFonts.inter(
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Students who register with matching faculty and academic year are automatically assigned to the group.',
                              style: GoogleFonts.inter(
                                color: Color(0xFF2563EB),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height:20),
                  CustomElevatedButton(
                    text: 'Create Group',
                    onPressed: _onCreateGroup,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}