import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_connect/core/widgets/academic_info_step.dart';
import 'package:uni_connect/core/widgets/personal_info_step.dart';
import 'package:uni_connect/core/widgets/auth_header.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {

  final PageController _pageController = PageController();
  int _currentStep = 0;

  final _formKeyStep1 = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedFaculty;
  String? _selectedYear;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _goToStep2(){
    if(!_formKeyStep1.currentState!.validate())
      return;
    setState(() {
      _currentStep = 1;
    });
    _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
    );
  }

  void _goBackToStep1(){
    setState(() {
      _currentStep = 0;
    });
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleCreateAccount() {
    if(_selectedFaculty == null || _selectedYear == null) return;

    //Firebase Auth + Firestore logic goes here next
    print('Name: ${_fullNameController.text}');
    print('Email: ${_emailController.text}');
    print('Faculty: ${_selectedFaculty}');
    print('Auto-assigned group: $_selectedFaculty - $_selectedYear');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body:Column(
        children: [
          AuthHeader(
            title: 'Create Account',
            subtitle: 'Join Lebanese University platform',
            backLabel: 'Back to login',
            onBack: () {
              if( _currentStep == 0){
                context.go('/login');
              }else{
                _goBackToStep1();
              }
            },
            progressBar: Row(
              children: [
                Expanded(
                  child: Container(
                    height:4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(width:6),
                Expanded(
                  child: Container(
                    height:4,
                    decoration: BoxDecoration(
                      color: _currentStep == 1 ? Colors.white : Colors.white38,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                PersonalInfoStep(
                  formKey: _formKeyStep1,
                  fullNameController : _fullNameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  onContinue: _goToStep2,
                ),
                AcademicInfoStep(
                  selectedFaculty: _selectedFaculty,
                  selectedYear: _selectedYear,
                  isLoading: _isLoading,
                  onFacultyChanged: (value) =>
                      setState(() => _selectedFaculty = value),
                  onYearChanged: (value) =>
                      setState(() => _selectedYear = value),//i have a problem in this part
                  onBack: _goBackToStep1,
                  onCreateAccount: _handleCreateAccount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}