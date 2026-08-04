import 'package:flutter/material.dart';
import 'package:uni_connect/core/widgets/custom_bottom_nav_bar.dart';
import 'package:uni_connect/core/widgets/custom_form_field.dart';
import 'package:uni_connect/features/feed/presentation/widgets/category_selector.dart';
import 'widgets/post_card.dart';

class HomeScreen extends StatefulWidget{
  HomeScreen({Key? key}): super(key:key);
  @override
  State <HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State <HomeScreen>{

  int _currentIndex = 0;
  TextEditingController _searchController = TextEditingController();
  List <String> categories = ['All','Exams','General help', 'Programming', 'Assignments', 'Math','Physics'];
  String selectedCategory = 'All';

  final List<PostCardData> posts =[
    PostCardData(
        title: 'DataBase Normalization - Final Exam Tips',
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
  Widget build(BuildContext context){
    final filteredPosts = selectedCategory == 'All'
        ? posts
        : posts.where((p) => p.category == selectedCategory).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:Column(
          children: [
            // for top header
            Padding(
              padding: EdgeInsets.fromLTRB(20,40,20,8),
              child: Column(
                children: [
                  Row(
                    children:[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const[
                            Text('Good day, nour! ', style: TextStyle(fontSize:22, fontWeight: FontWeight.bold)),
                            Text('Business Administration, Master 2', style: TextStyle(fontSize:13, color: Colors.grey)),
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
                            child: Icon(Icons.notifications_none, color: Colors.black54, size:22),
                          ),
                          Positioned(
                            top:0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle
                              ),
                              child: Text('3', style:TextStyle(color:Colors.white, fontSize:10))
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width:10),
                      //User Avatar
                      CircleAvatar(
                        radius:20,
                        backgroundColor:Colors.deepPurple,
                        child: Text('N', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filteredPosts.length,
                itemBuilder: (context, index) {
                  return PostCard(
                    data: filteredPosts[index],
                    onTap: () {
                      // will open post detail screen later
                    },
                  );
                },
              ),
            ),
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
