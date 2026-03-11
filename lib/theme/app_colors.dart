import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary — vibrant blue (from concept 3)
  static const Color primary = Color(0xFF3B4BF9);
  static const Color primaryLight = Color(0xFF6B77FB);
  static const Color primaryDark = Color(0xFF2A38C7);
  static const Color primarySurface = Color(0xFFEEF0FF);

  // Accent — warm amber/gold (from concepts 3 & 5)
  static const Color accent = Color(0xFFFFA726);
  static const Color accentLight = Color(0xFFFFCC80);
  static const Color accentDark = Color(0xFFF57C00);

  // Background & Surface
  static const Color background = Color(0xFFF8F9FD);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF2F3F7);
  static const Color cardBorder = Color(0xFFE8E9EF);

  // Text
  static const Color textPrimary = Color(0xFF1A1D2E);
  static const Color textSecondary = Color(0xFF6B7089);
  static const Color textTertiary = Color(0xFF9B9FB5);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnDark = Colors.white;

  // Status Colors — for escrow states
  static const Color statusDraft = Color(0xFF9B9FB5);
  static const Color statusPending = Color(0xFFFFA726);
  static const Color statusActive = Color(0xFF3B4BF9);
  static const Color statusInProgress = Color(0xFF5B8DEF);
  static const Color statusConditionsMet = Color(0xFF66BB6A);
  static const Color statusCompleted = Color(0xFF43A047);
  static const Color statusDisputed = Color(0xFFEF5350);
  static const Color statusCancelled = Color(0xFF9E9E9E);
  static const Color statusRefunded = Color(0xFF8D6E63);

  // Status Background Colors (lighter variants)
  static const Color statusDraftBg = Color(0xFFF0F0F4);
  static const Color statusPendingBg = Color(0xFFFFF3E0);
  static const Color statusActiveBg = Color(0xFFEEF0FF);
  static const Color statusInProgressBg = Color(0xFFE8EEFF);
  static const Color statusConditionsMetBg = Color(0xFFE8F5E9);
  static const Color statusCompletedBg = Color(0xFFE8F5E9);
  static const Color statusDisputedBg = Color(0xFFFFEBEE);
  static const Color statusCancelledBg = Color(0xFFF5F5F5);
  static const Color statusRefundedBg = Color(0xFFEFEBE9);

  // Functional
  static const Color success = Color(0xFF43A047);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color error = Color(0xFFEF5350);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color warning = Color(0xFFFFA726);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color info = Color(0xFF5B8DEF);
  static const Color infoLight = Color(0xFFE8EEFF);

  // Gradient for wallet card
  static const LinearGradient walletGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3B4BF9),
      Color(0xFF6B77FB),
      Color(0xFF8B6CF7),
    ],
  );

  // Gradient for onboarding
  static const LinearGradient onboardingGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF3B4BF9),
      Color(0xFF2A38C7),
    ],
  );
}
