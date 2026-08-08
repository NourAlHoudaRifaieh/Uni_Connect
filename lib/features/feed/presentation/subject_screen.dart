import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectData{
  final String code;
  final String title;
  final int postCount;
  final Color color;
  final IconData icon;

  SubjectData({
    required this.icon,
    required this.title,
    required this.code,
    required this.color,
    required this.postCount,
  });
}
class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {

    List <SubjectData> subjects =[
      SubjectData(
          icon: Icons.menu_book,
          title: 'Theses Project',
          code: 'THE601',
          color: Colors.red,
          postCount: 5,
      ),
      SubjectData(
          icon: Icons.menu_book,
          title: 'Advanced Data Analysis',
          code: 'ADA601',
          color: Colors.green,
          postCount: 9,
      ),
      SubjectData(
          icon: Icons.menu_book,
          title: 'Leadership & Innovation',
          code: 'LDR601',
          color: Colors.blue,
          postCount: 5
      ),
    ];

    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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
                  Text('Master 2 . ${subjects.length} subjects enrolled',
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
                    GridView.builder(
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
                        SubjectData subject = subjects[index];
                        return Container(
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
                                  color: subject.color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(subject.icon, color: subject.color, size:20),
                              ),
                              SizedBox(height:10),
                              Text(
                                subject.code,
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey.shade500
                                ),
                              ),
                              SizedBox(height:2),
                              Text(
                                subject.title,
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
                                      color: subject.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width:6),
                                  Text(
                                      '${subject.postCount} posts',
                                      style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500)
                                  ),
                                ],
                              ),
                            ],
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
                      child: Row(
                        children: [
                          Icon(Icons.apartment, color: Color(0xFF2563EB),size:20),
                          SizedBox(width:10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Academic Group',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF2563EB),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Business Administration. Master 2',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF2563EB),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
