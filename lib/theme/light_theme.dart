import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lemon/utilities/extensions.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFFFFFFF),
  colorScheme: ColorScheme.light(
    primary: Color(0xFFFFBC03),
    secondary: Color(0xFF4A7C59),
    tertiary: Color(0xFFF6F5F4),
    surface: Colors.white,
    error: Color(0xFFC62828),
    onError: Colors.white,
    onPrimary: Color(0xFF202124),
    onSecondary: Colors.white,
    onTertiary: Colors.white,
    onSurface: Color(0xFF202124),
  ),
  primaryTextTheme: GoogleFonts.poppinsTextTheme(
    ThemeData.dark().textTheme.apply(bodyColor: Color(0xFF202124)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white, // white background
    selectedIconTheme: const IconThemeData(color: Color(0xFF202124), size: 28),
    unselectedIconTheme: IconThemeData(color: Colors.grey.shade600, size: 28),
    selectedLabelStyle: const TextStyle(color: Color(0xFF202124)),
    unselectedLabelStyle: TextStyle(color: Colors.grey.shade600),
  ),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.workSans(
      fontSize: 36,
      fontWeight: FontWeight.w900,
      color: Color(0xFFFBD42E),
      letterSpacing: getLetterSpacing(36, 20),
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: Color(0xFF202124),
    ),
    headlineSmall: GoogleFonts.workSans(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color(0xFF202124),
      letterSpacing: getLetterSpacing(36, 15),
    ),
    bodyLarge: GoogleFonts.raleway(fontSize: 16, color: Color(0xFF202124)),
    bodyMedium: GoogleFonts.workSans(
      fontSize: 12,
      fontStyle: FontStyle.italic,
      color: Color(0xFF202124),
      letterSpacing: getLetterSpacing(12, 10),
      fontWeight: FontWeight.w500,
    ),
    bodySmall: GoogleFonts.workSans(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Color(0xFFFFFFFF),
      letterSpacing: getLetterSpacing(14, 10),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
      color: Color(0xFF202124), // visible label color when not focused
      fontWeight: FontWeight.w600,
    ),
    floatingLabelStyle: TextStyle(
      color: Color(0xFF202124),
      fontWeight: FontWeight.w700,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black45, width: 1.5),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black45, width: 1.5),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  dividerTheme: DividerThemeData(color: Colors.black.withAlpha(50)),
);
