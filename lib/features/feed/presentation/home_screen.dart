import 'package:flutter/material.dart';
import 'package:uni_connect/core/widgets/custom_form_field.dart';
import 'package:uni_connect/features/feed/presentation/widgets/category_selector.dart';
import 'widgets/post_card.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
  @override
  State <HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State <HomeScreen>{

  // final int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  List <String> categories = ['All','Exams','General help', 'Programming', 'Assignments', 'Math','Physics'];
  String selectedCategory = 'All';

  final List<PostCardData> posts =[
    PostCardData(
        title: 'Database Normalization - Final Exam Tips',
        authorInitials: 'AK',
        authorName: 'Ahmad Khoury',
        avatarColor: Colors.deepPurple,
        category: 'Exams',
        categoryColor: Colors.purple,
        comments: 2,
        likes: 24,
        preview: 'Hey everyone! The final exam is next week. Professor Hajj mentioned that 3NF will be heavily testes...',
        subjectCode: 'DB201',
        timeAgo: '3h ago'
    ),
    PostCardData(
        title: 'Python  — Inheritance Pattern for AI Assignment',
        authorInitials: 'RF',
        authorName: 'Hani Farhat',
        avatarColor: Colors.orange,
        category: 'Programming',
        categoryColor: Colors.green,
        comments: 1,
        likes: 14,
        preview: 'For the AI assignment I structured my neural network using Python inheritance: Layer → DenseLayer...',
        subjectCode: 'DB135',
        timeAgo: '2d ago'
    ),
    PostCardData(
        title: 'Assignment 3 - ER Diagram help Needed',
        authorInitials: 'LH',
        authorName: 'Lara Haddad',
        avatarColor: Colors.pink,
        category: 'Assignments',
        categoryColor: Colors.blue,
        comments: 1,
        likes: 7,
        preview: "I'm stuck on the ER Diagram Help Needed",
        subjectCode: 'D109',
        timeAgo: '2h ago'
    ),
    PostCardData(
        title: 'Python OOP — Inheritance Pattern for AI Assignment',
        authorInitials: 'RF',
        authorName: 'Rami Farhat',
        avatarColor: Colors.green,
        category: 'Programming',
        categoryColor: Colors.teal,
        comments: 2,
        likes: 24,
        preview: 'For the AI assignment I structured my neural network using Python inheritance: Layer → DenseLayer...',
        subjectCode: 'DB105',
        timeAgo: '1d ago'
    ),
  ];

  List <PostCardData> get _filteredPosts{
    final query = _searchController.text.trim().toLowerCase();

    return posts.where((post){
      final matchesCategory = selectedCategory == 'All' || post.category == selectedCategory;
      final matchesSearch = query.isEmpty ||
            post.title.toLowerCase().contains(query) ||
            post.preview.toLowerCase().contains(query) ||
            post.subjectCode.toLowerCase().contains(query) ||
            post.category.toLowerCase().contains(query) ||
            post.authorName.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _onCreatePost(){
    showModalBottomSheet(
        context: context,
        builder: (context) =>
          SizedBox(
            height:200,
            child: Center(
              child: Text('New Page'),
            ),
          ),
        );
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
    // final filteredPosts = selectedCategory == 'All'
    //     ? posts
    //     : posts.where((p) => p.category == selectedCategory).toList();
    final displaydPosts = _filteredPosts;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:Column(
          children: [
            // for top header
            Padding(
              padding: EdgeInsets.fromLTRB(20,40,20,10),
              child: Column(
                children: [
                  Row(
                    children:[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Good day, nour! ', style: GoogleFonts.inter(fontSize:25, fontWeight: FontWeight.bold)),
                            Text('Business Administration, Master 2', style: GoogleFonts.inter(fontSize:15, color: Colors.grey)),
                          ],
                        ),
                      ),
                      //Notification Bell
                      Stack(
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
                      SizedBox(width:10),
                      //User Avatar
                      CircleAvatar(
                        radius:20,
                        backgroundColor:Colors.deepPurple,
                        child: Text('N', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold))
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
              child: displaydPosts.isEmpty
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
                        _searchController.text.trim().isEmpty ? 'No results found for ${_searchController.text.trim()}' : 'No posts in this category',
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
                  itemCount: displaydPosts.length,
                  itemBuilder: (context, index) {
                    return PostCard(
                      data: displaydPosts[index],
                      onTap: () {
                        // will open post detail screen later
                      },
                    );
                  },
                ),
            ),
            // Expanded(
            //   child: ListView.builder(
            //     padding: const EdgeInsets.symmetric(horizontal: 20),
            //     itemCount: _filteredPosts.length,
            //     itemBuilder: (context, index) {
            //       return PostCard(
            //         data: _filteredPosts[index],
            //         onTap: () {
            //           // will open post detail screen later
            //         },
            //       );
            //     },
            //   ),
            // ),
              // Expanded(
              //   child: filteredPosts.isEmpty
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
              //           'No posts in this category',
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
              //     itemCount: filteredPosts.length,
              //     itemBuilder: (context, index) {
              //       return PostCard(
              //         data: filteredPosts[index],
              //         onTap: () {
              //           // will open post detail screen later
              //         },
              //       );
              //     },
              //   ),
              // ),
          ],
        ),
      ),
      // bottomNavigationBar: CustomBottomNavBar(
      //     currentIndex: _currentIndex,
      //     onTap: (index){
      //       setState(() {
      //         _currentIndex = index;
      //       });
      //     },
      //     onCreatePost: _onCreatePost
      // ),
    );
  }
}
