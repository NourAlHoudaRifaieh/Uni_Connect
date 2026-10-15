import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/group_model.dart';
import 'package:uni_connect/core/models/subject_model.dart';
import 'package:uni_connect/core/models/user_model.dart';
import 'package:uni_connect/features/auth/data/group_repository.dart';
import 'package:uni_connect/features/auth/data/subject_repository.dart';
import 'package:uni_connect/features/auth/data/subject_request_repository.dart';
import 'package:uni_connect/features/feed/presentation/widgets/see_another_subject/request_status_chip.dart';

class SeeAnotherSubjectSheet extends StatefulWidget {
  final UserModel user;
  SeeAnotherSubjectSheet({
    super.key,
    required this.user,
  });

  @override
  _SeeAnotherSubjectSheetState createState() {
    return _SeeAnotherSubjectSheetState();
  }
}

class _SeeAnotherSubjectSheetState extends State<SeeAnotherSubjectSheet> {
  final SubjectRepository _subjectRepository = SubjectRepository();
  final SubjectRequestRepository _requestRepository = SubjectRequestRepository();
  final GroupRepository _groupRepository = GroupRepository();
  
  static const _years = ['Year 1', 'Year2', 'Year3'];
  
  String? _selectedYear;
  String? _selectedGroupId;
  
  //Sends the request to the backend database
  Future<void> _sendRequest(SubjectModel subject) async{
    String? error;
    try{
      error = await _requestRepository.createRequest(user: widget.user, subject: subject);
    }catch(e){
      error = 'Error: $e';
    }
    if(!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Request send to admin'),
        backgroundColor: error == null ? Colors.green : Colors.red
      ),
    );

    if (error == null ) Navigator.pop(context);
  }

  //Filters specialization by year and student department
  List<GroupModel> _getFilteredGroup(List <GroupModel> allGroups){
    final studentDept = widget.user.department;
    return allGroups.where((group) {
      if(group.academicYear != _selectedYear) return false;
      if(studentDept == null || group.department == null) return true;
      return group.department == studentDept;
    }).toList()
      ..sort((a,b) => a.displayName.compareTo(b.displayName));
  }
  
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
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SizedBox(
        height:MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'See Another Subject',
              style: GoogleFonts.inter(
                fontSize:18,
                fontWeight:FontWeight.bold,
              ),
            ),
            SizedBox(height:4),
            Text(
              '1. Pick a year  2. Pick Specialization  3.Request subject',
              style: GoogleFonts.inter(
                fontSize: 12,
                color:Colors.grey.shade600,
              ),
            ),
            SizedBox(height:14),
            
            Wrap(
              spacing: 10,
              children: _years
                .where((year) => year != widget.user.academicYear)
                .map((year) => ChoiceChip(
                  label: Text(year), 
                  selected: _selectedYear == year,
                  onSelected: (context) {
                    return setState(() {
                      _selectedYear = year;
                      _selectedGroupId = null; // Reset group when year changes
                    });
                  },
                )).toList(),
            ),
            SizedBox(height:12),
            
            Expanded(
              child: _selectedYear == null
                ? Center(
                    child: Text('Please select a year', style: GoogleFonts.inter(color:Colors.grey),),)
                : StreamBuilder<List<GroupModel>>(
                  stream: _groupRepository.watchAllGroups(),
                  builder: (context, groupSnapshot){
                    final groups = _getFilteredGroup(groupSnapshot.data ?? []);
                    if(groups.isEmpty){
                      return Center(
                        child: Text('No specialization found in $_selectedYear', style: GoogleFonts.inter(color: Colors.grey),),
                      );
                    }

                    final autoPick = _selectedYear == 'Year 1' || groups.length == 1;
                    final activeGroupId = autoPick ? groups.first.groupId : _selectedGroupId;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(!autoPick) ...[
                          Text('Specialization', style: GoogleFonts.inter(fontSize:13, fontWeight: FontWeight.w600),),
                          SizedBox(height:6),
                          Wrap(
                            spacing: 8,
                            children: groups
                              .map((group) => ChoiceChip(
                                label: Text(group.baseName),
                                selected: _selectedGroupId == group.groupId,
                                onSelected: (context){
                                  return setState(() {
                                    _selectedGroupId = group.groupId;
                                  });
                                },
                              )).toList(),
                          ),
                        ] else
                          Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(groups.first.displayName, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),),
                          ),
                          Expanded(
                            child: activeGroupId == null
                              ? Center(child: Text('Please select a specialization', style: GoogleFonts.inter(color:Colors.grey),),)
                              : StreamBuilder<List<Map<String, dynamic>>>(
                                stream: _requestRepository.watchForUser(widget.user.userId),
                                builder: (context, reqSnapshot){
                                  final myRequests = reqSnapshot.data ?? [];
                                  return StreamBuilder<List<SubjectModel>>(
                                      stream: _subjectRepository.watchAllSubjects(),
                                      builder: (context, subjectSnapshot){
                                        final subjects = (subjectSnapshot.data ?? [])
                                            .where((s) => s.academicYear == _selectedYear && s.belongsToGroup(activeGroupId))
                                            .toList();

                                        if(subjects.isEmpty){
                                          return Center(child: Text('No subjects available here yet.', style: GoogleFonts.inter(color: Colors.grey),),);
                                        }

                                        return ListView.builder(
                                          itemCount: subjects.length,
                                          itemBuilder: (context, index){
                                            final subject = subjects[index];
                                            //Find requests status for this subject
                                            String? status;
                                            for(final req in myRequests){
                                              if(req['subjectId'] == subject.subjectId){
                                                status = req['status'] as String?;
                                              }
                                            }

                                            final alreadyMine = widget.user.extraSubjectIds.contains(subject.subjectId);
                                            //Determine what widget to show on the right side of the row
                                            Widget trailingWidget;
                                            if(alreadyMine || status == 'accepted'){
                                              trailingWidget = RequestStatusChip(status: 'accepted');
                                            }else if(status == 'pending'){
                                              trailingWidget = RequestStatusChip(status: 'pending');
                                            }else{
                                              trailingWidget = ElevatedButton(
                                                onPressed: () => _sendRequest(subject),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(0xFF2563EB),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                                child: Text(status == 'rejected' ? 'Request again' : 'Request'),
                                              );
                                            }
                                            return ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              title: Text(subject.subjectName),
                                              trailing: trailingWidget,
                                            );
                                          },
                                        );
                                      },
                                  );
                                },
                              ),
                          ),
                      ],
                    );
                  }
                )
            ),
          ],
        ),
      ),
    );
  }
}