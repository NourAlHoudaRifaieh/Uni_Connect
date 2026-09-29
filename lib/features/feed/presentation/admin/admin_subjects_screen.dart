import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/subject_model.dart';
import 'package:uni_connect/features/auth/data/subject_repository.dart';
import 'package:uni_connect/features/feed/presentation/admin/create_subject_screen.dart';
import 'package:uni_connect/features/feed/presentation/widgets/academic_year_selector.dart';
import 'package:uni_connect/features/feed/presentation/widgets/delete_subject_dialog.dart';
import 'package:uni_connect/features/feed/presentation/widgets/edit_subject_dialog.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../widgets/subject_card.dart';


class AdminSubjectsScreen extends StatefulWidget {

  final bool isStandalone;
  AdminSubjectsScreen({
    super.key,
    this.isStandalone = false,
  });

  @override
  _AdminSubjectsScreenState createState() {
    return _AdminSubjectsScreenState();
  }
}

class _AdminSubjectsScreenState extends State<AdminSubjectsScreen> {
  final SubjectRepository _subjectRepository = SubjectRepository();
  String _selectedYear = 'Year 1';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // Filter groups based on selected academic year
    // final filteredSubjects = MockData.subjects.where((subject) {
    //   if (_selectedYear == 'All Years') return true;
    //   return subject.academicYear == _selectedYear;
    // }).toList();

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
                    Text('Manage Subject',
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
                        text: 'Add Subject to $_selectedYear',
                        onPressed: () async{
                          final result = await
                          Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => CreateSubjectScreen())
                          );
                          if(result == true && mounted){
                            setState(() {

                            });
                          }
                        },
                    ),
                    SizedBox(height:20),
                    StreamBuilder<List<SubjectModel>>(
                        stream: _subjectRepository.watchAllSubjects(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final allSubjects = snapshot.data ?? [];
                          final filteredSubjects = allSubjects.where((subject) {
                            if (_selectedYear == 'All Years') return true;
                            return subject.academicYear == _selectedYear;
                          }).toList();

                          if (filteredSubjects.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 40,
                                ),
                                child: Text(
                                  'No Subjects available for $_selectedYear',
                                  style: GoogleFonts.inter(
                                    color: Colors.grey.shade500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredSubjects.length,
                            separatorBuilder: (context,
                                index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final subject = filteredSubjects[index];
                              return SubjectCard(
                                subject: subject,
                                academicYear: _selectedYear,
                                onEditPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context){
                                        return EditSubjectDialog(
                                            subject: subject,
                                            onUpdateConfirmed: (updateName, updateYear) async{
                                              if(subject.subjectId != null){
                                                SubjectModel updatedSubject = SubjectModel(
                                                  subjectId:  subject.subjectId,
                                                  subjectName: updateName,
                                                  subjectCode: subject.subjectCode,
                                                  academicYear: updateYear,
                                                  postCount: subject.postCount,
                                                );
                                                await _subjectRepository.updateSubject(updatedSubject);
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
                                // onDeletePressed: () async{
                                //   if(subject.subjectId != null){
                                //     await _subjectRepository.deleteSubject(subject.subjectId!);
                                //     if(mounted){
                                //       setState(() {
                                //
                                //       });
                                //     }
                                //   }
                                // },
                                onDeletePressed: (){
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DeleteSubjectDialog(
                                          subject: subject,
                                          onDeleteConfirmed: () async{
                                            if(subject.subjectId != null){
                                              await _subjectRepository.deleteSubject(subject.subjectId!);
                                              if(mounted){
                                                setState(() {
                                                });
                                              }
                                            }
                                          },
                                        );
                                      },
                                  );
                                },
                              );
                            },
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