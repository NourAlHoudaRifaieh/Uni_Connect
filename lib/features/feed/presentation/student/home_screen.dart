import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uni_connect/core/mock/mock_data.dart';
import 'package:uni_connect/core/models/post_model.dart';
import 'package:uni_connect/core/widgets/custom_form_field.dart';
import 'package:uni_connect/features/auth/data/post_repository.dart';
import 'package:uni_connect/features/auth/data/user_repository.dart';
import 'package:uni_connect/features/feed/presentation/student/create_post_screen.dart';
import 'package:uni_connect/features/feed/presentation/student/notification_screen.dart';
import 'package:uni_connect/features/feed/presentation/student/post_details_screen.dart';
import 'package:uni_connect/features/feed/presentation/student/profile_screen.dart';
import 'package:uni_connect/features/feed/presentation/widgets/category_selector.dart';
import '../../../../core/models/user_model.dart';
import '../widgets/post_card.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
  @override
  State <HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State <HomeScreen>{

  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'All';
  final PostRepository _postRepository = PostRepository();
  final UserRepository _userRepository = UserRepository();

  List<String> _getCategories(List <PostModel> posts) {
    final categorySet = <String>{'All'};
    for(var post in posts){
      if(post.categoryName != null && post.categoryName!.trim().isNotEmpty){
        categorySet.add(post.categoryName!.trim());
      }
    }
    return categorySet.toList();
  }

  // List <PostModel> get posts => MockData.posts;
  List <PostModel>  _getFilteredPosts(List<PostModel> posts){
    final query = _searchController.text.trim().toLowerCase();

    return posts.where((post){
      final matchesCategory = selectedCategory == 'All' || post.categoryName?.trim().toLowerCase() == selectedCategory.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          post.title.toLowerCase().contains(query) ||
          post.description.toLowerCase().contains(query) ||
          (post.subjectCode?.toLowerCase().contains(query) ?? false)||
          (post.categoryName?.toLowerCase().contains(query) ?? false)||
          post.authorName.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

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

  @override
  Widget build(BuildContext context){
    // final displayedPosts = _filteredPosts;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<List<PostModel>>(
            stream: _postRepository.watchAllPosts(),
            builder: (context, postSnapshot){
              if(!postSnapshot.hasData && postSnapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(postSnapshot.hasError){
                return Center(
                  child: Text('Error: ${postSnapshot.error}'),
                );
              }
              final posts = postSnapshot.data ?? [];
              final categories = _getCategories(posts);
              final displayedPosts = _getFilteredPosts(posts);

              return Column(
                children: [
                  // for top header
                  Padding(
                    // padding: EdgeInsets.fromLTRB(20,40,20,10),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children:[
                            Expanded(
                              child: StreamBuilder <UserModel?>(
                                stream: _userRepository.watchCurrentUser(),
                                builder: (context, userSnapshot){
                                  final userModel = userSnapshot.data;
                                  final faculty = userModel?.faculty ?? '';
                                  final academicYear = userModel?.academicYear ?? '';
                                  final departmentText = faculty.isNotEmpty && academicYear.isNotEmpty
                                      ? '$faculty, $academicYear'
                                      : (faculty.isNotEmpty
                                        ? faculty
                                        : (academicYear.isNotEmpty
                                          ? academicYear
                                          : (userModel?.major ?? 'Business Administration')));

                                  return  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('UniConnect', style: GoogleFonts.inter(fontSize:25, fontWeight: FontWeight.bold)),
                                      Text(departmentText, style: GoogleFonts.inter(fontSize:15, color: Colors.grey)),
                                    ],
                                  );
                                },
                              ),
                              // child: Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Text('UniConnect', style: GoogleFonts.inter(fontSize:25, fontWeight: FontWeight.bold)),
                              //     Text('Business Administration, Master 2', style: GoogleFonts.inter(fontSize:15, color: Colors.grey)),
                              //   ],
                              // ),
                            ),
                            //Notification Bell
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context)=> NotificationScreen()),
                                );
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width:40,
                                    height:40,
                                    decoration:BoxDecoration(
                                      color: Color(0xFFF3F4F6),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all( color: Color(0xFFF3F4F6)),
                                    ),
                                    child: Icon(Icons.notifications_none, color: Colors.black54, size:25),
                                  ),
                                  Positioned(
                                    top:-8,
                                    right: -4,
                                    child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle
                                        ),
                                        child: Text('3', style:GoogleFonts.inter(color:Colors.white, fontSize:15))
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Stack(
                            //   clipBehavior: Clip.none,
                            //   children: [
                            //     Container(
                            //       width:40,
                            //       height:40,
                            //       decoration:BoxDecoration(
                            //         color: Color(0xFFF3F4F6),
                            //         borderRadius: BorderRadius.circular(20),
                            //         border: Border.all( color: Color(0xFFF3F4F6)),
                            //       ),
                            //       child: Icon(Icons.notifications_none, color: Colors.black54, size:25),
                            //     ),
                            //     Positioned(
                            //       top:-8,
                            //       right: -4,
                            //       child: Container(
                            //         padding: const EdgeInsets.all(4),
                            //         decoration: BoxDecoration(
                            //           color: Colors.red,
                            //           shape: BoxShape.circle
                            //         ),
                            //         child: Text('3', style:GoogleFonts.inter(color:Colors.white, fontSize:15))
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            SizedBox(width:10),
                            //User Avatar
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context)=> ProfileScreen(),
                                  ),
                                );
                              },
                              child: StreamBuilder<UserModel?>(
                                stream: _userRepository.watchCurrentUser(),
                                builder: (context, userSnapshot){
                                  final initials = userSnapshot.data?.authorInitials.isNotEmpty == true
                                      ? userSnapshot.data!.authorInitials
                                      : 'U';
                                  return  CircleAvatar(
                                      radius:20,
                                      backgroundColor:Color(0xFF1D61FF),
                                      child: Text( initials, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold))
                                  );
                                }
                              ),
                              // child: CircleAvatar(
                              //     radius:20,
                              //     backgroundColor:Color(0xFF1D61FF),
                              //     child: Text('NR', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold))
                              // ),
                            ),
                          ],
                        ),
                        SizedBox(height:8),
                        // Search Bar
                        CustomFormField(
                            hint: 'Search posts, students...',
                            controller: _searchController,
                            prefixIcon: Icon(Icons.search,
                              color: Color(0xFFB5B5C3),
                            ),
                            validator: (value) =>
                            value!.isEmpty ? 'Cannot be empty' : null
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
                              _searchController.text.trim().isNotEmpty
                                  ? 'No results found for "${_searchController.text.trim()}"'
                                  : (selectedCategory == 'All' ? 'No posts found' : 'No posts in $selectedCategory'),
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
                          // return PostCard(
                          //   post: post,
                          //   onTap: () {
                          //     setState(() {
                          //     });
                          //     // will open post detail screen later
                          //   },
                          //   onLikeTap: (){
                          //     setState(() {
                          //
                          //     });
                          //   },
                          //   onCommentTap: (){},
                          // );
                          return PostCard(
                            post: post,
                            // onTap: () {
                            //   // will open post detail screen later
                            // },
                            onTap: () async{
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PostDetailsScreen(post: post))
                              );
                              if(mounted){
                                setState(() {

                                });
                              }
                            },
                            onLikeTap: () async{
                              final currentUser = FirebaseAuth.instance.currentUser;
                              if(currentUser == null || post.postId == null) return;
                              final userModel = await _userRepository.getUserById(currentUser.uid);
                              final userName = userModel?.fullName.trim().isNotEmpty == true
                                  ? userModel!.fullName.trim()
                                  : (currentUser.displayName != null && currentUser.displayName!.trim().isNotEmpty
                                      ? currentUser.displayName!.trim()
                                      : (currentUser.email != null
                                          ? currentUser.email!.split('@').first
                                          : 'User'));
                              // final userName = currentUser.displayName ?? currentUser.email?.split('@').first ?? 'User';
                              await _postRepository.toggleLike(
                                  post.postId!,
                                  currentUser.uid,
                                  userName,
                              );
                            },
                            onCommentTap: () async{
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PostDetailsScreen(post: post)),
                              );
                              if(mounted){
                                setState(() {

                                });
                              }
                            },
                          );
                        },
                      ),
                  ),
                ],
              );
            }
        ),

      ),
    );
  }
}
