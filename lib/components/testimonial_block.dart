import 'package:flutter/material.dart';
import 'package:lemon/utilities/extensions.dart';

class TestimonialBlock extends StatelessWidget {
  final String quote;
  final String author;

  const TestimonialBlock({
    super.key,
    required this.quote,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.tertiary,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.format_quote, size: 36, color: context.colors.primary),
          const SizedBox(height: 12),
          Text(
            "\"$quote\"",
            textAlign: TextAlign.center,
            style: context.text.bodyLarge!.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.5,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "- $author",
            style: context.text.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
