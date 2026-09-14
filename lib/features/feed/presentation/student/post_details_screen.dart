import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/features/feed/presentation/widgets/comment_card.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/models/reply_model.dart';
import '../../../../core/models/subject_model.dart';
import '../../widgets/comment_card.dart';

class PostDetailsScreen extends StatefulWidget {
  final PostModel post;

  const PostDetailsScreen({
    super.key,
    required this.post,
  });

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  late List<ReplyModel> _replies;
  late bool _isLiked;
  late int _likeCount;

  //Whoever's currently logged in
  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    // Load initial replies filtered by current postId
    _replies = MockData.replies
        .where((reply) => reply.postId == widget.post.postId)
        .toList();
    //Inilize like state from post widgt
    _isLiked = widget.post.isLikedBy(_currentUserId);
    _likeCount = widget.post.likes;
  }

  void _toggleLike(){
    if(widget.post.postId == null || _currentUserId.isEmpty) return;

    //Update central state first
    MockData.toggleLike(widget.post.postId!, _currentUserId);

    setState(() {
      _isLiked = !_isLiked;
      if(_isLiked){
        _likeCount++ ;
      }else{
        _likeCount--;
      }
    });
  }

  SubjectModel? _getSubject(String? subjectId) {
    if (subjectId == null || subjectId.isEmpty) return null;
    try {
      return MockData.subjects.firstWhere(
            (subject) => subject.subjectId == subjectId,
      );
    } catch (_) {
      return null;
    }
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    // get current logged-in user details 
    final currentUser = FirebaseAuth.instance.currentUser;
    final authorName = currentUser?.displayName ?? currentUser?.email?.split('@').first ?? 'User';

    final newReply = ReplyModel(
      replyId: 'reply_${DateTime.now().millisecondsSinceEpoch}',
      postId: widget.post.postId ?? '',
      authorName: authorName,
      content: text,
      createdAt: DateTime.now(),
      userId: _currentUserId,
    );
    //Save reply to MockData
    MockData.addReply(newReply);
    //Update the post comment counter inside MockData feed list
    if(widget.post.postId != null){
      try{
        final postIndex = MockData.posts.indexWhere((p) => p.postId == widget.post.postId);
        if(postIndex != -1){
          final currentPost = MockData.posts[postIndex];
          MockData.posts[postIndex] = currentPost.copyWith(
            comments: currentPost.comments + 1,
          );
        }
      }catch(_){
        
      }
    }
    
    setState(() {
      _replies.add(newReply);
      _commentController.clear();
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final subject = _getSubject(post.subjectId);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Container
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.chevron_left,
                                  color: Color(0xFF2563EB),
                                  size: 20,
                                ),
                                Text(
                                  'Back',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF2563EB),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Badges Row
                          Row(
                            children: [
                              if (post.categoryName != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1D61FF).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    post.categoryName!,
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF1D61FF),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              if (subject != null) ...[
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1D61FF),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    subject.subjectName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 15),

                          // Post Title
                          Text(
                            post.title,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Author Info Row
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: const Color(0xFF1D61FF),
                                child: Text(
                                  post.authorInitials,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.authorName,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          post.timeAgo,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        if (post.subjectCode != null &&
                                            post.subjectCode!.isNotEmpty) ...[
                                          Text(
                                            ' • ',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          Text(
                                            post.subjectCode!,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      height: 1.5,
                      width: double.infinity,
                      color: const Color(0xFFF1F5F9),
                    ),
                    SizedBox(height: 10),

                    // Main Post Card (Full description)
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.description,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              height: 1.5,
                              color: Color(0xFF334155),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color:  Color(0xFFF1F5F9),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: _toggleLike,
                                behavior: HitTestBehavior.opaque,
                                child: Row(
                                  children: [
                                    Icon(
                                      _isLiked ?Icons.favorite : Icons.favorite_border,
                                      size: 16,
                                     color: _isLiked ? Colors.red : Colors.grey.shade600,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '$_likeCount Likes',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: _isLiked ? FontWeight.w600 : FontWeight.normal,
                                        color: _isLiked ? Colors.red : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.mode_comment_outlined,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '${_replies.length} Comments',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),

                    // Comments Title Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Text(
                        'Comments (${_replies.length})',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF475569),
                        ),
                      ),
                    ),

                    // Comments List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _replies.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return CommentCard(reply: _replies[index]);
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Fixed Comment Input Bar
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFEF4444),
                    child: Text(
                      'NR',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _addComment(),
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.grey.shade500,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _addComment,
                            child: const Icon(
                              Icons.send_rounded,
                              size: 18,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}