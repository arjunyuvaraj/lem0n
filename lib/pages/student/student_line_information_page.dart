import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lemon/components/info_row.dart';
import 'package:lemon/components/primary_app_button.dart';
import 'package:lemon/services/authentication_service.dart';
import 'package:lemon/services/line_service.dart';
import 'package:lemon/utilities/extensions.dart';

class StudentLineInformationPage extends StatefulWidget {
  const StudentLineInformationPage({super.key});

  @override
  State<StudentLineInformationPage> createState() =>
      _StudentLineInformationPageState();
}

class _StudentLineInformationPageState
    extends State<StudentLineInformationPage> {
  String? selectedLine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<Map<String, dynamic>?>(
          stream: LineService().getAllLinesStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong. Please try again."),
              );
            }

            final allLines = snapshot.data ?? {};

            if (allLines.isEmpty) {
              return const Center(child: Text("No lines available right now."));
            }

            // Ensure selectedLine is valid
            final lineNames = allLines.keys.toList();
            if (selectedLine == null || !lineNames.contains(selectedLine)) {
              selectedLine = lineNames.isNotEmpty ? lineNames.first : null;
            }

            if (selectedLine == null) {
              return const Center(child: Text("This line was deleted."));
            }

            // Safely extract line data
            final line = allLines[selectedLine] as Map<String, dynamic>? ?? {};
            final int waiting = (line['waiting'] ?? 0) as int;
            final bool open = (line['open'] ?? false) as bool;
            final List queue = (line['queue'] ?? []) as List;
            final String currentPlace =
                (queue.indexOf(AuthenticationService().getCurrentUID()) + 1)
                    .toString()
                    .padLeft(4, "0");
            final String description =
                (line['description'] ?? "No description") as String;

            final user = FirebaseAuth.instance.currentUser;
            final isInLine = user != null && queue.contains(user.uid);
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Let's look at ".capitalized),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedLine,
                        isExpanded: true,
                        alignment: Alignment.center,
                        icon: const SizedBox.shrink(),
                        items: lineNames.map((name) {
                          return DropdownMenuItem(
                            value: name,
                            alignment: Alignment.center,
                            child: Text(
                              name.capitalized,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.workSans(
                                textStyle: context.text.headlineSmall,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: context.colors.primary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedLine = newValue;
                          });
                        },
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
                    ),
                    InfoRow(
                      label: "Current Place".capitalized,
                      value: open
                          ? isInLine
                                ? currentPlace
                                : "N/A".capitalized
                          : "N/A".capitalized,
                      icon: Icons.group_rounded,
                      bottomBorder: false,
                    ),
                    const SizedBox(height: 16),
                    PrimaryAppButton(
                      buttonColor: isInLine
                          ? context.colors.error
                          : Colors.transparent,
                      label: open
                          ? isInLine
                                ? "exit line".capitalized
                                : "enter line".capitalized
                          : "Line is not open".capitalized,
                      onTap: () {
                        if (open) {
                          if (isInLine) {
                            LineService().removeFromLine(
                              selectedLine!,
                              context,
                            );
                          } else {
                            LineService().joinLine(selectedLine!, context);
                          }
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
