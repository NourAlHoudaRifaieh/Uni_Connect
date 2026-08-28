import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/features/feed/presentation/widgets/category_selector.dart';
import 'package:uni_connect/features/feed/presentation/widgets/post_card.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/models/subject_model.dart';

class SubjectDetailsScreen extends StatefulWidget {

  final SubjectModel subject;

  SubjectDetailsScreen({
    super.key,
    required this.subject,
  });

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  // List <String> categories = ['All','Exams','General help', 'Programming', 'Assignments', 'Math','Physics'];
  String selectedCategory = 'All';

  List<String> get categories {
    final categorySet = <String>{'All'};
    for(var post in posts){
      final matchesSubject = post.subjectCode?.trim().toLowerCase() == widget.subject.subjectCode.trim().toLowerCase()
            || post.subjectId?.trim().toLowerCase() == widget.subject.subjectId!.trim().toLowerCase(); ;
      // final matchesSubject = post.subjectCode?.trim().toLowerCase() == widget.subject.subjectCode.trim().toLowerCase();
      if(matchesSubject && post.categoryName !=null && post.categoryName!.trim().isNotEmpty){
        categorySet.add(post.categoryName!.trim());
      }
    }
    return categorySet.toList();
  }

  List <PostModel> get posts => MockData.posts;
  List <PostModel> get _filteredPosts{
    return posts.where((post){
      final matchesSubject = post.subjectCode?.trim().toLowerCase() ==
          widget.subject.subjectCode.trim().toLowerCase() ||
          post.subjectId?.trim().toLowerCase() == widget.subject.subjectId!.trim().toLowerCase();
      // final matchesSubject = post.subjectCode?.trim().toLowerCase() == widget.subject.subjectCode.trim().toLowerCase();
      final matchesCategory = selectedCategory == 'All' || post.categoryName?.trim().toLowerCase() == selectedCategory.trim().toLowerCase();
      return matchesSubject && matchesCategory ;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final displayedPosts = _filteredPosts;
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
                  SizedBox(height:15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      SizedBox(width:10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.subject.subjectCode,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey.shade800
                            ),
                          ),
                          Text( widget.subject.subjectName,
                              style: GoogleFonts.inter(fontSize: 18, fontWeight:  FontWeight.bold)
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CategorySelector(
                categories: categories,
                onCategorySelected: (category){
                  setState(() {
                    selectedCategory = category;
                  });
                },
                selectedCategory: selectedCategory
            ),
            SizedBox(height:10),
            Expanded(
              child: displayedPosts.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width:70,
                      height:70,
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:  Icon(Icons.article_outlined , size:36, color: Color(0xFF9CA3AF)),
                    ),
                    SizedBox(height:16),
                    Text(
                      selectedCategory =='All' ? "No posts for this subject yet" : " No posts in $selectedCategory",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: displayedPosts.length,
                itemBuilder: (context, index) {
                  final post = displayedPosts[index];
                  return PostCard(
                    post: post,
                    onTap: () {
                      // will open post detail screen later
                    },
                    onLikeTap: (){},
                    onCommentTap: (){},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
