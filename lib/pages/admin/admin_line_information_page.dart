import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lemon/components/info_row.dart';
import 'package:lemon/components/primary_app_button.dart';
import 'package:lemon/components/secondary_app_button.dart';
import 'package:lemon/services/line_service.dart';
import 'package:lemon/utilities/extensions.dart';

class AdminLineInformationPage extends StatefulWidget {
  const AdminLineInformationPage({super.key});

  @override
  State<AdminLineInformationPage> createState() =>
      _AdminLineInformationPageState();
}

class _AdminLineInformationPageState extends State<AdminLineInformationPage> {
  String? selectedLine;

  @override
  Widget build(BuildContext context) {
    TextEditingController renameController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<Map<String, dynamic>?>(
          stream: LineService().getAllLinesStream(),
          builder: (context, snapshot) {
            // CHECK: Make sure the snapshot has data and was successfully retrieved
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

            // CHECK: Make sure the line is properly retrieved
            final lineNames = allLines.keys.toList();
            if (selectedLine == null || !lineNames.contains(selectedLine)) {
              selectedLine = lineNames.isNotEmpty ? lineNames.first : null;
            }

            if (selectedLine == null) {
              return const Center(child: Text("This line was deleted."));
            }

            // GET: SAFELY get all of the data
            final line = allLines[selectedLine] as Map<String, dynamic>? ?? {};
            final int waiting = (line['waiting'] ?? 0) as int;
            final bool open = (line['open'] ?? false) as bool;
            final String description =
                (line['description'] ?? "No description") as String;

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Let's look at ".capitalized),
                    // DROPDOWN: To switch between the different lines
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
                    // DATA: Show the line information
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
                      label: "open queue".capitalized,
                      onTap: () {
                        if (!open) {
                          LineService().openLine(selectedLine!, context);
                        } else {
                          LineService().closeLine(selectedLine!, context);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    // BUTTONS: The following buttons are for basic CRUD actions
                    // Open/Close line toggle
                    SecondaryAppButton(
                      buttonColor: open
                          ? context.colors.error
                          : Colors.transparent,
                      label: !open
                          ? "open line".capitalized
                          : "close line".capitalized,
                      onTap: () {
                        if (!open) {
                          LineService().openLine(selectedLine!, context);
                        } else {
                          LineService().closeLine(selectedLine!, context);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    // Rename Line
                    SecondaryAppButton(
                      buttonColor: open
                          ? context.colors.error
                          : Colors.transparent,
                      label: "rename line".capitalized,
                      onTap: () {
                        if (!open) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Rename Line"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Enter the new name for this line:",
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: renameController,
                                      decoration: const InputDecoration(
                                        labelText: "New Name",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final input = renameController.text
                                          .trim();
                                      if (input.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Name cannot be empty.",
                                            ),
                                          ),
                                        );
                                      } else {
                                        LineService().renameLine(
                                          selectedLine!,
                                          input,
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text("Rename"),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          LineService().closeLine(selectedLine!, context);
                        }
                      },
                    ),
                    SizedBox(height: 36),
                    // Delete Button
                    GestureDetector(
                      onTap: () => {LineService().deleteLine(selectedLine!)},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Done with this ".capitalized,
                                style: context.text.bodyMedium?.copyWith(
                                  color: context.colors.error,
                                ),
                              ),
                              Text(
                                "line?".capitalized,
                                style: context.text.bodyMedium?.copyWith(
                                  color: context.colors.error,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "click here to ".capitalized,
                                style: context.text.bodyMedium?.copyWith(
                                  color: context.colors.error,
                                ),
                              ),
                              Text(
                                "delete it.".capitalized,
                                style: context.text.bodyMedium?.copyWith(
                                  color: context.colors.error,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
