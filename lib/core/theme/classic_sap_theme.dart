import 'package:flutter/material.dart';

/// Klasik SAP ECC/S4HANA GUI'yi (gri/bej tonlar, kare köşeler, yoğun/kompakt
/// grid yapısı) simüle eden retro tema. Light/Dark ayrımı yoktur; SAP GUI'nin
/// kendisinde de yoktu.
const _sapBackground = Color(0xFFECE9D8);
const _sapPanel = Color(0xFFD4D0C8);
const _sapBorder = Color(0xFF919B9C);
const _sapSelection = Color(0xFF316AC5);
const _sapText = Color(0xFF000000);

final ThemeData classicSapTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  scaffoldBackgroundColor: _sapBackground,
  visualDensity: VisualDensity.compact,
  fontFamily: 'Tahoma',
  colorScheme: const ColorScheme.light(
    primary: _sapSelection,
    onPrimary: Colors.white,
    secondary: _sapPanel,
    onSecondary: _sapText,
    surface: _sapBackground,
    onSurface: _sapText,
    error: Color(0xFFCC0000),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: _sapPanel,
    foregroundColor: _sapText,
    elevation: 0,
    shape: Border(bottom: BorderSide(color: _sapBorder)),
  ),
  cardTheme: const CardThemeData(
    color: Colors.white,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: _sapBorder),
      borderRadius: BorderRadius.zero,
    ),
  ),
  dataTableTheme: const DataTableThemeData(
    headingRowColor: WidgetStatePropertyAll(_sapPanel),
    dataRowMinHeight: 22,
    dataRowMaxHeight: 24,
    columnSpacing: 12,
  ),
  dividerTheme: const DividerThemeData(color: _sapBorder, thickness: 1),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _sapPanel,
      foregroundColor: _sapText,
      elevation: 1,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: _sapBorder),
        borderRadius: BorderRadius.zero,
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: _sapBorder),
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 12, color: _sapText),
    titleMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _sapText),
  ),
);
