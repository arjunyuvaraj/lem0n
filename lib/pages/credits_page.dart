import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lemon/utilities/extensions.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsGeometry.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  "Welcome to".capitalized,
                  style: context.text.headlineSmall,
                ),
                Text(
                  "lem0n".capitalized,
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
                Text("a big ".capitalized, style: context.text.bodyMedium),
                Text(
                  "thanks, ".capitalized,
                  style: GoogleFonts.workSans(
                    textStyle: context.text.bodyMedium,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text("to".capitalized, style: context.text.bodyMedium),
                Text(
                  "...".capitalized,
                  style: GoogleFonts.workSans(
                    textStyle: context.text.bodyMedium,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
