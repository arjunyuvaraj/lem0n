// IMPORTS
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lemon/components/info_row.dart';
import 'package:lemon/components/primary_app_button.dart';
import 'package:lemon/services/authentication_service.dart';
import 'package:lemon/utilities/extensions.dart';

class AccountPage extends StatelessWidget {
  AccountPage({super.key});

  // USER: The currently signed-in Firebase user
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // THEME
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SafeArea(
      child: FutureBuilder<DocumentReference<Map<String, dynamic>>>(
        // FIRESTORE: Get the document reference for the current user
        future: AuthenticationService().getCurrentUserDocRef(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docRef = snapshot.data!;

          return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            // FIRESTORE: Load the actual user document
            future: docRef.get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              // FIRESTORE: Get the user’s data directly (no values.toList hack)
              final userData = snapshot.data?.data();

              if (userData == null) {
                return const Center(child: Text("No user data found."));
              }

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                children: [
                  // HEADER: Profile header with name and profile picture
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 42,
                          backgroundColor: colorScheme.primaryContainer,
                          child: Icon(
                            Icons.person_rounded,
                            size: 52,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "WELCOME",
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            letterSpacing: 3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          userData['displayName'] ?? 'Unknown',
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "@${userData['email']?.split('@')[0] ?? 'unknown'}",
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Account Info Section Header
                  Text(
                    "ACCOUNT INFORMATION",
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.outline,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // DATA: Show the username, password, school, and email
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    color: colorScheme.surface,
                    child: Column(
                      children: [
                        InfoRow(
                          label: "Email",
                          value: userData['email'] ?? 'Unknown',
                          icon: Icons.email_outlined,
                        ),
                        InfoRow(
                          label: "Display Name",
                          value: userData['displayName'] ?? 'Unknown',
                          icon: Icons.person_outline_rounded,
                        ),
                        InfoRow(
                          label: "School",
                          value: userData['school'] ?? 'Unknown',
                          icon: Icons.school_outlined,
                        ),
                        InfoRow(
                          bottomBorder: false,
                          label: "Role",
                          value: userData['role'] ?? 'Student',
                          icon: Icons.shield_outlined,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // FOOTER: All of the actions
                  Text(
                    "ACTIONS",
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.outline,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  PrimaryAppButton(
                    label: "Sign Out".capitalized,
                    onTap: () => AuthenticationService().signOut(context),
                  ),
                  const SizedBox(height: 8),
                  PrimaryAppButton(
                    label: "Delete Account".capitalized,
                    buttonColor: context.colors.error,
                    onTap: () => AuthenticationService().deleteAccount(context),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
