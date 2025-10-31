import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lemon/components/primary_app_button.dart';
import 'package:lemon/pages/student/user_navigation_page.dart';
import 'package:lemon/services/authentication_service.dart';
import 'package:lemon/utilities/codes.dart';
import 'package:lemon/utilities/extensions.dart';

class SelectSchoolPage extends StatelessWidget {
  const SelectSchoolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(56.0),
        child: ListView.builder(
          itemCount: Codes().schools.length,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryAppButton(
                  label: Codes().schools[index].toString().capitalized,
                  onTap: () {
                    AuthenticationService().saveUserToFirestore(
                      displayName:
                          FirebaseAuth.instance.currentUser!.displayName!,
                      school: Codes().schools[index],
                      email: FirebaseAuth.instance.currentUser!.email!,
                    );
                    // NAVIGATE: Go to the home page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StudentNavigationPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
    );
  }
}
