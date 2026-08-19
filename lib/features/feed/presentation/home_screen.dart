import 'package:flutter/material.dart';
import 'package:uni_connect/core/mock/mock_data.dart';
import 'package:uni_connect/core/models/post_model.dart';
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

  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'All';

  List<String> get categories {
    final categorySet = <String>{'All'};
    for(var post in posts){
      if(post.categoryName != null && post.categoryName!.trim().isNotEmpty){
        categorySet.add(post.categoryName!.trim());
      }
    }
    return categorySet.toList();
  }

  List <PostModel> get posts => MockData.posts;
  List <PostModel> get _filteredPosts{
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
    final displayedPosts = _filteredPosts;
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
                            Text('UniConnect', style: GoogleFonts.inter(fontSize:25, fontWeight: FontWeight.bold)),
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
                        backgroundColor:Color(0xFF1D61FF),
                        child: Text('NR', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold))
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
