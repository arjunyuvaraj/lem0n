import 'package:flutter/material.dart';
import 'package:lemon/utilities/extensions.dart';

class SecondaryAppButton extends StatelessWidget {
  final String label;
  final GestureTapCallback onTap;
  final Color buttonColor;

  const SecondaryAppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.buttonColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: AlignmentGeometry.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: buttonColor == Colors.transparent
                ? context.colors.secondary
                : buttonColor,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 42),
          child: Text(
            label,
            style: context.text.bodySmall?.copyWith(
              color: buttonColor == Colors.transparent
                  ? context.colors.secondary
                  : buttonColor,
            ),
          ),
        ),
      ),
    );
  }
}
