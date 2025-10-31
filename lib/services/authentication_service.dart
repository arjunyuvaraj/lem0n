import 'dart:math';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lemon/pages/admin/admin_navigation_page.dart';
import 'package:lemon/pages/landing_page.dart';
import 'package:lemon/pages/select_school_page.dart';
import 'package:lemon/pages/student/user_navigation_page.dart';
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

  Future<void> saveFcmToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final school = Codes().currentSchool; // From your Codes class
    final userRef = FirebaseFirestore.instance
        .collection(school)
        .doc(school)
        .collection('Students')
        .doc(user.uid);

    final messaging = FirebaseMessaging.instance;

    // ASK: For permission (important for iOS + Android 13+)
    await messaging.requestPermission();

    // GET: The token
    final token = await messaging.getToken();
    if (token == null) return;

    // SAVE: Token to Firestore
    await userRef.set({'fcmToken': token}, SetOptions(merge: true));

    // LISTEN: For automatic token refreshes
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      userRef.set({'fcmToken': newToken}, SetOptions(merge: true));
    });
  }

  // METHOD: Saves the user to Firestore
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

    throw Exception("Unable to generate unique token");
  }

  // METHOD: Sign in the user
  void signInWithGoogle(BuildContext context) async {
    // GOOGLE: Start up the Google popup
    await initializeGoogleSignIn();

    // TRY-CATCH: Prevent any unexpected errors
    try {
      // GOOGLE: Get the user's email
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email'], // Get the email
      );

      // GOOGLE: Get the ID Token to give to Firebase
      final idToken = googleUser.authentication.idToken;

      // FIREBASE: Make sure it's stored with Google
      final credential = GoogleAuthProvider.credential(idToken: idToken);

      // USER: Sign the user in
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      await saveFcmToken();

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
      return;
    } catch (e) {
      // ERROR: Some error occurred in general
      displayMessageToUser(
        'Unexpected error during Google Sign-In: $e',
        context,
      );
      return;
    }
  }

  void deleteAccount(BuildContext context) async {
    final navigator = Navigator.of(context);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        displayMessageToUser("No user found.", context);
        return;
      }

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.email)
          .delete();

      await user.delete();

      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => LandingPage()),
      );
    } catch (e) {
      displayMessageToUser("Account deletion failed: $e", context);
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
    // TRY-CATCH: Admin login with a code.
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
              .collection(Codes().currentSchool)
              .doc(Codes().currentSchool)
              .collection("Admin")
              .doc(uid);

          await adminDocRef.set({
            'email': Codes().adminUsername,
            'role': "admin",
          }, SetOptions(merge: true));
        }

        // NAVIGATE: Go to the AdminHomePage
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
      // USER: Is a STUDENT
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
      // USER: Is an ADMIN
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

  // METHOD: Get the current UID
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
        .limit(1)
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
    if (!docSnapshot.exists) {
      throw Exception("User $userId not found");
    }

    return docSnapshot.data()!;
  }

  Future<void> addMockStudents(String school, {int count = 100}) async {
    final firestore = FirebaseFirestore.instance;
    final schoolDoc = firestore.collection(school).doc(school);
    final studentsRef = schoolDoc.collection('Students');
    final vegOutDoc = schoolDoc.collection('Lines').doc('Lines');

    final random = math.Random();

    const List<String> names = [
      "Alex",
      "Jamie",
      "Taylor",
      "Jordan",
      "Morgan",
      "Casey",
      "Riley",
      "Skyler",
      "Avery",
      "Quinn",
      "Rowan",
      "Reese",
      "Dakota",
      "Emerson",
      "Finley",
      "Hayden",
      "Peyton",
      "River",
      "Sage",
      "Tatum",
    ];

    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final usedTokens = <String>{};
    final queueIds = <String>[];

    // --- Create mock students ---
    for (int i = 0; i < count; i++) {
      final name =
          '${names[random.nextInt(names.length)]} ${String.fromCharCode(65 + random.nextInt(26))}.';

      final email =
          'student${DateTime.now().millisecondsSinceEpoch % 1000000}$i@example.com';

      // GENERATE: A unique token
      String token;
      do {
        token = List.generate(
          4,
          (_) => chars[random.nextInt(chars.length)],
        ).join();
      } while (usedTokens.contains(token));

      usedTokens.add(token);

      // CREATE: A new student doc
      final studentDoc = studentsRef.doc();
      await studentDoc.set({
        'displayName': name,
        'email': email,
        'school': school,
        'token': token,
        'currentLine': 'VegOut',
      });

      queueIds.add(studentDoc.id);
    }

    // --- Append them to the VegOut queue field ---
    await vegOutDoc.update({
      'VegOut.queue': FieldValue.arrayUnion(queueIds),
      'VegOut.waiting': FieldValue.increment(queueIds.length),
    });
  }
}
