import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modern Next-Gen ERP modu: Bento-grid dashboard estetiği, yumuşak gölgeler,
/// yuvarlatılmış kartlar ve geniş padding'ler için Material 3 tabanlı tema.
const _modernSeed = Color(0xFF4F6EF7);

ThemeData _buildModernTheme(Brightness brightness) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _modernSeed,
    brightness: brightness,
  );
  final base = ThemeData(useMaterial3: true, colorScheme: colorScheme);
  final textTheme = GoogleFonts.interTextTheme(base.textTheme);

  return base.copyWith(
    textTheme: textTheme,
    scaffoldBackgroundColor: colorScheme.surface,
    cardTheme: CardThemeData(
      color: colorScheme.surfaceContainerHigh,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    ),
  );
}

final ThemeData modernLightTheme = _buildModernTheme(Brightness.light);
final ThemeData modernDarkTheme = _buildModernTheme(Brightness.dark);
