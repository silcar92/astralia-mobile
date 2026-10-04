import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'astralia_colors.dart';

/// Tipografías: Cormorant Garamond (títulos, cursiva) y Nunito Sans (texto). En pruebas se desactiva la descarga.
class AstraliaType {
  const AstraliaType._();

  static bool useGoogleFonts = true;

  static TextStyle serif({
    double size = 24,
    FontWeight weight = FontWeight.w600,
    Color color = AstraliaColors.text,
  }) {
    final base = TextStyle(
      fontSize: size,
      fontWeight: weight,
      fontStyle: FontStyle.italic,
      color: color,
    );
    return useGoogleFonts
        ? GoogleFonts.cormorantGaramond(textStyle: base)
        : base;
  }

  static TextStyle sans({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AstraliaColors.text,
  }) {
    final base = TextStyle(fontSize: size, fontWeight: weight, color: color);
    return useGoogleFonts ? GoogleFonts.nunitoSans(textStyle: base) : base;
  }
}

ThemeData buildAstraliaTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: AstraliaColors.goldDeep,
        brightness: Brightness.dark,
        surface: AstraliaColors.navyMid,
      ).copyWith(
        primary: AstraliaColors.gold,
        onPrimary: AstraliaColors.goldInk,
        error: AstraliaColors.alert,
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor:
        Colors.transparent, // el degradado lo pone AstraliaBackground
    textTheme: ThemeData(brightness: Brightness.dark).textTheme.apply(
      bodyColor: AstraliaColors.text,
      displayColor: AstraliaColors.text,
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
