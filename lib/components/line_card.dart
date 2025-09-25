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
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.colors.tertiary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Text(
                            title.capitalized,
                            style: context.text.headlineSmall?.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          Text(description),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          AppChip(
                            text: (waiting.toString().padLeft(
                              4,
                              '0',
                            )).capitalized,
                            color: Color(0xFFFFB300),
                          ),
                          const SizedBox(height: 6),
                          status
                              ? AppChip(
                                  text: ("open").capitalized,
                                  color: Color(0xFF2E7D32),
                                )
                              : AppChip(
                                  text: ("closed").capitalized,
                                  color: Color(0xFFC62828),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
