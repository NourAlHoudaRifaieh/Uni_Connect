import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/features/feed/presentation/widgets/academic_year_selector.dart';
import '../../../../core/mock/mock_data.dart';
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
                        onPressed: (){},
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