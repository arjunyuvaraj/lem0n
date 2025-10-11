import 'package:flutter/material.dart';
import 'package:lemon/utilities/extensions.dart';

void displayMessageToUser(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        message,
        style: context.text.headlineSmall?.copyWith(letterSpacing: 1),
      ),
    ),
  );
}
