import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static Color _hex(String hex) => Color(int.parse('0xff$hex'));

  static const String _primaryHex = '29756F';
  static const String _secondaryHex = '2F7E79';
  static const _primaryHexDark = "1F5C57";
  static const String _secondaryHexDark = "256460";

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _hex(_primaryHex),
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: AppBarTheme(
      backgroundColor: _hex(_primaryHex),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(color: Colors.white, elevation: 2),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(color: Colors.black87),
      displayMedium: GoogleFonts.inter(color: Colors.black87),
      displaySmall: GoogleFonts.inter(color: Colors.black87),
      headlineLarge: GoogleFonts.inter(color: Colors.black87),
      headlineMedium: GoogleFonts.inter(color: Colors.black87),
      headlineSmall: GoogleFonts.inter(color: Colors.black87),
      titleLarge: GoogleFonts.inter(color: Colors.black87),
      titleMedium: GoogleFonts.inter(color: Colors.black87),
      titleSmall: GoogleFonts.inter(color: Colors.black87),
      bodyLarge: GoogleFonts.inter(color: Colors.black87),
      bodyMedium: GoogleFonts.inter(color: Colors.black87),
      bodySmall: GoogleFonts.inter(color: Colors.black87),
      labelLarge: GoogleFonts.inter(color: Colors.black87),
      labelMedium: GoogleFonts.inter(color: Colors.black87),
      labelSmall: GoogleFonts.inter(color: Colors.black87),
    ),
    colorScheme: ColorScheme.light(
      primary: _hex(_primaryHex),
      secondary: _hex(_secondaryHex),
      surface: Colors.white,
      background: Colors.grey[100],
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
      onError: Colors.white,
    ),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _hex(_primaryHexDark),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(color: const Color(0xFF1E1E1E), elevation: 2),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(color: Colors.white),
      displayMedium: GoogleFonts.inter(color: Colors.white),
      displaySmall: GoogleFonts.inter(color: Colors.white),
      headlineLarge: GoogleFonts.inter(color: Colors.white),
      headlineMedium: GoogleFonts.inter(color: Colors.white),
      headlineSmall: GoogleFonts.inter(color: Colors.white),
      titleLarge: GoogleFonts.inter(color: Colors.white),
      titleMedium: GoogleFonts.inter(color: Colors.white),
      titleSmall: GoogleFonts.inter(color: Colors.white),
      bodyLarge: GoogleFonts.inter(color: Colors.white),
      bodyMedium: GoogleFonts.inter(color: Colors.white),
      bodySmall: GoogleFonts.inter(color: Colors.white),
      labelLarge: GoogleFonts.inter(color: Colors.white),
      labelMedium: GoogleFonts.inter(color: Colors.white),
      labelSmall: GoogleFonts.inter(color: Colors.white),
    ),
    colorScheme: ColorScheme.dark(
      primary: _hex(_primaryHexDark),
      secondary: _hex(_secondaryHexDark),
      surface: const Color(0xFF1E1E1E),
      background: const Color(0xFF121212),
      error: const Color(0xFFCF6679),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
    ),
    useMaterial3: true,
  );
}
