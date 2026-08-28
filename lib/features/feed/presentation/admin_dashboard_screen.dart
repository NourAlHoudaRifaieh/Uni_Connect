import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/widgets/auth_header.dart';
import '../../auth/data/auth_repository.dart';

class AdminDashboardScreen extends StatefulWidget {
  AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() {
    return _AdminDashboardScreenState();
  }
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.fromLTRB(20,50,20,20),
              //   decoration: const BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //     ),
              //   ),
              //   child: Column(
              //     crossAxisAlignment : CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 'Dashboard',
              //                 style: GoogleFonts.inter(
              //                   color: Colors.white,
              //                   fontSize:25,
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //               const SizedBox(height:5),
              //               Text(
              //                 'Lebanese University - Admin',
              //                 style: GoogleFonts.inter(
              //                   color: Colors.white.withOpacity(0.7),
              //                   fontSize:15,
              //                   fontWeight: FontWeight.w400,
              //                 ),
              //               ),
              //             ],
              //           ),
              //           GestureDetector(
              //             onTap: ()async{
              //               await AuthRepository().logout();
              //               final prefs = await SharedPreferences.getInstance();
              //               await prefs.remove('remember_me');
              //               await prefs.remove('saved_email');
              //               if(context.mounted){
              //                 context.go('/login');
              //               }
              //             },
              //             child: Container(
              //               padding: EdgeInsets.symmetric(
              //                   horizontal: 14,
              //                   vertical: 6
              //               ),
              //               decoration: BoxDecoration(
              //                 color: Colors.white.withOpacity(0.2),
              //                 borderRadius: BorderRadius.circular(20),
              //               ),
              //               child: Row(
              //                 children: [
              //                   Icon(
              //                     Icons.logout,
              //                     color: Colors.white,
              //                     size:16,
              //                   ),
              //                   SizedBox(width:6),
              //                   Text(
              //                     'Sign Out',
              //                     style: GoogleFonts.inter(
              //                       color: Colors.white,
              //                       fontWeight: FontWeight.w600,
              //                       fontSize: 13,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}