import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/widgets/custom_form_field.dart';
import 'package:uni_connect/features/feed/presentation/admin/create_subject_screen.dart';
import 'package:uni_connect/features/feed/presentation/widgets/academic_year_selector.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../widgets/subject_card.dart';


class AdminSubjectsScreen extends StatefulWidget {

  final bool isStandalone;
  // final VoidCallback onBack;
  AdminSubjectsScreen({
    super.key,
    this.isStandalone = false,
    // required this.onBack,
  });

  @override
  _AdminSubjectsScreenState createState() {
    return _AdminSubjectsScreenState();
  }
}

class _AdminSubjectsScreenState extends State<AdminSubjectsScreen> {

  String _selectedYear = 'Year 1';

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
    // Filter groups based on selected academic year
    final filteredSubjects = MockData.subjects.where((subject) {
      if (_selectedYear == 'All Years') return true;
      return subject.academicYear == _selectedYear;
    }).toList();

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
                        // onPressed: (){
                        //   showModalBottomSheet(
                        //       context: context,
                        //       isScrollControlled: true, // allows custom height
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.vertical(
                        //           top: Radius.circular(20),
                        //         ),
                        //       ),
                        //       builder: (BuildContext context){
                        //         return Padding(
                        //           padding: EdgeInsets.only(
                        //             bottom: MediaQuery.of(context).viewInsets.bottom,// handles keyboard padding
                        //           ),
                        //           child: Container(
                        //             padding: EdgeInsets.all(20),
                        //             height: 700, //set your desired popup  height
                        //             width: double.infinity,
                        //             child: Column(
                        //               mainAxisSize: MainAxisSize.min,
                        //               crossAxisAlignment: CrossAxisAlignment.stretch,
                        //               children: [
                        //                 Row(
                        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                   children: [
                        //                     Text(
                        //                       'Edit Subject',
                        //                       style: GoogleFonts.inter(
                        //                         fontSize: 20,
                        //                         fontWeight: FontWeight.bold,
                        //                       ),
                        //                     ),
                        //                     Container(
                        //                       width:40,
                        //                       height: 40,
                        //                       decoration: BoxDecoration(
                        //                         border: Border.all(color: Colors.grey.shade200),
                        //                         borderRadius: BorderRadius.circular(50),
                        //                         color: Color(0xFF1D61FF).withOpacity(0.1),
                        //                       ),
                        //                       child: IconButton(
                        //                         onPressed: (){
                        //                           Navigator.pop(context);
                        //                         },
                        //                         icon: Icon(Icons.close, size: 20, color: Colors.grey.shade700),
                        //                         style: IconButton.styleFrom(
                        //
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 SizedBox(height:20),
                        //                 CustomFormField(
                        //                     label: 'Subject Name',
                        //                     hint: 'hint',
                        //                     controller: '',
                        //                 ),
                        //                 CustomFormField(
                        //                     label: 'Subject Code',
                        //                     hint: 'hint',
                        //                     controller: controller
                        //                 ),
                        //                 Text(
                        //                   'Academic Year',
                        //                   style: GoogleFonts.inter(
                        //                     fontSize:14,
                        //                     fontWeight: FontWeight.w600,
                        //                     color: Color(0xFF2F3A4A),
                        //                   ),
                        //                 ),
                        //                 Wrap(
                        //                   spacing: 15,
                        //                   runSpacing: 15,
                        //                   children: kAcademicYears.map((year) {
                        //                     final bool selected = selectedYear == year;
                        //                     return GestureDetector(
                        //                       onTap: (){
                        //                         setState(() {
                        //                           selectedYear = year;
                        //                         });
                        //                       },
                        //                       child: Container(
                        //                         width: (MediaQuery.of(context).size.width - 24 * 2 - 10) / 2,
                        //                         padding: const EdgeInsets.symmetric(vertical: 14),
                        //                         alignment: Alignment.center,
                        //                         decoration: BoxDecoration(
                        //                           color: selected ?  Color(0xFF2563EB) : Color(0xFFF3F4F6),
                        //                           border: Border.all(
                        //                             color: selected
                        //                                 ?  Color(0xFFE2E8F0)
                        //                                 : Colors.grey.shade300,
                        //                             width: 1,
                        //                           ),
                        //                           borderRadius: BorderRadius.circular(20),
                        //                         ),
                        //                         child: Text(
                        //                           year,
                        //                           style: TextStyle(
                        //                             color: selected ? Colors.white : Colors.black87,
                        //                             fontWeight: FontWeight.w600,
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     );
                        //                   }).toList(),
                        //                 ),
                        //
                        //               ],
                        //             ),
                        //           ),
                        //         );
                        //       },
                        //   );
                        // },



                        // onPressed: () async{
                        //   //await the result from createGroupScree
                        //   final result = await
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => CreateGroupScreen()),
                        //   );
                        //   //rebuild screen if a group was created
                        //   if(result == true && mounted){
                        //     setState(() {
                        //
                        //     });
                        //   }
                        // }
                    ),
                    SizedBox(height:20),
                    if (filteredSubjects.isEmpty)
                      Center(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 40,
                            ),
                          child: Text('No Subjects available for $_selectedYear',
                            style: GoogleFonts.inter(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredSubjects.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                        final subject = filteredSubjects[index];
                        return SubjectCard(
                          subject: subject,
                          academicYear: _selectedYear,
                          onEditPressed: () {
                          // Handle Subject Edit
                          },
                          onDeletePressed: () {
                          // Handle Subject Delete
                          },
                        );
                        },
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