import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lemon/components/info_row.dart';
import 'package:lemon/components/primary_app_button.dart';
import 'package:lemon/services/line_service.dart';
import 'package:lemon/utilities/extensions.dart';

class StudentLineInformationPage extends StatelessWidget {
  final String lineName;
  const StudentLineInformationPage({super.key, required this.lineName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<Map<String, dynamic>?>(
          // You’ll need a method in LineService that returns a Stream
          stream: LineService().getLineStream(lineName),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final line = snapshot.data![lineName];
            final int waiting = line['waiting'];
            final bool open = line['open'];
            final List queue = line['queue'];
            final user = FirebaseAuth.instance.currentUser;
            final isInLine = user != null && queue.contains(user.displayName);
            final String description = line['description'];

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Let's look at ".capitalized),
                    Text(
                      lineName.capitalized,
                      style: GoogleFonts.workSans(
                        textStyle: context.text.headlineSmall,
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: context.text.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    InfoRow(
                      label: "People Waiting".capitalized,
                      value: waiting.toString().padLeft(4, "0"),
                      icon: Icons.hourglass_empty_outlined,
                    ),
                    InfoRow(
                      label: "open".capitalized,
                      value: open.toString().capitalized,
                      icon: open
                          ? Icons.lock_open_outlined
                          : Icons.lock_outline_rounded,
                      bottomBorder: false,
                    ),
                    const SizedBox(height: 16),
                    PrimaryAppButton(
                      buttonColor: isInLine
                          ? context.colors.error
                          : Colors.transparent,
                      label: isInLine
                          ? "exit line".capitalized
                          : "enter line".capitalized,
                      onTap: () {
                        if (isInLine) {
                          LineService().removeFromLine(lineName, context);
                        } else {
                          LineService().joinLine(lineName, context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
