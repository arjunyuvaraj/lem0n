import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lemon/components/primary_app_button.dart';
import 'package:lemon/pages/admin/admin_code_page.dart';
import 'package:lemon/services/authentication_service.dart';
import 'package:lemon/utilities/extensions.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(56),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // HEADER:
                Text(
                  "Welcome to".capitalized,
                  style: context.text.headlineSmall,
                ),
                Text("lem0n".capitalized, style: context.text.headlineLarge),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Skip the ".capitalized,
                      style: context.text.bodyMedium,
                    ),
                    Text(
                      "sour, ".capitalized,
                      style: GoogleFonts.workSans(
                        textStyle: context.text.bodyMedium,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      "get to the ".capitalized,
                      style: context.text.bodyMedium,
                    ),
                    Text(
                      "sweet.".capitalized,
                      style: GoogleFonts.workSans(
                        textStyle: context.text.bodyMedium,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                PrimaryAppButton(
                  label: "Sign in with google".capitalized,
                  onTap: () =>
                      AuthenticationService().signInWithGoogle(context),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdminCodePage()),
                    ),
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a ".capitalized,
                        style: context.text.bodyMedium,
                      ),
                      Text(
                        "student, ".capitalized,
                        style: GoogleFonts.workSans(
                          textStyle: context.text.bodyMedium,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "click ".capitalized,
                        style: context.text.bodyMedium,
                      ),
                      Text(
                        "here.".capitalized,
                        style: GoogleFonts.workSans(
                          textStyle: context.text.bodyMedium,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
