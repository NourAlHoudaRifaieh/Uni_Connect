import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/mock/mock_data.dart';
import 'package:uni_connect/core/models/post_model.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import 'package:uni_connect/core/widgets/custom_form_field.dart';
import 'package:uni_connect/features/feed/presentation/student/post_details_screen.dart';
import 'package:uni_connect/features/feed/presentation/widgets/seach_post_card.dart';
import 'package:uni_connect/features/feed/presentation/widgets/search_student_card.dart';

import '../../../../core/models/user_model.dart';

class SearchScreen extends StatefulWidget{
  SearchScreen({super.key,});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchScreenState();
  }
  
}
class SearchScreenState extends State<SearchScreen>{

  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  List<PostModel> get posts => MockData.posts;
  List<UserModel> get students => MockData.students;


  @override
  void initState(){
    super.initState();
    _searchController.addListener((){
      setState(() {

      });
    });
  }

  @override
  void dispose(){
    _searchController.dispose();
    super.dispose();
  }

  List<PostModel> get _filteredPosts{
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return posts;
    
    return posts.where((post){
      final matchesTitle = post.title.toLowerCase().contains(query);
      final matchesDescription = post.description.toLowerCase().contains(query);
      final matchesSubject = post.subjectCode?.toLowerCase().contains(query) ?? false;
      final matchesCategory = post.categoryName?.toLowerCase().contains(query) ?? false;
      final matchesAuthor = post.authorName.toLowerCase().contains(query);

      return matchesTitle || matchesDescription || matchesSubject || matchesCategory || matchesAuthor;
    }).toList();
  }

  List <UserModel> get _filteredStudents{
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return students;
    return students.where((student){
      final matchesName = student.fullName.toLowerCase().contains(query);
      final matchesEmail = student.email.toLowerCase().contains(query);
      final matchesFaculty = student.faculty?.toLowerCase().contains(query);
      final matchesMajor = student.major?.toLowerCase().contains(query);

      return matchesName || matchesEmail || matchesFaculty! || matchesMajor!;
    }).toList();
  }


  @override
  Widget build(BuildContext context) {

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
                  Text('Search',
                      style: GoogleFonts.inter(fontSize: 22, fontWeight:  FontWeight.bold)
                  ),
                  SizedBox(height:10),
                  CustomFormField(
                      hint: _selectedIndex ==0 ? 'Search posts...' : 'Search students by name...',
                      controller: _searchController,
                      prefixIcon: Icon(Icons.search,
                          color: Color(0xFFB5B5C3)
                      ),
                      validator: (value) => value!.isEmpty ? 'Cannot be empty' : null,
                  ),
                  SizedBox(height:10),
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                            height:50,
                            child: CustomElevatedButton(
                                selected: _selectedIndex==0,
                                text: 'Posts',
                                type: _selectedIndex == 0 ? ButtonType.elevated : ButtonType.outlined,
                                onPressed: (){
                                  setState(() {
                                    _selectedIndex =0;
                                  });
                                },
                            ),
                          ),
                      ),
                      SizedBox(width:10),
                      Expanded(
                          child: SizedBox(
                            height:50,
                            child: CustomElevatedButton(
                              selected: _selectedIndex==1,
                              text: 'Students',
                              type: _selectedIndex == 1 ? ButtonType.elevated : ButtonType.outlined,
                              onPressed: (){
                                setState(() {
                                  _selectedIndex =1;
                                });
                              },
                            ),
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
                child: _selectedIndex ==0
                ?(_filteredPosts.isEmpty
                    ? Center(
                      child: Text(
                        'No results found',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _filteredPosts.length,
                        itemBuilder: (context, index) {
                          final post = _filteredPosts[index];
                          return SearchPostCard(
                            post: post,
                            onTap: () async {
                              final currentPost = MockData.posts.firstWhere(
                                    (p) => p.postId == post.postId,
                                orElse: () => post,
                              );
                             await  Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=> PostDetailsScreen(post: post)),
                            );
                             setState(() {

                             });
                            }
                          );
                        },
                    )
                )
                : (_filteredStudents.isEmpty
                    ? Center(
                      child: Text(
                        'No results found',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _filteredStudents.length,
                      itemBuilder: (context, index) {
                        return SearchStudentCard(
                          user: _filteredStudents[index],
                        );
                      },
                    )
                ),
            ),
          ],
        ),
      ),
    );
  }
  
}