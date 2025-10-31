import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lemon/components/app_loading_circle.dart';
import 'package:lemon/components/line_card.dart';
import 'package:lemon/pages/student/user_navigation_page.dart';
import 'package:lemon/services/line_service.dart';
import 'package:lemon/utilities/codes.dart';
import 'package:lemon/utilities/extensions.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // HEADER: Title and description
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome to ".capitalized,
                        style: context.text.headlineSmall,
                      ),
                      Text(
                        "lem0n".capitalized,
                        style: GoogleFonts.workSans(
                          textStyle: context.text.headlineSmall,
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "What can ".capitalized,
                        style: context.text.bodyMedium,
                      ),
                      Text(
                        "we, ".capitalized,
                        style: GoogleFonts.workSans(
                          textStyle: context.text.bodyMedium,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text("get ".capitalized, style: context.text.bodyMedium),
                      Text(
                        "you?".capitalized,
                        style: GoogleFonts.workSans(
                          textStyle: context.text.bodyMedium,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),

              // LIST: Go through all of the lines
              Expanded(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: LineService().getLines(Codes().currentSchool),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: AppLoadingCircle());
                    }

                    final data = snapshot.data!.data() ?? {};
                    final lines = data.entries.toList();

                    if (lines.isEmpty) {
                      return const Center(child: Text("No lines found"));
                    }

                    return ListView.separated(
                      itemCount: lines.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final doc = lines[index];
                        final title = doc.key;
                        final item = doc.value as Map<String, dynamic>;

                        final open = item['open'] ?? false;
                        final waiting = item['waiting'] ?? 0;
                        final description = item['description'] ?? "";
                        return LineCard(
                          title: title,
                          description: description,
                          waiting: waiting,
                          status: open,
                          onTap: () {
                            // TODO: Fix method for BOTH admin and student!
                            if (!open) return;
                            final navState = context
                                .findAncestorStateOfType<
                                  StudentNavigationPageState
                                >();
                            navState?.switchTo(index: 1, store: title);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
