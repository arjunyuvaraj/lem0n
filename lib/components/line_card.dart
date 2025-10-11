import 'package:flutter/material.dart';
import 'package:lemon/components/app_chip.dart';
import 'package:lemon/utilities/extensions.dart';

class LineCard extends StatelessWidget {
  final String title;
  final String description;
  final int waiting;
  final bool status;
  final GestureTapCallback onTap;

  const LineCard({
    super.key,
    required this.title,
    required this.description,
    required this.waiting,
    required this.status,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title.capitalized,
                style: context.text.headlineSmall?.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Texts
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
