// File: lib/app/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // Palette based on the reference style
  static const Color brownDark = Color(0xFF5D4037); // Dark Coffee
  static const Color brownCard = Color(0xFF6F4E37); // Card Background
  static const Color creamBackground = Color(0xFFFDFBF7); // Light Cream
  static const Color peachSearch = Color(0xFFEFD8C4); // The specific Peach color for Search
  static const Color beigeAccent = Color(0xFFEAD1B6); 

  // --- LIGHT THEME (Matches the Image) ---
  static final ThemeData lightTheme = ThemeData(
    primaryColor: brownDark,
    scaffoldBackgroundColor: creamBackground,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: brownDark,
      secondary: beigeAccent,
    ),
    // Text Styling
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold, color: brownDark),
      titleMedium: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold, color: Colors.white),
      bodyMedium: TextStyle(fontFamily: 'Roboto', color: Colors.black87),
    ),
    // App Bar Styling
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: brownDark),
      titleTextStyle: TextStyle(
        color: brownDark, 
        fontSize: 24, 
        fontWeight: FontWeight.bold, 
        fontFamily: 'Serif'
      ),
    ),
  );

  // --- DARK THEME (Fixed the error) ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: brownDark,
    scaffoldBackgroundColor: const Color(0xFF2C1A06), // Very Dark Coffee
    colorScheme: const ColorScheme.dark().copyWith(
      primary: brownDark,
      secondary: beigeAccent,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold, color: beigeAccent),
      titleMedium: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold, color: Colors.white),
      bodyMedium: TextStyle(fontFamily: 'Roboto', color: Colors.white70),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: beigeAccent),
      titleTextStyle: TextStyle(
        color: beigeAccent, 
        fontSize: 24, 
        fontWeight: FontWeight.bold, 
        fontFamily: 'Serif'
      ),
    ),
  );
}