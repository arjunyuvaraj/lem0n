import 'package:flutter/material.dart';
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
            padding: EdgeInsetsGeometry.all(56),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // HEADER - Welcome header
                Image(
                  image: AssetImage('assets/images/welcome_image.png'),
                  width: 300,
                ),
                Text(
                  "Welcome to".capitalized,
                  style: context.text.headlineSmall,
                ),
                Text("lemon".capitalized, style: context.text.headlineLarge),
                const SizedBox(height: 8),
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
