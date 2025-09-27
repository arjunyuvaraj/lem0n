import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lemon/pages/admin/admin_navigation_page.dart';
import 'package:lemon/pages/select_school_page.dart';
import 'package:lemon/pages/student/student_navigation_page.dart';
import 'package:lemon/pages/welcome_page.dart';
import 'package:lemon/utilities/codes.dart';
import 'package:lemon/utilities/help_functions.dart';

class AuthenticationService {
  // VARIABLES: Instantiate GoogleSignIn, and create a variable to ensure we don't initialize multiple times
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _initialized = false;

  // METHOD: Get all of the Google and Authentication stuff ready
  Future<void> initializeGoogleSignIn() async {
    if (!_initialized) {
      await _googleSignIn.initialize();
      _initialized = true;
    }
  }

  // METHOD: Saves the user to firestore

  Future<void> saveUserToFirestore({
    required String displayName,
    required String school,
    required String email,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final studentsRef = FirebaseFirestore.instance
        .collection(school)
        .doc(school)
        .collection("Students");

    // STEP 1: Generate a unique 4-character alphanumeric token
    String token = await _generateUniqueAlphanumericToken(studentsRef);

    // STEP 2: Save user data with the token
    final userDocRef = studentsRef.doc(uid);
    await userDocRef.set({
      'currentLine': '',
      'displayName': displayName,
      'email': email,
      'school': school,
      'token': token,
    }, SetOptions(merge: true));
  }

  Future<String> _generateUniqueAlphanumericToken(
    CollectionReference studentsRef,
  ) async {
    const length = 4;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();

    String getRandomToken() {
      return List.generate(
        length,
        (_) => chars[random.nextInt(chars.length)],
      ).join();
    }

    for (int i = 0; i < 10000; i++) {
      final token = getRandomToken();

      final querySnapshot = await studentsRef
          .where('token', isEqualTo: token)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return token;
      }
    }
    throw Exception(e);
  }

  // METHOD: Sign in the user
  void signInWithGoogle(BuildContext context) async {
    // GOOGLE: Start up the google pop up
    await initializeGoogleSignIn();

    // TRY-CATCH: Prevent any unexpected errors
    try {
      // GOOGLE: Get the users email
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email'], // Get the email
      );

      // GOOGLE: Get the ID Token to give to Firebase
      final idToken = googleUser.authentication.idToken;

      // FIREBASE: Make sure it's stored with google
      final credential = GoogleAuthProvider.credential(idToken: idToken);

      // USER: Sign the user in
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      // CHECK: If the user is new, have them fill out which school they are from
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SelectSchoolPage()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentNavigationPage()),
        );
      }
    } on GoogleSignInException catch (e) {
      // ERROR: Some error occurred with Google
      displayMessageToUser(
        'Google Sign-In error: ${e.code} / ${e.description}',
        context,
      );
      return null;
    } catch (e) {
      // ERROR: Some error occurred in general
      displayMessageToUser(
        'Unexpected error during Google Sign-In: $e',
        context,
      );
      return null;
    }
  }

  // METHOD: Sign out with Google
  Future<void> signOutWithGoogle(BuildContext context) async {
    try {
      // GOOGLE: Sign out from Google
      await _googleSignIn.signOut();

      // FIREBASE: Sign out from Firebase
      await FirebaseAuth.instance.signOut();
      // NAVIGATE: Re-route to the welcome page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    } catch (e) {
      // ERROR: Something went wrong when signing out
      displayMessageToUser("Error signing out: $e", context);
    }
  }

  // METHOD: Sign in method for Administration
  void signInWithCode(String code, BuildContext context) async {
    // TRY-CATCH: Admin's login with a code. If the code is correct the program automatically enters a username and password to log them in
    try {
      // CHECK: Make sure the correct admin code was entered
      if (code == Codes().adminCode) {
        // FIREBASE: Login if the code was correct
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: Codes().adminUsername,
          password: Codes().adminPassword,
        );

        // FIRESTORE: Save admin user in Admins subcollection
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          final adminDocRef = FirebaseFirestore.instance
              .collection(Codes().currentSchool) // top-level collection
              .doc(Codes().currentSchool) // school document
              .collection("Admin") // subcollection for admins
              .doc(uid); // admin document = uid

          await adminDocRef.set({
            'email': Codes().adminUsername,
            'role': "admin",
          }, SetOptions(merge: true));
        }

        // NAVIGATE: Go to the AdminHomePage()
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminNavigationPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      displayMessageToUser(e.message ?? "Login error", context);
    }
  }

  // METHOD: Sign out method for Administration
  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => WelcomePage()),
    );
  }

  // METHOD: Get current user
  Future<DocumentReference<Map<String, dynamic>>> getCurrentUserDocRef() async {
    final codes = Codes(); // Use once
    final firestore = FirebaseFirestore.instance;
    final currentSchool = codes.currentSchool;

    if (codes.status) {
      // User is a STUDENT
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        throw Exception("No user is currently signed in.");
      }

      // RETURN: Reference to this student's document
      return firestore
          .collection(currentSchool)
          .doc(currentSchool)
          .collection("Students")
          .doc(uid);
    } else {
      // User is an ADMIN
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        throw Exception("No admin is currently signed in.");
      }

      // RETURN: Reference to this admin's document
      return firestore
          .collection(currentSchool)
          .doc(currentSchool)
          .collection("Admin")
          .doc(uid);
    }
  }

  // METHOD: Get's the current UID
  String getCurrentUID() {
    // USER: Get the current user
    final user = FirebaseAuth.instance.currentUser!;
    // OUTPUT: Return the UID
    return user.uid;
  }

  Future<Map<String, dynamic>> getUserByDisplayName(String displayName) async {
    final currentSchool = Codes().currentSchool;
    final isStudent = Codes().status;

    final querySnapshot = await FirebaseFirestore.instance
        .collection(currentSchool)
        .doc(currentSchool)
        .collection(isStudent ? "Students" : "Admin")
        .where("displayName", isEqualTo: displayName)
        .limit(1) // Since you're only looking for one user
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception("User with displayName '$displayName' not found.");
    }

    return querySnapshot.docs.first.data();
  }

  Future<Map<String, dynamic>> getUserDataById(String userId) async {
    final currentSchool = Codes().currentSchool;

    final docRef = FirebaseFirestore.instance
        .collection(currentSchool)
        .doc(currentSchool)
        .collection("Students")
        .doc(userId);

    final docSnapshot = await docRef.get();

    if (!(docSnapshot.exists)) {
      throw Exception("User $userId not found");
    }
    return docSnapshot.data()!;
  }
}
