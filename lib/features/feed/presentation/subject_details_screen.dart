import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/features/feed/presentation/subject_screen.dart';
import 'package:uni_connect/features/feed/presentation/widgets/post_card.dart';

class SubjectDetailsScreen extends StatelessWidget {

  final SubjectData subject;
  // final PostCardData postInfo;

  SubjectDetailsScreen({
    super.key,
    required this.subject,
    // required this.postInfo,
  });


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
                        Text('Subjects', style: GoogleFonts.inter(color: Color(0xFF2563EB), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  SizedBox(height:10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      SizedBox(width:10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject.code,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey.shade800
                            ),
                          ),
                          Text( subject.title,
                              style: GoogleFonts.inter(fontSize: 18, fontWeight:  FontWeight.bold)
                          ),
                        ],
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
            // Expanded(
            //   child: displyadPosts.isEmpty
            //       ? Center(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Container(
            //           width:70,
            //           height:70,
            //           decoration: BoxDecoration(
            //             color: Color(0xFFF3F4F6),
            //             borderRadius: BorderRadius.circular(20),
            //           ),
            //           child:  Icon(Icons.article_outlined , size:36, color: Color(0xFF9CA3AF)),
            //         ),
            //         SizedBox(height:16),
            //         Text(
            //           _searchController.text.trim().isEmpty ? 'No results found for ${_searchController.text.trim()}' : 'No posts in this category',
            //           style: GoogleFonts.inter(
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //             color: Color(0xFF6B7280),
            //           ),
            //         ),
            //       ],
            //     ),
            //   )
            //       : ListView.builder(
            //     padding: const EdgeInsets.symmetric(horizontal: 20),
            //     itemCount: displyadPosts.length,
            //     itemBuilder: (context, index) {
            //       return PostCard(
            //         data: displyadPosts[index],
            //         onTap: () {
            //           // will open post detail screen later
            //         },
            //       );
            //     },
            //   ),
            // ),
            // Expanded(
            //   child: SingleChildScrollView(
            //     padding: EdgeInsets.symmetric(horizontal:20, vertical:10),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text('Select Subject', style: GoogleFonts.inter(fontWeight:FontWeight.w600, fontSize:15)),
            //         SizedBox(height:8),
            //         Wrap(
            //           spacing: 10,
            //           runSpacing: 10,
            //           children: subjects.map((s){
            //             bool isSelected = s == selectedSubject;
            //             return GestureDetector(
            //               onTap: (){
            //                 setState(() {
            //                   selectedSubject = s;
            //                 });
            //               },
            //               child: Container(
            //                 padding: EdgeInsets.symmetric(horizontal:14, vertical:14),
            //                 decoration: BoxDecoration(
            //                   color: isSelected ? Color(0xFFEFF6FF) : Colors.white,
            //                   borderRadius: BorderRadius.circular(20),
            //                   border: Border.all(
            //                     color: isSelected ? Color(0xFF2563EB) : Colors.grey.shade300,
            //                   ),
            //                 ),
            //                 child: Text(
            //                   s,
            //                   style: GoogleFonts.inter(
            //                     fontSize: 13,
            //                     fontWeight:FontWeight.w600,
            //                     color: isSelected ? Color(0xFF2563EB) : Colors.black87,
            //                   ),
            //                 ),
            //               ),
            //             );
            //           }).toList(),
            //         ),
            //         SizedBox(height:20),
            //         CustomFormField(
            //           label:'Title',
            //           hint: 'What is your question or topic',
            //           controller: _titleController,
            //         ),
            //         SizedBox(height:20),
            //         CustomFormField(
            //           label: 'Description',
            //           maxLines: 5,
            //           hint: 'Describe in detail - the more context you give, the better responses you will get',
            //           controller: _descriptionController,
            //         ),
            //         SizedBox(height:20),
            //         Container(
            //           width: double.infinity,
            //           padding: const EdgeInsets.all(14),
            //           decoration: BoxDecoration(
            //             color:  Color(0xFFEFF6FF),
            //             borderRadius: BorderRadius.circular(20),
            //             border: Border.all(
            //               color: Color(0xFF2563EB),
            //               width:1,
            //             ),
            //           ),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Row(
            //                 children: [
            //                   Icon(Icons.auto_awesome, color: Color(0xFF2563EB),size:20),
            //                   SizedBox(width:10),
            //                   Text(
            //                     'Smart AI Categorization',
            //                     style: GoogleFonts.inter(
            //                       color: Color(0xFF2563EB),
            //                       fontWeight: FontWeight.bold,
            //                       fontSize: 14,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               Text(
            //                 'When you publish, AI will analyze your title and description to assign the right category automatically',
            //                 style: GoogleFonts.inter(
            //                   color: Color(0xFF2563EB),
            //                   fontSize: 13,
            //                   fontWeight: FontWeight.w500,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //         SizedBox(height:30),
            //         CustomElevatedButton(
            //             text: 'Analyse & Publish',
            //             onPressed: (){}
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
