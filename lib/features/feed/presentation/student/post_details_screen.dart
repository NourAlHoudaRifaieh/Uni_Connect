import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/features/auth/data/post_repository.dart';
import 'package:uni_connect/features/auth/data/reply_repository.dart';
import 'package:uni_connect/features/auth/data/subject_repository.dart';
import 'package:uni_connect/features/auth/data/user_repository.dart';
import 'package:uni_connect/features/feed/widgets/comment_card.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/models/reply_model.dart';
import '../../../../core/models/subject_model.dart';

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
  final PostRepository _postRepository = PostRepository();
  final ReplyRepository _replyRepository = ReplyRepository();
  final SubjectRepository _subjectRepository = SubjectRepository();
  final UserRepository _userRepository = UserRepository();

  // late List<ReplyModel> _replies;
  // late bool _isLiked;
  // late int _likeCount;

  //Whoever's currently logged in
  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  // void _toggleLike() async{
  //   if(widget.post.postId == null || _currentUserId.isEmpty) return;
  //   await _postRepository.toggleLike(widget.post.postId!, _currentUserId);
  // }
  // void _toggleLike() async {
  //   if (widget.post.postId == null || _currentUserId.isEmpty) return;
  //
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   final username = currentUser?.displayName ?? currentUser?.email?.split('@').first ?? 'User';
  //
  //   await _postRepository.toggleLike(widget.post.postId!, _currentUserId, username);
  // }

  void _toggleLike() async {
    if (widget.post.postId == null || _currentUserId.isEmpty) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser == null) return;

    final userModel = await _userRepository.getUserById(currentUser.uid);
    final userName = userModel?.fullName.trim().isNotEmpty == true
      ? userModel!.fullName.trim()
      : (currentUser.displayName != null && currentUser.displayName!.trim().isNotEmpty
          ? currentUser.displayName!.trim()
          : (currentUser.email != null
              ? currentUser.email!.split('@').first
              : 'User'));
    await _postRepository.toggleLike(widget.post.postId!, _currentUserId, userName);
  }

  void _addComment() async{
    final text = _commentController.text.trim();

    // print('--- ATTEMPTING TO ADD COMMENT ---');
    // print('Post ID: ${widget.post.postId}');
    // print('Comment Text: $text');
    // print('User ID: $_currentUserId');

    if (text.isEmpty || widget.post.postId == null || widget.post.postId!.isEmpty) {
      // print('ERROR: Cannot add comment because text is empty or postId is missing!');
      return;
    }
    // if(text.isEmpty || widget.post.postId == null) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    // final authorName = currentUser?.displayName ?? currentUser?.email?.split('@').first ?? 'User';
    final authorName = (currentUser?.displayName != null && currentUser!.displayName!.isNotEmpty)
        ? currentUser.displayName!
        : (currentUser?.email != null ? currentUser!.email!.split('@').first : 'User');
    final newReply = ReplyModel(
        replyId: 'reply_${DateTime.now().millisecondsSinceEpoch}',
        postId: widget.post.postId!,
        userId: _currentUserId,
        authorName: authorName,
        content: text,
        createdAt: DateTime.now(),
    );

    //Save reply to Firestore & increment comment count
    await _replyRepository.addReply(postId: widget.post.postId!, reply: newReply);

    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // Load initial replies filtered by current postId
  //   _replies = MockData.replies
  //       .where((reply) => reply.postId == widget.post.postId)
  //       .toList();
  //   //Inilize like state from post widgt
  //   _isLiked = widget.post.isLikedBy(_currentUserId);
  //   _likeCount = widget.post.likes;
  // }
  //
  // void _toggleLike(){
  //   if(widget.post.postId == null || _currentUserId.isEmpty) return;
  //
  //   //Update central state first
  //   MockData.toggleLike(widget.post.postId!, _currentUserId);
  //
  //   setState(() {
  //     _isLiked = !_isLiked;
  //     if(_isLiked){
  //       _likeCount++ ;
  //     }else{
  //       _likeCount--;
  //     }
  //   });
  // }
  //
  // SubjectModel? _getSubject(String? subjectId) {
  //   if (subjectId == null || subjectId.isEmpty) return null;
  //   try {
  //     return MockData.subjects.firstWhere(
  //           (subject) => subject.subjectId == subjectId,
  //     );
  //   } catch (_) {
  //     return null;
  //   }
  // }
  //
  // void _addComment() {
  //   final text = _commentController.text.trim();
  //   if (text.isEmpty) return;
  //   // get current logged-in user details
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   final authorName = currentUser?.displayName ?? currentUser?.email?.split('@').first ?? 'User';
  //
  //   final newReply = ReplyModel(
  //     replyId: 'reply_${DateTime.now().millisecondsSinceEpoch}',
  //     postId: widget.post.postId ?? '',
  //     authorName: authorName,
  //     content: text,
  //     createdAt: DateTime.now(),
  //     userId: _currentUserId,
  //   );
  //   //Save reply to MockData
  //   MockData.addReply(newReply);
  //   //Update the post comment counter inside MockData feed list
  //   if(widget.post.postId != null){
  //     try{
  //       final postIndex = MockData.posts.indexWhere((p) => p.postId == widget.post.postId);
  //       if(postIndex != -1){
  //         final currentPost = MockData.posts[postIndex];
  //         MockData.posts[postIndex] = currentPost.copyWith(
  //           comments: currentPost.comments + 1,
  //         );
  //       }
  //     }catch(_){
  //
  //     }
  //   }
  //
  //   setState(() {
  //     _replies.add(newReply);
  //     _commentController.clear();
  //   });
  // }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    // final subject = _getSubject(post.subjectId);

    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserName = currentUser?.displayName ?? currentUser?.email ?? 'User';
    final currentInitials = currentUserName.isNotEmpty
      ? currentUserName.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
      : 'U';
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
                          StreamBuilder<List<SubjectModel>>(
                            stream: _subjectRepository.watchAllSubjects(),
                            builder: (context, subjectSnapshot){
                              SubjectModel? subject;
                              if(subjectSnapshot.hasData && post.subjectId != null){
                                try{
                                  subject = subjectSnapshot.data!.firstWhere(
                                      (s)=> s.subjectId == post.subjectId,
                                  );
                                } catch(_){
                                  subject = null;
                                }
                              }
                              return Row(
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
                              );
                            }
                          ),
                          // Badges Row
                          // Row(
                          //   children: [
                          //     if (post.categoryName != null) ...[
                          //       Container(
                          //         padding: const EdgeInsets.symmetric(
                          //           horizontal: 10,
                          //           vertical: 4,
                          //         ),
                          //         decoration: BoxDecoration(
                          //           color: const Color(0xFF1D61FF).withOpacity(0.15),
                          //           borderRadius: BorderRadius.circular(20),
                          //         ),
                          //         child: Text(
                          //           post.categoryName!,
                          //           style: GoogleFonts.inter(
                          //             color: const Color(0xFF1D61FF),
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 13,
                          //           ),
                          //           maxLines: 1,
                          //           overflow: TextOverflow.ellipsis,
                          //         ),
                          //       ),
                          //       const SizedBox(width: 8),
                          //     ],
                          //     if (subject != null) ...[
                          //       Container(
                          //         width: 6,
                          //         height: 6,
                          //         decoration: const BoxDecoration(
                          //           color: Color(0xFF1D61FF),
                          //           shape: BoxShape.circle,
                          //         ),
                          //       ),
                          //       const SizedBox(width: 6),
                          //       Flexible(
                          //         child: Text(
                          //           subject.subjectName,
                          //           maxLines: 1,
                          //           overflow: TextOverflow.ellipsis,
                          //           style: GoogleFonts.inter(
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 13,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ],
                          // ),
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
                    StreamBuilder<PostModel?>(
                        stream: post.postId != null
                          ? _postRepository.watchPostById(post.postId!)
                          : Stream.value(post),
                        builder: (context, postSnapshot){
                          final currentPost = postSnapshot.data ?? post;
                          final isLiked = currentPost.isLikedBy(_currentUserId);
                          final likeCount = currentPost.likes;

                          return Container(
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
                                            isLiked ?Icons.favorite : Icons.favorite_border,
                                            size: 16,
                                            color: isLiked ? Colors.red : Colors.grey.shade600,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            '$likeCount Likes',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: isLiked ? FontWeight.w600 : FontWeight.normal,
                                              color: isLiked ? Colors.red : Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    StreamBuilder<List<ReplyModel>>(
                                        stream: _replyRepository.watchRepliesForPost(post.postId ?? ''),
                                        builder: (context, replyCountSnapshot){
                                          final replyCount = replyCountSnapshot.data?.length ?? currentPost.comments;
                                          return Row(
                                            children: [
                                              Icon(
                                                Icons.mode_comment_outlined,
                                                size: 16,
                                                color: Colors.grey.shade600,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                '$replyCount Comments',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Icon(
                                    //       Icons.mode_comment_outlined,
                                    //       size: 16,
                                    //       color: Colors.grey.shade600,
                                    //     ),
                                    //     SizedBox(width: 4),
                                    //     Text(
                                    //       '${_replies.length} Comments',
                                    //       style: TextStyle(
                                    //         fontSize: 12,
                                    //         color: Colors.grey.shade600,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),

                              ],
                            ),
                          );
                        }
                    ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(
                    //     horizontal: 20,
                    //     vertical: 10,
                    //   ),
                    //   padding: EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(20),
                    //     border: Border.all(color: Colors.grey.shade200),
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         post.description,
                    //         style: GoogleFonts.inter(
                    //           fontSize: 14,
                    //           height: 1.5,
                    //           color: Color(0xFF334155),
                    //         ),
                    //       ),
                    //       SizedBox(height: 16),
                    //       Container(
                    //         height: 1,
                    //         width: double.infinity,
                    //         color:  Color(0xFFF1F5F9),
                    //       ),
                    //       SizedBox(height: 12),
                    //       Row(
                    //         children: [
                    //           GestureDetector(
                    //             onTap: _toggleLike,
                    //             behavior: HitTestBehavior.opaque,
                    //             child: Row(
                    //               children: [
                    //                 Icon(
                    //                   _isLiked ?Icons.favorite : Icons.favorite_border,
                    //                   size: 16,
                    //                  color: _isLiked ? Colors.red : Colors.grey.shade600,
                    //                 ),
                    //                 SizedBox(width: 4),
                    //                 Text(
                    //                   '$_likeCount Likes',
                    //                   style: TextStyle(
                    //                     fontSize: 12,
                    //                     fontWeight: _isLiked ? FontWeight.w600 : FontWeight.normal,
                    //                     color: _isLiked ? Colors.red : Colors.grey.shade600,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           SizedBox(width: 16),
                    //           Row(
                    //             children: [
                    //               Icon(
                    //                 Icons.mode_comment_outlined,
                    //                 size: 16,
                    //                 color: Colors.grey.shade600,
                    //               ),
                    //               SizedBox(width: 4),
                    //               Text(
                    //                 '${_replies.length} Comments',
                    //                 style: TextStyle(
                    //                   fontSize: 12,
                    //                   color: Colors.grey.shade600,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //
                    //     ],
                    //   ),
                    // ),

                    // Comments Title Header
                    StreamBuilder<List<ReplyModel>>(
                        stream: _replyRepository.watchRepliesForPost(post.postId ?? ''),
                        builder: (context, snapshot){

                          print('Stream connection state: ${snapshot.connectionState}');
                          print('Stream has error: ${snapshot.error}');
                          print('Replies count received from stream: ${snapshot.data?.length ?? 0}');

                          final replies = snapshot.data ?? [];
                          return Column(
                            crossAxisAlignment:  CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                child: Text(
                                  'Comments (${replies.length})',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF475569),
                                  ),
                                ),
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: replies.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  return CommentCard(reply: replies[index]);
                                },
                              ),
                            ],
                          );
                        },
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 20,
                    //     vertical: 8,
                    //   ),
                    //   child: Text(
                    //     'Comments (${_replies.length})',
                    //     style: GoogleFonts.inter(
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.bold,
                    //       color: const Color(0xFF475569),
                    //     ),
                    //   ),
                    // ),

                    // Comments List
                    // ListView.separated(
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemCount: _replies.length,
                    //   separatorBuilder: (_, __) => const SizedBox(height: 10),
                    //   itemBuilder: (context, index) {
                    //     return CommentCard(reply: _replies[index]);
                    //   },
                    // ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Fixed Comment Input Bar
            // Container(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 16,
            //     vertical: 10,
            //   ),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     border: Border(
            //       top: BorderSide(color: Color(0xFFE2E8F0)),
            //     ),
            //   ),
            //   child: Row(
            //     children: [
            //       CircleAvatar(
            //         radius: 16,
            //         backgroundColor: Color(0xFF1D61FF),
            //         child: Text(
            //           currentInitials,
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 12,
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 10),
            //       Expanded(
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(horizontal: 14),
            //           decoration: BoxDecoration(
            //             color: const Color(0xFFF1F5F9),
            //             borderRadius: BorderRadius.circular(24),
            //           ),
            //           child: Row(
            //             children: [
            //               Expanded(
            //                 child: TextField(
            //                   controller: _commentController,
            //                   textInputAction: TextInputAction.send,
            //                   onSubmitted: (_) => _addComment(),
            //                   decoration: InputDecoration(
            //                     hintText: 'Add a comment...',
            //                     hintStyle: GoogleFonts.inter(
            //                       fontSize: 13,
            //                       color: Colors.grey.shade500,
            //                     ),
            //                     border: InputBorder.none,
            //                     isDense: true,
            //                     contentPadding: const EdgeInsets.symmetric(
            //                       vertical: 10,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               GestureDetector(
            //                 onTap: _addComment,
            //                 child: const Icon(
            //                   Icons.send_rounded,
            //                   size: 18,
            //                   color: Color(0xFF2563EB),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
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
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFF1D61FF),
                    child: Text(
                      currentInitials,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _addComment,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1D61FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 16,
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

