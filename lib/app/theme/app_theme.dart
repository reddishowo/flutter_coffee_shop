// File: /coffeeshopmobileapp/lib/app/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // Warna disesuaikan dengan gambar (Coklat Tua & Krem/Beige)
  static const Color brownDark = Color(0xFF5D4037); // Coklat tua untuk tombol/header
  static const Color brownLight = Color(0xFF8D6E63);
  static const Color creamBackground = Color(0xFFFDFBF7); // Putih gading
  static const Color beigeAccent = Color(0xFFEAD1B6); // Warna kotak profile/banner
  
  static final ThemeData lightTheme = ThemeData(
    primaryColor: brownDark,
    scaffoldBackgroundColor: creamBackground,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: brownDark,
      secondary: beigeAccent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent, // AppBar transparan
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: beigeAccent, // Default button color
        foregroundColor: brownDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: beigeAccent,
      selectedItemColor: brownDark,
      unselectedItemColor: Colors.black54,
    ),
  );

  // Dark Theme (Opsional, disesuaikan sedikit)
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: brownDark,
    scaffoldBackgroundColor: const Color(0xFF2C1A06),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF2C1A06)),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: beigeAccent,
    ),
  );
}