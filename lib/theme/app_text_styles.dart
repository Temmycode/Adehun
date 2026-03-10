import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Plus Jakarta Sans — headings & display
  static TextStyle get _headingStyle => GoogleFonts.plusJakartaSans();

  // Lato — body text, labels, buttons
  static TextStyle get _bodyStyle => GoogleFonts.lato();

  // Open Sans — numbers, amounts, currency
  static TextStyle get _numberStyle => GoogleFonts.openSans();

  // Display
  static TextStyle displayLarge = _headingStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle displayMedium = _headingStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // Headings
  static TextStyle h1 = _headingStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle h2 = _headingStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle h3 = _headingStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Body (Lato)
  static TextStyle bodyLarge = _bodyStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = _bodyStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmall = _bodyStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Labels (Lato)
  static TextStyle labelLarge = _bodyStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle labelMedium = _bodyStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle labelSmall = _bodyStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  // Button (Lato)
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

  // Amount/Currency (Open Sans)
  static TextStyle amountLarge = _numberStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle amountMedium = _numberStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // Small numeric text (Open Sans) — for stat cards, badges, counts
  static TextStyle numberSmall = _numberStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
}
