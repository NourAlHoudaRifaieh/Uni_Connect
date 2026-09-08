import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_connect/core/models/user_model.dart';
import 'package:uni_connect/core/widgets/custom_form_field.dart';
import 'package:uni_connect/features/feed/presentation/widgets/admin_search_student_card.dart';

import '../../../../core/mock/mock_data.dart';

class AdminUsersScreen extends StatefulWidget {
  final bool isStandalone;

  AdminUsersScreen({
    super.key,
    this.isStandalone = false,
  });

  @override
  _AdminUsersScreenState createState() {
    return _AdminUsersScreenState();
  }
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _searchController = TextEditingController();

 List<UserModel> get students => MockData.students;

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

  List<UserModel> get _filteredStudents {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return students;
    return students.where((student) {
      final matchesName = student.fullName.toLowerCase().contains(query);
      final matchesEmail = student.email.toLowerCase().contains(query);
      final matchesFaculty = student.faculty?.toLowerCase().contains(query) ?? false;
      final matchesMajor = student.major?.toLowerCase().contains(query) ?? false;

      return matchesName || matchesEmail || matchesFaculty || matchesMajor;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                    Text('Manage Subject',
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
            Container(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
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
              child: Form(
                key: _formKey,
                child: CustomFormField(
                  hint: 'Search users' ,
                  controller: _searchController,
                  prefixIcon: Icon(Icons.search,
                      color: Color(0xFFB5B5C3)
                  ),
                  validator: (value) => value!.isEmpty ? 'Cannot be empty' : null,
                ),
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
            Expanded(
              child: Padding(
                  padding: EdgeInsets.all(20),
                child: _filteredStudents.isEmpty
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
                  itemCount: _filteredStudents.length,
                  itemBuilder: (context, index){
                    return AdminSearchStudentCard(
                      user: _filteredStudents[index],
                      onEditPressed: () {},
                      onDeletePressed: () {},
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}