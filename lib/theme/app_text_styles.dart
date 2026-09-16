import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Type scale. Nunito for headings (warm, rounded), DM Sans for everything
/// else, with tabular figures on money so amounts line up in lists.
///
/// Fonts are bundled under `assets/fonts/`; google_fonts picks them up by
/// filename, so nothing is fetched at runtime.
class AppTextStyles {
  AppTextStyles._();

  /// Always pass the weight in, never `GoogleFonts.nunito().copyWith(...)`.
  /// The bare call resolves the w400 file first, and a weight we do not ship
  /// throws once runtime fetching is off.
  static TextStyle _heading(FontWeight weight) =>
      GoogleFonts.nunito(fontWeight: weight);

  static TextStyle _body(FontWeight weight) =>
      GoogleFonts.dmSans(fontWeight: weight);

  static TextStyle _number(FontWeight weight) => GoogleFonts.dmSans(
    fontWeight: weight,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  // Display
  static TextStyle displayLarge = _heading(
    FontWeight.w800,
  ).copyWith(fontSize: 34, height: 1.15, letterSpacing: -0.5);

  static TextStyle displayMedium = _heading(
    FontWeight.w800,
  ).copyWith(fontSize: 28, height: 1.2, letterSpacing: -0.5);

  // Headings
  static TextStyle h1 = _heading(
    FontWeight.w800,
  ).copyWith(fontSize: 24, height: 1.3, letterSpacing: -0.3);

  static TextStyle h2 = _heading(
    FontWeight.w700,
  ).copyWith(fontSize: 20, height: 1.3);

  static TextStyle h3 = _heading(
    FontWeight.w700,
  ).copyWith(fontSize: 17, height: 1.3);

  // Body
  static TextStyle bodyLarge = _body(
    FontWeight.w500,
  ).copyWith(fontSize: 16, height: 1.5);

  static TextStyle bodyMedium = _body(
    FontWeight.w400,
  ).copyWith(fontSize: 14, height: 1.5);

  static TextStyle bodySmall = _body(
    FontWeight.w400,
  ).copyWith(fontSize: 12, height: 1.5);

  // Labels
  static TextStyle labelLarge = _body(
    FontWeight.w600,
  ).copyWith(fontSize: 14, height: 1.4);

  static TextStyle labelMedium = _body(
    FontWeight.w600,
  ).copyWith(fontSize: 12, height: 1.4);

  static TextStyle labelSmall = _body(
    FontWeight.w600,
  ).copyWith(fontSize: 11, height: 1.4);

  // Buttons
  static TextStyle buttonLarge = _body(
    FontWeight.w700,
  ).copyWith(fontSize: 16, height: 1.2);

  static TextStyle buttonMedium = _body(
    FontWeight.w700,
  ).copyWith(fontSize: 14, height: 1.2);

  // Money
  static TextStyle amountHero = _number(
    FontWeight.w800,
  ).copyWith(fontSize: 44, height: 1.1, letterSpacing: -1);

  static TextStyle amountLarge = _number(
    FontWeight.w800,
  ).copyWith(fontSize: 36, height: 1.2, letterSpacing: -0.5);

  static TextStyle amountMedium = _number(
    FontWeight.w700,
  ).copyWith(fontSize: 24, height: 1.2);

  static TextStyle numberSmall = _number(
    FontWeight.w600,
  ).copyWith(fontSize: 12, height: 1.3);
}
