import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_connect/core/utils/sequential_id_service.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SequentialIdService _ids = SequentialIdService();

  Future<String> _generateSequentialUserId()  {
    return _ids.nextId('users', 'user_');
  }
  Future<String> _generateGroupId() {
    return _ids.nextId('groups', 'group_');
  }

  //register a new user and creates their Firestore profile document
  Future<String?> register({
    required String fullName,
    required String email,
    required String password,
    // String? faculty,
    String? department,
    String? academicYear,
    String? major,
  }) async{
    try{
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      final sequentialId = await _generateSequentialUserId();
      final role = email.toLowerCase().endsWith('@admin.ul.edu.lb') ? 'admin' : 'student';


      //to remove the academicYear and faculty fields if added admin
      final userData = <String, dynamic>{
        'userId': sequentialId,
        'fullName': fullName,
        'email': email,
        'role': role,
        'faculty': 'Faculty of Economics and Business Administration',
        'createdAt': FieldValue.serverTimestamp(),
      };

      if(department != null) userData['department'] = department;
      if (academicYear != null) userData['academicYear'] = academicYear;

      // Year 1 has no major: the student is automatically placed in
      // "General Preparation". Other years use the chosen major.
      String? effectiveMajor = major;
      if (academicYear == 'Year 1' && department == 'Business Administration') {
        effectiveMajor = 'General Preparation';
      }
      if (effectiveMajor != null && effectiveMajor.isNotEmpty) {
        userData['major'] = effectiveMajor;
      }

      if(role == 'student' && department != null && academicYear != null){
        final String label = (effectiveMajor != null && effectiveMajor.isNotEmpty) ? effectiveMajor : department;
        Query<Map<String, dynamic>> q = _firestore
            .collection('groups')
            .where('academicYear', isEqualTo: academicYear)
            .where('department', isEqualTo: department);
        if(effectiveMajor != null && effectiveMajor.isNotEmpty){
          q = q.where('major', isEqualTo: effectiveMajor);
        }
        final existingGroupQuery = await q.limit(1).get();

        String groupId;

        if (existingGroupQuery.docs.isNotEmpty) {
          groupId = existingGroupQuery.docs.first.id;
        } else {
          groupId = await _generateGroupId();
          await _firestore.collection('groups').doc(groupId).set({
            'groupId': groupId,
            'groupName': '$department - $academicYear',
            'academicYear': academicYear,
            'department': department,
            if(effectiveMajor != null && effectiveMajor.isNotEmpty) 'major': effectiveMajor,
            'memberCount': 0,
            'postCount': 0,
          });
        }
        userData['groupId'] = groupId;
      }

        // await _firestore.collection('users').doc(uid).set(userData);
        await _firestore.collection('users').doc(sequentialId).set(userData);

        if (userData['groupId'] != null) {
          await _firestore.collection('groups').doc(userData['groupId'] as String).set(
              {'membersCount': FieldValue.increment(1)}, SetOptions(merge: true));
        }

        //force sign out : prevents firebase from keeping the user logged in automatically after registration
        await _auth.signOut();

        return null;
      // }
    } on FirebaseAuthException catch(e){
      return _mapAuthError(e.code);
    }catch(e){
      debugPrint('Firestore write error: $e');
      return 'Something went wrong. Please try again.';
    }



  }

  //Sign in an existing user
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try{
      await _auth.signInWithEmailAndPassword(
        email:email,
        password:password,
      );
    }on FirebaseAuthException catch(e){
      return _mapAuthError(e.code);
    }catch(e){
      return ' Something went wrong. Please try again.';
    }
    return null;
  }

  String _mapAuthError(String code){
    switch(code){
      case 'email-already-in-use':
        return ' An account already exists with this email.';
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'weak-password':
        return 'Password is too weak - use at leat 6 characters.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      default:
        return 'Authentication failed ($code).';
    }
  }


  Future <void> logout() async{
    await _auth.signOut();
  }

  Future<bool> shouldAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;
    final currentUser = _auth.currentUser;

    if (currentUser != null && rememberMe) {
      return true;
    } else {
      await _auth.signOut();
      return false;
    }
  }

  Future<String?> getUserRole(String identifier) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(identifier).get();

      if (!doc.exists) {
        final query = await _firestore
            .collection('users')
            .where('userId', isEqualTo: identifier)
            .limit(1)
            .get();

        if (query.docs.isNotEmpty) {
          doc = query.docs.first;
        } else {
          final currentUser = _auth.currentUser;
          if (currentUser != null && currentUser.email != null) {
            final emailQuery = await _firestore
                .collection('users')
                .where('email', isEqualTo: currentUser.email)
                .limit(1)
                .get();
            if (emailQuery.docs.isNotEmpty) {
              doc = emailQuery.docs.first;
            }
          }
        }
      }

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>?;
        return data?['role'] as String?;
      }
    } catch (e) {
      debugPrint('Error fetching user role: $e');
    }
    return 'student';
  }

  // For password reset method
  Future<void> sendPasswordResentEmail(String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email.trim());
    }catch(e){
      throw Exception(e.toString());
    }
  }

}