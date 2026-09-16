import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Type scale. Nunito for headings (warm, rounded), DM Sans for everything
/// else, with tabular figures on money so amounts line up in lists.
///
/// Fonts are bundled under `assets/fonts/`; google_fonts picks them up by
/// filename, so nothing is fetched at runtime.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _headingStyle => GoogleFonts.nunito();

  static TextStyle get _bodyStyle => GoogleFonts.dmSans();

  static TextStyle get _numberStyle => GoogleFonts.dmSans(
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  // Display
  static TextStyle displayLarge = _headingStyle.copyWith(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    height: 1.15,
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium = _headingStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: -0.5,
  );

  // Headings
  static TextStyle h1 = _headingStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static TextStyle h2 = _headingStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static TextStyle h3 = _headingStyle.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  // Body
  static TextStyle bodyLarge = _bodyStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static TextStyle bodyMedium = _bodyStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodySmall = _bodyStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Labels
  static TextStyle labelLarge = _bodyStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle labelMedium = _bodyStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle labelSmall = _bodyStyle.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Buttons
  static TextStyle buttonLarge = _bodyStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static TextStyle buttonMedium = _bodyStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  // Money
  static TextStyle amountHero = _numberStyle.copyWith(
    fontSize: 44,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -1,
  );

  static TextStyle amountLarge = _numberStyle.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle amountMedium = _numberStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static TextStyle numberSmall = _numberStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
}
