import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lemon/components/primary_app_button.dart';
import 'package:lemon/pages/student/student_home_page.dart';
import 'package:lemon/services/authentication_service.dart';
import 'package:lemon/utilities/codes.dart';

class SelectSchoolPage extends StatelessWidget {
  const SelectSchoolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: Codes().schools.length,
        itemBuilder: (context, index) {
          return PrimaryAppButton(
            label: Codes().schools[index],
            onTap: () {
              AuthenticationService().saveUserToFirestore(
                displayName: FirebaseAuth.instance.currentUser!.displayName!,
                school: Codes().schools[index],
                email: FirebaseAuth.instance.currentUser!.email!,
              );
              // NAVIGATE: Go to the home page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StudentHomePage()),
              );
            },
          );
        },
      ),
    );
  }
}
