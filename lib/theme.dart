import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const gradTop = Color(0xFFFF5A5A);
  static const gradBottom = Color(0xFF9A3232);
  static const maroon = Color(0xFF9A3232);
  static const maroonText = Color(0xFFA84848);
  static const rose = Color(0xFFFFE4E4);
  static const panel = Color(0xFFFDF3F2);
  static const tile = Color(0xFFFFE0E0);
  static const navInactive = Color(0xFFD98F8F);
}

class AppText {
  /// "PHARMACY" page title (wide-spaced condensed caps)
  static TextStyle title({double size = 30}) => GoogleFonts.oswald(
      fontSize: size,
      fontWeight: FontWeight.w500,
      letterSpacing: 8,
      color: AppColors.maroon);

  /// Section headings: CART, CHOOSE PHARMACY ...
  static TextStyle heading({double size = 17, Color color = AppColors.maroonText}) =>
      GoogleFonts.archivoBlack(fontSize: size, color: color);

  static TextStyle body(
          {double size = 13,
          FontWeight w = FontWeight.w400,
          Color color = Colors.black87}) =>
      GoogleFonts.inter(fontSize: size, fontWeight: w, color: color);

  /// Big heavy caps (the "OTC" banner)
  static TextStyle display(
          {double size = 54, Color color = Colors.white, double spacing = 0}) =>
      GoogleFonts.anton(fontSize: size, color: color, letterSpacing: spacing);
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.maroon, primary: AppColors.maroon),
    scaffoldBackgroundColor: AppColors.rose,
  );
  return base.copyWith(textTheme: GoogleFonts.interTextTheme(base.textTheme));
}

String rupee(double v) => '₹${v.toStringAsFixed(2)}';
