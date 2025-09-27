import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lemon/components/line_card.dart';
import 'package:lemon/pages/student/student_navigation_page.dart';
import 'package:lemon/utilities/codes.dart';
import 'package:lemon/utilities/extensions.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // HEADER
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
                        "lemon".capitalized,
                        style: GoogleFonts.workSans(
                          textStyle: context.text.headlineSmall,
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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

              // LINES
              Expanded(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection(Codes().currentSchool)
                      .doc(Codes().currentSchool)
                      .collection("Lines")
                      .doc("Lines")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final data = snapshot.data!.data() ?? {};
                    final lines = data.entries.toList();

                    if (lines.isEmpty) {
                      return const Center(child: Text("No lines found"));
                    }

                    return ListView.separated(
                      itemCount: lines.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final doc = lines[index];
                        final title = doc.key;
                        final item = doc.value as Map<String, dynamic>;

                        return LineCard(
                          title: title,
                          description: item['description'] ?? "",
                          waiting: item['waiting'] ?? 0,
                          status: item['open'] ?? false,
                          onTap: () {
                            if (!item['open']) return; // guard
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
