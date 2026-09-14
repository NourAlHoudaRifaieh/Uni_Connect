import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/features/feed/presentation/student/post_details_screen.dart';
import 'package:uni_connect/features/feed/presentation/widgets/category_selector.dart';

import '../../../../core/mock/mock_data.dart';
import '../../../../core/models/post_model.dart';
import '../widgets/post_card.dart';

class AdminPostsScreen extends StatefulWidget {

  final bool isStandalone;
  AdminPostsScreen({
    super.key,
    this.isStandalone = false,
  });

  @override
  _AdminPostsScreenState createState() {
    return _AdminPostsScreenState();
  }
}

class _AdminPostsScreenState extends State<AdminPostsScreen> {

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
  void initState() {
    super.initState();
    _searchController.addListener((){
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final displayedPosts = _filteredPosts;
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
                    Text('Manage Posts',
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
            CategorySelector(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (category){
                setState(() {
                  selectedCategory = category;
                });
              },
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
                    // onTap: () {
                    //   setState(() {
                    //   });
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
                    onLikeTap: (){
                      setState(() {

                      });
                    },
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