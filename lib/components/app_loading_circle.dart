import 'package:flutter/material.dart';

class AppLoadingCircle extends StatelessWidget {
  const AppLoadingCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: CircularProgressIndicator.adaptive(
        strokeWidth: 4,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.primary.withAlpha(50),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
