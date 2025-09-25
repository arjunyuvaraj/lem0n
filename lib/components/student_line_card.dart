import 'package:flutter/material.dart';
import 'package:lemon/components/app_chip.dart';
import 'package:lemon/utilities/extensions.dart';

class StudentLineCard extends StatelessWidget {
  final String title;
  final String description;
  final int waiting;
  final bool status;
  final String bottomButtonLabel;
  final Color bottomButtonColor;
  final GestureTapCallback onTap;

  const StudentLineCard({
    super.key,
    required this.title,
    required this.description,
    required this.waiting,
    required this.status,
    required this.bottomButtonLabel,
    required this.bottomButtonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: context.colors.tertiary,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TOP: title + description + status chips
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Texts
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.capitalized,
                          style: context.text.headlineSmall?.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(description, style: context.text.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Chips
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppChip(
                          text: waiting.toString().padLeft(4, '0').capitalized,
                          color: Color(0xFFFE7F2D),
                        ),
                        const SizedBox(height: 6),
                        AppChip(
                          text: status
                              ? "open".capitalized
                              : "closed".capitalized,
                          color: status
                              ? Color(0xFF606c38)
                              : context.colors.error,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // BOTTOM BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: AppChip(
                text: bottomButtonLabel,
                color: bottomButtonColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
