import 'package:flutter/material.dart';
import 'package:lemon/utilities/extensions.dart';

class AppChip extends StatelessWidget {
  final String text;
  final Color color;
  final BorderRadius borderRadius;
  final Color textColor;
  final EdgeInsets padding;

  const AppChip({
    super.key,
    required this.text,
    required this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        alignment: AlignmentGeometry.center,
        decoration: BoxDecoration(borderRadius: borderRadius, color: color),
        child: Padding(
          padding: padding,
          child: Text(
            text,
            style: context.text.bodySmall?.copyWith(
              fontSize: 12,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
