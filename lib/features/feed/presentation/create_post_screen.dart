import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/mock/mock_data.dart';
import 'package:uni_connect/core/models/subject_model.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import 'package:uni_connect/core/widgets/custom_form_field.dart';

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() {
    return _CreatePostScreenState();
  }
}

class _CreatePostScreenState extends State<CreatePostScreen> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  List<SubjectModel> subjects = [];
  SubjectModel? selectedSubject;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  void _loadSubjects(){
    setState(() {
      subjects = MockData.subjects;
      if(subjects.isNotEmpty){
        selectedSubject = subjects.first;
      }
    });
  }


  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Create Post',
                            style: GoogleFonts.inter(fontSize: 22, fontWeight:  FontWeight.bold)
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal:10, vertical:4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.auto_awesome, size:14, color:Color(0xFF2563EB)),
                              SizedBox(width:5),
                              Text(
                                'AI Categorize',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF2563EB),
                                  fontWeight: FontWeight.bold,
                                  fontSize:13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
              SizedBox(height:15),
              Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal:20, vertical:10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Subject', style: GoogleFonts.inter(fontWeight:FontWeight.w600, fontSize:15)),
                        SizedBox(height:8),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: subjects.map((subject){
                            final bool isSelected = selectedSubject?.subjectCode == subject.subjectCode;
                            return GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectedSubject = subject;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                padding: EdgeInsets.symmetric(horizontal:14, vertical:14),
                                decoration: BoxDecoration(
                                  color: isSelected ? Color(0xFFEFF6FF) : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? Color(0xFF2563EB) : Colors.grey.shade300,
                                    width: isSelected ? 1.5 :1.0,
                                  ),
                                ),
                                child: Text(
                                  subject.subjectName,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight:FontWeight.w600,
                                    color: isSelected ? Color(0xFF2563EB) : Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height:20),
                        CustomFormField(
                            label:'Title',
                            hint: 'What is your question or topic',
                            controller: _titleController,
                        ),
                        SizedBox(height:20),
                        CustomFormField(
                            label: 'Description',
                            maxLines: 5,
                            hint: 'Describe in detail - the more context you give, the better responses you will get',
                            controller: _descriptionController,
                        ),
                        SizedBox(height:20),
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
                              Row(
                                children: [
                                  Icon(Icons.auto_awesome, color: Color(0xFF2563EB),size:20),
                                  SizedBox(width:10),
                                  Text(
                                    'Smart AI Categorization',
                                    style: GoogleFonts.inter(
                                      color: Color(0xFF2563EB),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'When you publish, AI will analyze your title and description to assign the right category automatically',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF2563EB),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height:30),
                        CustomElevatedButton(
                            text: 'Analyse & Publish',
                            onPressed: (){
                              if(selectedSubject !=null){

                              }
                            }
                        ),
                        SizedBox(height:20),
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