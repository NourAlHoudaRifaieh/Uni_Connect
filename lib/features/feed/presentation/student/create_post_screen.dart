import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/group_model.dart';
import 'package:uni_connect/core/models/post_model.dart';
import 'package:uni_connect/core/models/subject_model.dart';
import 'package:uni_connect/core/services/ai_category_service.dart';
import 'package:uni_connect/core/widgets/custom_dropdown.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import 'package:uni_connect/core/widgets/custom_form_field.dart';
import 'package:uni_connect/features/auth/data/group_repository.dart';
import 'package:uni_connect/features/auth/data/post_repository.dart';
import 'package:uni_connect/features/auth/data/subject_repository.dart';
import 'package:uni_connect/features/auth/data/user_repository.dart';
import 'package:uni_connect/features/auth/presentation/widgets/academic_info_step.dart';
import 'package:uni_connect/features/feed/presentation/widgets/academic_year_selector.dart';

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() {
    return _CreatePostScreenState();
  }
}

class _CreatePostScreenState extends State<CreatePostScreen> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _descriptionController = TextEditingController();

  final PostRepository _postRepository = PostRepository();
  final UserRepository _userRepository = UserRepository();
  final SubjectRepository _subjectRepository = SubjectRepository();
  final GroupRepository _groupRepository = GroupRepository();
  // Sends the post description to the Python backend (our trained model) to get a category
  final AiCategoryService _aiCategoryService = AiCategoryService();

  List<SubjectModel> studentSubjects = [];
  List<SubjectModel> allSubjects = [];
  List<GroupModel> allGroups = [];

  SubjectModel? selectedSubject;
  bool _isLoading = false;
  bool _loadingOptions = true;
  bool _isAdmin = false;

  String? _selectedYear;
  String? _selectedDepartment;
  String? _selectedMajor;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  void _loadSubjects() async {
    try {
      final userModel = await _userRepository.getCurrentUserModel();
      _isAdmin = userModel?.isAdmin ?? false;

      if (_isAdmin) {
        final fetchedSubjects = await _subjectRepository.getSubjects();
        final fetchedGroups = await _groupRepository
            .watchAllGroups()
            .first;

        if (!mounted) return;
        setState(() {
          allSubjects = fetchedSubjects;
          allGroups = fetchedGroups;
          _loadingOptions = false;
        });
        return;
      }
      // Student flow
      final groupId = userModel?.groupId;
      final fetchedSubjects = await _subjectRepository.getSubjects();

      final loadedSubjects = (groupId == null || groupId.isEmpty)
          ? fetchedSubjects
          : fetchedSubjects.where((s) {
        final isMainGroup = s.groupId == groupId;
        final isSharedGroup = s.sharedGroupIds != null && s.sharedGroupIds!.contains(groupId);
        return isMainGroup || isSharedGroup;
      }).toList();
      if (!mounted) return;
      setState(() {
        studentSubjects = loadedSubjects;
        selectedSubject = studentSubjects.isNotEmpty ? studentSubjects.first : null;
        _loadingOptions = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingOptions = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load subjects: $e')),
        );
      }
    }
    // try{
    //   //Only show subjects that belong to the student's own specialy.
    //   final userModel = await _userRepository.getCurrentUserModel();
    //   final groupId = userModel?.groupId;
    //   final allSubjects = await _subjectRepository.getSubjects();
    //
    //   final loadedSubjects = (groupId == null || groupId.isEmpty)
    //     ? allSubjects
    //     : allSubjects.where((s) {
    //         final isMainGroup = s.groupId == groupId;
    //         final isSharedGroup = s.sharedGroupIds != null && s.sharedGroupIds!.contains(groupId);
    //         return isMainGroup || isSharedGroup;
    //       }).toList();
    //
    //   if(!mounted) return;
    //   setState(() {
    //     subjects = loadedSubjects;
    //     selectedSubject = subjects.isNotEmpty ? subjects.first : null;
    //   });
    // }catch(e){
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Failed to load subjects: $e')),
    //     );
    //   }
    // }
  }

  // Helper to get available majors based on selected Year and Department
  List<String> _getAvailableMajors() {
    if (_selectedYear == null || _selectedDepartment == null) return [];

    final matchingGroups = allGroups.where((g) {
      bool matchesYear = g.academicYear == _selectedYear;
      bool matchesDept = g.department == _selectedDepartment;
      return matchesYear && matchesDept;
    }).toList();

    final majors = matchingGroups
        .map((g) => g.major)
        .where((m) => m != null && m.trim().isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();

    majors.sort();
    return majors;
  }

  Future<void> _publishPost() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      if (selectedSubject == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a subject')),
        );
        return;
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      setState(() {
        _isLoading = true;
      });

      try {
        final userModel = await _userRepository.getCurrentUserModel();
        final authorName = (userModel != null && userModel.fullName.isNotEmpty)
          ? userModel.fullName
          : _nameFromEmail(currentUser.email);
        final description =_descriptionController.text.trim();

        //AI categorization: our trained model decides the category from the description
        final aiResult = await _aiCategoryService.categorizeDetailed(description);
        final category = aiResult.category;

        final newPost = PostModel(
          // postId: 'post_${DateTime.now().millisecondsSinceEpoch}',
          userId: currentUser.uid,
          description: description,
          authorName: authorName,
          subjectCode: selectedSubject?.subjectCode,
          subjectId: selectedSubject?.subjectId,
          groupId: userModel?.groupId ?? selectedSubject?.groupId,
          categoryName: category,
          createdAt: DateTime.now(),
          comments: 0,
          likedBy: [],
        );

        await _postRepository.createPost(newPost);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(aiResult.label),
              backgroundColor: aiResult.usedModel ? Colors.green : Colors.orange,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to publish post: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  // nourrifaieh@gmail.com  into "Nour Rifaieh"
  String _nameFromEmail(String? email){
    if(email == null || email.isEmpty) return 'User';
    final prefix = email.split('@').first;
    return prefix
      .split(RegExp(r'[._-]'))
      .where((p) => p.isNotEmpty)
      .map((p) => '${p[0].toUpperCase()}${p.substring(1)}')
      .join(' ');
  }


  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (_loadingOptions) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Admin filter logic variables
    final availableMajors = _getAvailableMajors();
    final bool hasMajors = availableMajors.isNotEmpty;

    final bool showSubjects = _selectedYear != null &&
        _selectedDepartment != null &&
        (!hasMajors || _selectedMajor != null);

    final matchingGroupIds = allGroups.where((g) {
      bool matchesYear = _selectedYear == null || g.academicYear == _selectedYear;
      bool matchesDept = _selectedDepartment == null || g.department == _selectedDepartment;
      bool matchesMajor = !hasMajors || _selectedMajor == null || g.major == _selectedMajor;
      return matchesYear && matchesDept && matchesMajor;
    }).map((g) => g.groupId).where((id) => id != null).cast<String>().toSet();

    final filteredAdminSubjects = allSubjects.where((s) {
      if (_selectedYear != null && s.academicYear != _selectedYear) return false;
      final isMainMatch = s.groupId != null && matchingGroupIds.contains(s.groupId);
      final isSharedMatch = s.sharedGroupIds != null && s.sharedGroupIds!.any((id) => matchingGroupIds.contains(id));
      return isMainMatch || isSharedMatch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(
        child: Form(
          key: _formKey,
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
                          Text('Cancel', style: GoogleFonts.inter(color: Color(0xFF2563EB), fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    SizedBox(height:10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Create Post',
                            style: GoogleFonts.inter(fontSize: 22, fontWeight:  FontWeight.bold)
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal:10, vertical:4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.auto_awesome, size:14, color:Color(0xFF2563EB)),
                              SizedBox(width:5),
                              Text(
                                'AI Categorize',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF2563EB),
                                  fontWeight: FontWeight.bold,
                                  fontSize:13,
                                ),
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal:20, vertical:10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Academic Year Selection
                      if (_isAdmin) ...[
                        Text('Academic Year', style: GoogleFonts.inter(fontWeight:FontWeight.w600, fontSize:15)),
                        SizedBox(height:8),
                        AcademicYearSelector(
                            selectedYear: _selectedYear ?? '',
                            onYearSelected: (year){
                              setState(() {
                                _selectedYear= year;
                                _selectedDepartment = null;
                                _selectedMajor = null;
                                selectedSubject = null;
                              });
                            },
                        ),
                        // Department Selection (Appears after selecting Year)
                        if (_selectedYear != null) ...[
                          SizedBox(height: 16),
                          Text('Department', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
                          SizedBox(height: 8),
                          CustomDropdown(
                            value: _selectedDepartment,
                            hint: 'Select department',
                            items: kDepartments,
                            onChanged: (dept) {
                              setState(() {
                                _selectedDepartment = dept;
                                _selectedMajor = null;
                                selectedSubject = null;
                              });
                            },
                          ),
                        ],
                        // Major Selection (Appears ONLY IF there are actual majors for this Dept & Year)
                        if(_selectedYear != null && _selectedDepartment != null && hasMajors) ...[
                        SizedBox(height: 16),
                        Text('Major', style: GoogleFonts.inter(fontWeight:FontWeight.w600, fontSize:15)),
                        SizedBox(height:8),
                        CustomDropdown(
                            value: _selectedMajor,
                            hint: 'Select major',
                            items: _getAvailableMajors(),
                            onChanged: (major){
                              setState(() {
                                _selectedMajor = major;
                                selectedSubject = null;
                              });
                            }
                        ),
                      ],
                        // Subject Selection (Appears ONLY after Year, Department AND Major are selected)
                        if (showSubjects) ...[
                          SizedBox(height: 16),
                          Text('Select Subject', style: GoogleFonts.inter(fontWeight:FontWeight.w600, fontSize:15)),
                          SizedBox(height:8),
                          if (filteredAdminSubjects.isEmpty)
                            Text('No subjects found for this selection.', style: GoogleFonts.inter(color: Colors.grey.shade600))
                          else
                            Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: filteredAdminSubjects.map((subject){
                              final bool isSelected = selectedSubject?.subjectCode == subject.subjectCode;
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    selectedSubject = subject;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 150),
                                  padding: EdgeInsets.symmetric(horizontal:14, vertical:14),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Color(0xFFEFF6FF) : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected ? Color(0xFF2563EB) : Colors.grey.shade300,
                                      width: isSelected ? 1.5 :1.0,
                                    ),
                                  ),
                                  child: Text(
                                    subject.subjectName,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight:FontWeight.w600,
                                      color: isSelected ? Color(0xFF2563EB) : Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ]else ...[
                        SizedBox(height: 16),
                        Text('Select Subject', style: GoogleFonts.inter(fontWeight:FontWeight.w600, fontSize:15)),
                        SizedBox(height:8),
                        if (studentSubjects.isEmpty)
                          Text('No subjects assigned to your group', style: GoogleFonts.inter(color: Colors.grey.shade600))
                        else
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: studentSubjects.map((subject){
                              final bool isSelected = selectedSubject?.subjectCode == subject.subjectCode;
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    selectedSubject = subject;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 150),
                                  padding: EdgeInsets.symmetric(horizontal:14, vertical:14),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Color(0xFFEFF6FF) : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected ? Color(0xFF2563EB) : Colors.grey.shade300,
                                      width: isSelected ? 1.5 :1.0,
                                    ),
                                  ),
                                  child: Text(
                                    subject.subjectName,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight:FontWeight.w600,
                                      color: isSelected ? Color(0xFF2563EB) : Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      SizedBox(height:20),
                      CustomFormField(
                        label: 'Description',
                        maxLines: 5,
                        hint: 'Describe in detail - the more context you give, the better responses you will get',
                        controller: _descriptionController,
                        validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter a description' : null,
                      ),
                      SizedBox(height:30),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color:  Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xFF2563EB),
                            width:1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.auto_awesome, color: Color(0xFF2563EB),size:20),
                                SizedBox(width:10),
                                Text(
                                  'Smart AI Categorization',
                                  style: GoogleFonts.inter(
                                    color: Color(0xFF2563EB),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'When you publish, AI will analyze your description to assign the right category automatically',
                              style: GoogleFonts.inter(
                                color: Color(0xFF2563EB),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height:30),
                      _isLoading
                        ? Center(
                            child:  CircularProgressIndicator(),
                          )
                        : CustomElevatedButton(
                            text: 'Analyse & Publish',
                            onPressed: _publishPost,
                          ),
                      SizedBox(height:20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}