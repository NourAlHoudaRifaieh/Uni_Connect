import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/features/auth/data/subject_repository.dart';
import 'package:uni_connect/features/auth/data/user_repository.dart';
import 'package:uni_connect/features/feed/presentation/student/subject_details_screen.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/models/subject_model.dart';
import '../../../../core/models/user_model.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // final List<SubjectModel> subjects = MockData.subjects;
    final SubjectRepository _subjectRepository = SubjectRepository();
    final UserRepository _userRepository = UserRepository();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<List<SubjectModel>>(
          stream: _subjectRepository.watchAllSubjects(),
          builder: (context, snapshot){
            if(!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child:  CircularProgressIndicator(),
              );
            }
            final subjects = snapshot.data ?? [];

            return StreamBuilder<UserModel?>(
                stream: _userRepository.watchCurrentUser(),
                builder: (context, userSnapshot){
                  final userModel = userSnapshot.data;
                  final academicYear = userModel?.academicYear ?? 'Master 2';
                  final faculty = userModel?.faculty ?? 'Business Administration';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('My Subjects',
                                style: GoogleFonts.inter(fontSize: 22, fontWeight:  FontWeight.bold)
                            ),
                            SizedBox(height:4),
                            Text('$academicYear - ${subjects.length} subjects enrolled',
                              style: GoogleFonts.inter(
                                  fontSize: 13, color: Colors.grey.shade600
                              ),
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
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              subjects.isEmpty
                              ? Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical:40),
                                  child: Text(
                                    'No subjects enrolled yet.',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              )
                              : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: subjects.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 14,
                                    crossAxisSpacing: 14,
                                    childAspectRatio: 1.1
                                ),
                                itemBuilder: (context , index){
                                  SubjectModel subject = subjects[index];
                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context)=> SubjectDetailsScreen(subject:subject)),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.grey.shade200),
                                      ),
                                      child:  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF1D61FF).withOpacity(0.12),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Icon(Icons.menu_book, color: Color(0xFF1D61FF), size:20),
                                          ),
                                          SizedBox(height:10),
                                          Text(
                                            subject.subjectCode ?? '',
                                            style: GoogleFonts.inter(
                                                fontSize: 11,
                                                color: Colors.grey.shade500
                                            ),
                                          ),
                                          SizedBox(height:2),
                                          Text(
                                            subject.subjectName ?? '',
                                            style: GoogleFonts.inter(
                                                fontSize: 14, fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              Container(
                                                width:6,
                                                height:6,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF1D61FF),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              SizedBox(width:6),
                                              Text(
                                                  '${subject.postCount ?? 0} posts',
                                                  style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500)
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
                                        Icon(Icons.apartment, color: Color(0xFF2563EB),size:20),
                                        SizedBox(width:10),
                                        Text(
                                          'Academic Group',
                                          style: GoogleFonts.inter(
                                            color: Color(0xFF2563EB),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$faculty, $academicYear',
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
                    ],
                  );

                }
            );
            // return  Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.all(20),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text('My Subjects',
            //               style: GoogleFonts.inter(fontSize: 22, fontWeight:  FontWeight.bold)
            //           ),
            //           SizedBox(height:4),
            //           Text('Master 2 - ${subjects.length} subjects enrolled',
            //             style: GoogleFonts.inter(
            //                 fontSize: 13, color: Colors.grey.shade600
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     Container(
            //       height: 1,
            //       width: double.infinity,
            //       decoration: BoxDecoration(
            //         border: Border(
            //           bottom: BorderSide(
            //             color: Color(0xFFF1F5F9),
            //             width:1.5,
            //           ),
            //         ),
            //         color: Colors.white,
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.black.withOpacity(0.03),
            //             blurRadius: 10,
            //             offset:Offset(0,8),
            //           ),
            //         ],
            //       ),
            //     ),
            //     Expanded(
            //       child: SingleChildScrollView(
            //         padding: EdgeInsets.all(20),
            //         child: Column(
            //           children: [
            //             subjects.isEmpty
            //               ? Center(
            //                   child: Padding(
            //                     padding: EdgeInsets.symmetric(vertical:40),
            //                     child: Text(
            //                       'No subjects enrolled yet.',
            //                       style: GoogleFonts.inter(
            //                         fontSize: 14,
            //                         color: Colors.grey.shade500,
            //                       ),
            //                     ),
            //                   ),
            //                 )
            //
            //               : GridView.builder(
            //                   shrinkWrap: true,
            //                   physics: NeverScrollableScrollPhysics(),
            //                   itemCount: subjects.length,
            //                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //                       crossAxisCount: 2,
            //                       mainAxisSpacing: 14,
            //                       crossAxisSpacing: 14,
            //                       childAspectRatio: 1.1
            //                   ),
            //                   itemBuilder: (context , index){
            //                     SubjectModel subject = subjects[index];
            //                     return GestureDetector(
            //                       onTap: (){
            //                         Navigator.push(
            //                           context,
            //                           MaterialPageRoute(builder: (context)=> SubjectDetailsScreen(subject:subject)),
            //                         );
            //                       },
            //                       child: Container(
            //                         padding: EdgeInsets.all(14),
            //                         decoration: BoxDecoration(
            //                           color: Colors.white,
            //                           borderRadius: BorderRadius.circular(20),
            //                           border: Border.all(color: Colors.grey.shade200),
            //                         ),
            //                         child:  Column(
            //                           crossAxisAlignment: CrossAxisAlignment.start,
            //                           children: [
            //                             Container(
            //                               width: 40,
            //                               height: 40,
            //                               decoration: BoxDecoration(
            //                                 color: Color(0xFF1D61FF).withOpacity(0.12),
            //                                 borderRadius: BorderRadius.circular(10),
            //                               ),
            //                               child: Icon(Icons.menu_book, color: Color(0xFF1D61FF), size:20),
            //                             ),
            //                             SizedBox(height:10),
            //                             Text(
            //                               subject.subjectCode ?? '',
            //                               style: GoogleFonts.inter(
            //                                   fontSize: 11,
            //                                   color: Colors.grey.shade500
            //                               ),
            //                             ),
            //                             SizedBox(height:2),
            //                             Text(
            //                               subject.subjectName ?? '',
            //                               style: GoogleFonts.inter(
            //                                   fontSize: 14, fontWeight: FontWeight.bold
            //                               ),
            //                             ),
            //                             Spacer(),
            //                             Row(
            //                               children: [
            //                                 Container(
            //                                   width:6,
            //                                   height:6,
            //                                   decoration: BoxDecoration(
            //                                     color: Color(0xFF1D61FF),
            //                                     shape: BoxShape.circle,
            //                                   ),
            //                                 ),
            //                                 SizedBox(width:6),
            //                                 Text(
            //                                     '${subject.postCount ?? 0} posts',
            //                                     style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500)
            //                                 ),
            //                               ],
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     );
            //                   },
            //                 ),
            //
            //             SizedBox(height:20),
            //             Container(
            //               width: double.infinity,
            //               padding: const EdgeInsets.all(14),
            //               decoration: BoxDecoration(
            //                 color:  Color(0xFFEFF6FF),
            //                 borderRadius: BorderRadius.circular(20),
            //                 border: Border.all(
            //                   color: Color(0xFF2563EB),
            //                   width:1,
            //                 ),
            //               ),
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Row(
            //                     children: [
            //                       Icon(Icons.apartment, color: Color(0xFF2563EB),size:20),
            //                       SizedBox(width:10),
            //                       Text(
            //                         'Academic Group',
            //                         style: GoogleFonts.inter(
            //                           color: Color(0xFF2563EB),
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 14,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   Text(
            //                     'Business Administration. Master 2',
            //                     style: GoogleFonts.inter(
            //                       color: Color(0xFF2563EB),
            //                       fontSize: 13,
            //                       fontWeight: FontWeight.w500,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // );
          }
        ),
      ),
    );
  }
}
