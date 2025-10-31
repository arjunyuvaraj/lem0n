import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lemon/components/info_row.dart';
import 'package:lemon/components/primary_app_button.dart';
import 'package:lemon/services/line_service.dart';
import 'package:lemon/utilities/extensions.dart';

class UserLineInformationPage extends StatefulWidget {
  const UserLineInformationPage({super.key});

  @override
  State<UserLineInformationPage> createState() =>
      _UserLineInformationPageState();
}

class _UserLineInformationPageState extends State<UserLineInformationPage> {
  String? selectedLine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<Map<String, dynamic>?>(
          stream: LineService().getAllLinesStream(),
          builder: (context, snapshot) {
            // LOADING: Waiting for stream data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // ERROR: Something went wrong
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong. Please try again."),
              );
            }

            // DATA: Extract all line data
            final allLines = snapshot.data ?? {};

            // CHECK: No lines available
            if (allLines.isEmpty) {
              return const Center(child: Text("No lines available right now."));
            }

            // CHECK: Ensure selected line is valid
            final lineNames = allLines.keys.toList();
            if (selectedLine == null || !lineNames.contains(selectedLine)) {
              selectedLine = lineNames.first;
            }

            // EXTRACT: Get line data safely
            final line = allLines[selectedLine] as Map<String, dynamic>? ?? {};
            final waiting = line['waiting'] is int ? line['waiting'] as int : 0;
            final open = line['open'] == true;
            final queue = (line['queue'] as List?) ?? [];
            final description =
                (line['description'] as String?) ?? "No description";

            // FIREBASE: Get user and UID
            final user = FirebaseAuth.instance.currentUser;
            final userId = user?.uid ?? "";
            final isInLine = queue.contains(userId);

            // COMPUTE: Determine user’s current place in line
            final currentPlace =
                (isInLine
                        ? (queue.indexOf(userId) + 1).toString().padLeft(4, "0")
                        : "N/A")
                    .capitalized;

            // UI: Main content
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Let's look at".capitalized),

                    // DROPDOWN: Select line
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
                          setState(() => selectedLine = newValue);
                        },
                      ),
                    ),
                    const SizedBox(height: 4),

                    // TEXT: Description
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: context.text.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // INFO: Line details
                    InfoRow(
                      label: "People Waiting".capitalized,
                      value: waiting.toString().padLeft(4, "0"),
                      icon: Icons.hourglass_empty_outlined,
                    ),
                    InfoRow(
                      label: "Open".capitalized,
                      value: open ? "Yes" : "No",
                      icon: open
                          ? Icons.lock_open_outlined
                          : Icons.lock_outline_rounded,
                    ),
                    InfoRow(
                      label: "Current Place".capitalized,
                      value: open && isInLine ? currentPlace : "N/A",
                      icon: Icons.group_rounded,
                      bottomBorder: false,
                    ),
                    const SizedBox(height: 16),

                    // BUTTON: Enter or exit line
                    PrimaryAppButton(
                      buttonColor: isInLine
                          ? context.colors.error
                          : context.colors.primary,
                      label: open
                          ? (isInLine
                                ? "Exit Line".capitalized
                                : "Enter Line".capitalized)
                          : "Line is not open".capitalized,
                      onTap: () {
                        // ACTION: Only respond if line is open
                        if (!open) return;

                        if (isInLine) {
                          // ACTION: Leave line
                          LineService().removeFromLine(selectedLine!, context);
                        } else {
                          // ACTION: Join line
                          LineService().joinLine(selectedLine!, context);
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
