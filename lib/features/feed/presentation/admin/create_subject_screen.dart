import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/subject_model.dart';
import 'package:uni_connect/core/widgets/custom_form_field.dart';
import 'package:uni_connect/features/auth/data/group_repository.dart';
import 'package:uni_connect/features/auth/data/subject_repository.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/models/group_model.dart';
import '../../../../core/widgets/custom_elevated_button.dart';

const List<String> kAcademicYears = [
  'Year 1',
  'Year 2',
  'Year 3',
  'Year 4',
  'Year 5',
];


class CreateSubjectScreen extends StatefulWidget {

  CreateSubjectScreen({
    super.key,

  });

  @override
  _CreateSubjectScreenState createState() {
    return _CreateSubjectScreenState();
  }
}

class _CreateSubjectScreenState extends State<CreateSubjectScreen> {


  final _formKey = GlobalKey<FormState>();
  TextEditingController _subjectNameController = TextEditingController();
  final SubjectRepository _subjectRepository = SubjectRepository();
  final GroupRepository _groupRepository = GroupRepository();

  String? selectedGroupId;
  GroupModel? selectedGroup;
  String? selectedYear;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _subjectNameController.dispose();
    // _subjectCodeController.dispose();
    super.dispose();
  }

  List<String> get _availableAcademicYears {
    if (selectedGroup == null) return kAcademicYears;
    final name = selectedGroup!.groupName.toLowerCase();

    if (name.contains('general preparation')) {
      return ['Year 1'];
    } else if (name.contains('economic science')) {
      return ['Year 1', 'Year 2', 'Year 3', 'Year 4', 'Year 5'];
    } else {
      return ['Year 2', 'Year 3', 'Year 4', 'Year 5'];
    }
  }

  Future <void> _onCreateSubject() async{
    final currentGroupId = selectedGroupId;
    if(_formKey.currentState !=null && _formKey.currentState!.validate()){
      if(currentGroupId == null){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a group')),
        );
        return;
      }
      setState(() {
        isLoading= true;
      });
      if(selectedYear == null){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an academic year')),
        );
        return;
      }
      setState(() {
        isLoading= true;
      });

      try{
        final newSubject = SubjectModel(
          // subjectId: 'sub_${DateTime.now().millisecondsSinceEpoch}',
          subjectId: '',
          // subjectCode: _subjectCodeController.text.trim(),
            subjectCode: '',
          subjectName: _subjectNameController.text.trim(),
          academicYear: selectedYear,
          groupId: currentGroupId,
          postCount: 0
        );
        await _subjectRepository.createSubject(newSubject);
        if(mounted){
          Navigator.pop(context, true);
        }
      }catch(e){
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating subject: $e')),
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
                        Text('Subjects', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  SizedBox(height:15),
                  Text(
                      'Create New Subject',
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
                      Text(
                        'Select Group / Major',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2F3A4A),
                        ),
                      ),
                      SizedBox(height:5),
                      StreamBuilder<List<GroupModel>>(
                        stream: _groupRepository.watchAllGroups(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          final groups = snapshot.data ?? [];
                          return DropdownButtonFormField<String>(
                            value: selectedGroupId,
                            hint: Text('Select group'),
                            isExpanded: true,
                            items: groups.map((group) {
                              return DropdownMenuItem<String>(
                                value: group.groupId,
                                // child: Text('${group.groupName} (${group.academicYear ?? ""}) - ${group.membersCount ?? 0} members'),
                                // child: Text('${group.groupName}'),
                                child: Text('${group.groupName} (${group.academicYear ?? ""})'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedGroupId = value;
                                selectedGroup = groups.firstWhere(
                                      (g) => g.groupId == value,
                                  orElse: () => GroupModel(groupName: ''),
                                );
                                final name = selectedGroup?.groupName.toLowerCase() ?? '';
                                if (name.contains('general preparation')) {
                                  selectedYear = 'Year 1';
                                } else if (_availableAcademicYears.length == 1) {
                                  selectedYear = _availableAcademicYears.first;
                                } else if (selectedYear != null && !_availableAcademicYears.contains(selectedYear)) {
                                  selectedYear = null;
                                }
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomFormField(
                        label: 'Subject Name',
                        hint: 'eg: Database Systems',
                        controller: _subjectNameController,
                        validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter a subject name' : null,
                      ),
                      SizedBox(height:20),
                      // CustomFormField(
                      //   label: 'Subject Code',
                      //   hint: 'eg: DB602',
                      //   controller: _subjectCodeController,
                      //   validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter a subject code' : null,
                      // ),
                      // SizedBox(height:20),
                      const SizedBox(height: 10),
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
                              // width: (MediaQuery.of(context).size.width - 24 * 2 - 10) / 2,
                              width: (MediaQuery.of(context).size.width - 40 - 15) / 2,
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
                    text: 'Create Subject',
                    onPressed: _onCreateSubject,
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