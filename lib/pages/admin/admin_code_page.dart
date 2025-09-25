import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lemon/components/app_text_field.dart';
import 'package:lemon/components/primary_app_button.dart';
import 'package:lemon/services/authentication_service.dart';
import 'package:lemon/utilities/extensions.dart';

class AdminCodePage extends StatelessWidget {
  const AdminCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController codeController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsetsGeometry.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // HEADER - Welcome header
                Image(image: AssetImage('assets/images/welcome_image.png')),
                Text(
                  "Welcome to".capitalized,
                  style: context.text.headlineSmall,
                ),
                Text("lemon".capitalized, style: context.text.headlineLarge),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Are you ".capitalized,
                      style: context.text.bodyMedium,
                    ),
                    Text(
                      "really, ".capitalized,
                      style: GoogleFonts.workSans(
                        textStyle: context.text.bodyMedium,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text("an ".capitalized, style: context.text.bodyMedium),
                    Text(
                      "admin?".capitalized,
                      style: GoogleFonts.workSans(
                        textStyle: context.text.bodyMedium,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                // FORM - Get the admin code, and send it to the AuthService
                AppTextField(
                  hintText: "Administration Code",
                  controller: codeController,
                  obscureText: false,
                ),
                const SizedBox(height: 16),
                PrimaryAppButton(
                  label: "Login".capitalized,
                  onTap: () => AuthenticationService().signInWithCode(
                    codeController.text,
                    context,
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
