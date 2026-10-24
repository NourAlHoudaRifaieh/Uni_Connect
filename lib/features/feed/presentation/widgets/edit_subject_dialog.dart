import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/group_model.dart';
import 'package:uni_connect/core/models/subject_model.dart';
import 'package:uni_connect/core/widgets/custom_dropdown.dart';
import 'package:uni_connect/core/widgets/custom_form_field.dart';
import 'package:uni_connect/features/auth/data/group_repository.dart';

import '../../../../core/widgets/custom_elevated_button.dart';

class EditSubjectDialog extends StatefulWidget {

  final SubjectModel subject;
  final Function (
      String updatedName,
      String updatedYear,
      String mainGroupId,
      List<String> sharedGroupIds,
      ) onUpdateConfirmed;

  EditSubjectDialog({
    super.key,
    required this.subject,
    required this.onUpdateConfirmed,
  });

  @override
  _EditSubjectDialogState createState() {
    return _EditSubjectDialogState();
  }
}

class _EditSubjectDialogState extends State<EditSubjectDialog> {
  late  TextEditingController _nameController = TextEditingController();
  final GroupRepository _groupRepository = GroupRepository();
  late String _selectedYear;
  final Set<String> _selectedGroupIds = {};

  final List<String> _academicYear =[
    'Year 1',
    'Year 2',
    'Year 3',
    'Year 4',
    'Year 5',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject.subjectName ?? '');
    _selectedYear = widget.subject.academicYear ?? 'Year 1';

    if(widget.subject.groupId != null && widget.subject.groupId!.isNotEmpty){
      _selectedGroupIds.add(widget.subject.groupId!);
    }
    if(widget.subject.sharedGroupIds != null){
      _selectedGroupIds.addAll(widget.subject.sharedGroupIds!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titlePadding:  EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: EdgeInsets.fromLTRB(20, 16, 20, 20),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Edit Subject',
            style: GoogleFonts.inter(
              fontSize:18,
              fontWeight:FontWeight.bold,
              color:Color(0xFF1E293B),
            ),
          ),
          IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.close, size: 20, color: Colors.grey),
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormField(
                  label:'Subject Name',
                  hint: 'Enter subject name',
                  controller: _nameController,
              ),
              SizedBox(height:16),
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
                children: _academicYear.map((year) {
                  final bool selected = _selectedYear == year;
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        _selectedYear = year;
                        _selectedGroupIds.clear();
                      });
                    },
                    child: Container(
                      // width: (MediaQuery.of(context).size.width - 24 * 2 - 10) / 2,
                      width: (MediaQuery.of(context).size.width * 0.75 - 30 - 10) / 2,
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
              SizedBox(height:24),
              Text(
                'Specializations',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF2F3A4A),
                ),
              ),
              SizedBox(height:4),
              Text(
                'Tick one specialization, or several if the subject is common.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height:8),
              StreamBuilder<List<GroupModel>>(
                stream: _groupRepository.watchAllGroups(),
                builder: (context, snapshot){
                  final yearGroups = (snapshot.data ?? [])
                      .where((g) => g.academicYear == _selectedYear)
                      .toList()
                    ..sort((a, b) => a.displayName.compareTo(b.displayName));
                  if(snapshot.connectionState == ConnectionState.waiting && yearGroups.isEmpty){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if(yearGroups.isEmpty){
                    return Text(
                      'No groups exist for $_selectedYear yet.',
                      style: GoogleFonts.inter(
                        color:Colors.grey.shade600,
                      ),
                    );
                  }
                  final ids = yearGroups.map((g) => g.groupId).whereType<String>().toList();
                  final allSelected = ids.isNotEmpty && ids.every(_selectedGroupIds.contains);
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        )
                    ),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          value: allSelected,
                          onChanged: (v) {
                            setState(() {
                              if(v == true){
                                _selectedGroupIds.addAll(ids);
                              }else{
                                _selectedGroupIds.removeAll(ids);
                              }
                            });
                          },
                          title: Text(
                            'All Specialization of $_selectedYear',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          controlAffinity:ListTileControlAffinity.leading,
                        ),
                        Divider(height:1),
                        ...yearGroups.map((g) => CheckboxListTile(
                          value: _selectedGroupIds.contains(g.groupId),
                          onChanged: (v){
                            setState(() {
                              if(v == true){
                               _selectedGroupIds.add(g.groupId!);
                              }else{
                                _selectedGroupIds.remove(g.groupId);
                              }
                            });
                          },
                          title: Text(g.displayName),
                          controlAffinity: ListTileControlAffinity.leading,
                        )),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height:24),
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                        text: 'Cancel',
                        type: ButtonType.outlined,
                        backgroundColor: Colors.grey.shade700,
                        textColor: Colors.black87,
                        onPressed: (){
                          Navigator.pop(context);
                        }
                    ),
                  ),
                  SizedBox(width:12),
                  Expanded(
                    child: CustomElevatedButton(
                        text: 'Save',
                        backgroundColor: Color(0xFF2563EB),
                        onPressed: (){
                          if (_selectedGroupIds.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please select at least one specialization')),
                            );
                            return;
                          }

                          final listIds = _selectedGroupIds.toList();
                          final mainGroupId = listIds.first;
                          final sharedGroupIds = listIds.skip(1).toList();

                          Navigator.pop(context);
                          widget.onUpdateConfirmed(
                            _nameController.text.trim(),
                            _selectedYear,
                            mainGroupId,
                            sharedGroupIds,
                          );
                        }
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}