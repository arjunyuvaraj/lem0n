import 'package:flutter/material.dart';
import 'package:lemon/utilities/extensions.dart';

class LandingCard extends StatelessWidget {
  final String? leadingText;
  final IconData? leadingIcon;
  final String title;
  final String body;

  const LandingCard({
    super.key,
    this.leadingText,
    this.leadingIcon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colors.primary.withAlpha(100),
                  context.colors.primary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: leadingIcon != null
                ? Icon(leadingIcon, color: Colors.white, size: 28)
                : Text(
                    leadingText ?? "",
                    style: context.text.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withAlpha(225),
                      fontSize: 22,
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            title.toUpperCase(),
            style: context.text.titleSmall!.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium!.copyWith(
              fontSize: 13,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
