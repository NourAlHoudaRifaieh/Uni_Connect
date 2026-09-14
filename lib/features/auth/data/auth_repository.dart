import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //register a new user and creates their Forestore profile document
  Future<String?> register({
    required String fullName,
    required String email,
    required String password,
    String? faculty,
    String? academicYear,
    String? major,
  }) async{
    try{
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      final role = email.toLowerCase().endsWith('@admin.ul.edu.lb') ? 'admin' : 'student';


      //to remove the academicYear and faculty fields if added admin
      final userData = <String, dynamic>{
        'fullName': fullName,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Only include these fields when they actually have a value
      if (faculty != null) userData['faculty'] = faculty;
      if (major != null) userData['major'] = major;
      if (academicYear != null) userData['academicYear'] = academicYear;

      await _firestore.collection('users').doc(uid).set(userData);

      //force sign out : prevents firebase from keeping the user logged in automatically after registration
      await _auth.signOut();

      return null;
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

  //Fetch the user's role from Firestore 'admin' or 'student'
  Future<String?> getUserRole(String uid) async{
    try{
      final doc = await _firestore.collection('users').doc(uid).get();
      if(doc.exists && doc.data() != null){
        return doc.data()!['role'] as String?;
      }
    }catch(e){
      debugPrint('Enter fetching user role: $e');
    }
    return 'student';
  }

}