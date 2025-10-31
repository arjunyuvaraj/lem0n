import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lemon/pages/admin/admin_navigation_page.dart';
import 'package:lemon/pages/landing_page.dart';
import 'package:lemon/pages/student/user_navigation_page.dart';
import 'package:lemon/utilities/codes.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        // FIREBASE-AUTH: Checking for any state changes, when the user logs in, or logs out
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // FIREBASE-AUTH: User is logged in
          if (snapshot.hasData) {
            return snapshot.data!.email == Codes().adminUsername
                ? AdminNavigationPage()
                : StudentNavigationPage();
          }
          // FIREBASE-AUTH: User is not logged in
          else {
            return LandingPage();
          }
        },
      ),
    );
  }
}
