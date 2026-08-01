import 'package:flutter/material.dart';
import 'package:uni_connect/core/widgets/custom_form_field.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatefulWidget{
  HomeScreen({Key? key}): super(key:key);
  @override
  State <HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State <HomeScreen>{

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
            Padding(
              padding: EdgeInsets.symmetric(horizontal:20, vertical:15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children:[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const[
                            Text('Good day, nour! ', style: TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
                            Text('Business Administration, Master 2', style: TextStyle(fontSize:12, color: Colors.grey)),
                          ],
                        ),
                      ),
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
                            child: Icon(Icons.notifications_none, color: Colors.black54),
                          ),
                          Positioned(
                            top:-2,
                            right: -2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle
                              ),
                              child: Text('3', style:TextStyle(color:Colors.white, fontSize:12))
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width:10),
                      CircleAvatar(
                        radius:20,
                        backgroundColor:Colors.deepPurple,
                        child: Text('N', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                      ),
                    ],
                  ),
                  SizedBox(height:16),
                  CustomFormField(
                      hint: 'Search posts, students...',
                      controller: _searchController,
                      prefixIcon: Icon(Icons.search),
                      validator: (value) =>
                          value!.isEmpty ? 'Cannot be empty' : null
                  ),
                  // SizedBox(height:14),


                ],
              ),
            ),
            Divider(
              color:Colors.grey,
              thickness: 1,
              // indent:10,
              // endIndent: 10,
            ),
            SizedBox(height:4),
            SizedBox(
              height:32,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal:20),
                // physics: BouncingScrollPhysics(),
                itemCount: categories.length,
                // separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index){
                  String cat = categories[index];
                  bool isSelected = cat == selectedCategory;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = cat;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right:8),
                      padding: EdgeInsets.symmetric(horizontal:20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFF2563EB) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Color(0xFF2563EB) : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize:13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height:4),

            Divider(
              color:Colors.grey,
              thickness: 1,
              // indent:10,
              // endIndent: 10,
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
            SizedBox(height:10),
          ],
        ),
      ),
    );
  }
}
