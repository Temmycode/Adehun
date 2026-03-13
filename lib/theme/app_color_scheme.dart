import 'package:flutter/material.dart';

/// Theme-variant colors provided as a ThemeExtension.
/// Access via `context.colors` extension.
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  // Backgrounds & Surfaces
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color cardBorder;
  final Color primarySurface;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  // Status backgrounds
  final Color statusDraftBg;
  final Color statusPendingBg;
  final Color statusActiveBg;
  final Color statusInProgressBg;
  final Color statusConditionsMetBg;
  final Color statusCompletedBg;
  final Color statusDisputedBg;
  final Color statusCancelledBg;
  final Color statusRefundedBg;

  // Functional (light/tinted variants)
  final Color successLight;
  final Color errorLight;
  final Color warningLight;
  final Color infoLight;

  // Navigation bar
  final Color navBarBackground;
  final Color navBarShadow;

  const AppColorScheme({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.cardBorder,
    required this.primarySurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.statusDraftBg,
    required this.statusPendingBg,
    required this.statusActiveBg,
    required this.statusInProgressBg,
    required this.statusConditionsMetBg,
    required this.statusCompletedBg,
    required this.statusDisputedBg,
    required this.statusCancelledBg,
    required this.statusRefundedBg,
    required this.successLight,
    required this.errorLight,
    required this.warningLight,
    required this.infoLight,
    required this.navBarBackground,
    required this.navBarShadow,
  });

  // ── Light palette ──
  static const light = AppColorScheme(
    background: Color(0xFFF8F9FD),
    surface: Colors.white,
    surfaceVariant: Color(0xFFF2F3F7),
    cardBorder: Color(0xFFE8E9EF),
    primarySurface: Color(0xFFEEF0FF),
    textPrimary: Color(0xFF1A1D2E),
    textSecondary: Color(0xFF6B7089),
    textTertiary: Color(0xFF9B9FB5),
    statusDraftBg: Color(0xFFF0F0F4),
    statusPendingBg: Color(0xFFFFF3E0),
    statusActiveBg: Color(0xFFEEF0FF),
    statusInProgressBg: Color(0xFFE8EEFF),
    statusConditionsMetBg: Color(0xFFE8F5E9),
    statusCompletedBg: Color(0xFFE8F5E9),
    statusDisputedBg: Color(0xFFFFEBEE),
    statusCancelledBg: Color(0xFFF5F5F5),
    statusRefundedBg: Color(0xFFEFEBE9),
    successLight: Color(0xFFE8F5E9),
    errorLight: Color(0xFFFFEBEE),
    warningLight: Color(0xFFFFF3E0),
    infoLight: Color(0xFFE8EEFF),
    navBarBackground: Colors.white,
    navBarShadow: Color(0x14000000),
  );

  // ── Dark palette (deep navy) ──
  static const dark = AppColorScheme(
    background: Color(0xFF0F1324),
    surface: Color(0xFF171B2E),
    surfaceVariant: Color(0xFF1E2338),
    cardBorder: Color(0xFF282D42),
    primarySurface: Color(0xFF1C2045),
    textPrimary: Color(0xFFE8EAEF),
    textSecondary: Color(0xFF8B90A7),
    textTertiary: Color(0xFF5C6180),
    statusDraftBg: Color(0xFF252838),
    statusPendingBg: Color(0xFF332818),
    statusActiveBg: Color(0xFF1C2045),
    statusInProgressBg: Color(0xFF1C2540),
    statusConditionsMetBg: Color(0xFF1A2E1E),
    statusCompletedBg: Color(0xFF1A2E1E),
    statusDisputedBg: Color(0xFF2E1A1C),
    statusCancelledBg: Color(0xFF252838),
    statusRefundedBg: Color(0xFF2A2420),
    successLight: Color(0xFF1A2E1E),
    errorLight: Color(0xFF2E1A1C),
    warningLight: Color(0xFF332818),
    infoLight: Color(0xFF1C2540),
    navBarBackground: Color(0xFF171B2E),
    navBarShadow: Color(0x29000000),
  );

  @override
  AppColorScheme copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? cardBorder,
    Color? primarySurface,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? statusDraftBg,
    Color? statusPendingBg,
    Color? statusActiveBg,
    Color? statusInProgressBg,
    Color? statusConditionsMetBg,
    Color? statusCompletedBg,
    Color? statusDisputedBg,
    Color? statusCancelledBg,
    Color? statusRefundedBg,
    Color? successLight,
    Color? errorLight,
    Color? warningLight,
    Color? infoLight,
    Color? navBarBackground,
    Color? navBarShadow,
  }) {
    return AppColorScheme(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      cardBorder: cardBorder ?? this.cardBorder,
      primarySurface: primarySurface ?? this.primarySurface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      statusDraftBg: statusDraftBg ?? this.statusDraftBg,
      statusPendingBg: statusPendingBg ?? this.statusPendingBg,
      statusActiveBg: statusActiveBg ?? this.statusActiveBg,
      statusInProgressBg: statusInProgressBg ?? this.statusInProgressBg,
      statusConditionsMetBg: statusConditionsMetBg ?? this.statusConditionsMetBg,
      statusCompletedBg: statusCompletedBg ?? this.statusCompletedBg,
      statusDisputedBg: statusDisputedBg ?? this.statusDisputedBg,
      statusCancelledBg: statusCancelledBg ?? this.statusCancelledBg,
      statusRefundedBg: statusRefundedBg ?? this.statusRefundedBg,
      successLight: successLight ?? this.successLight,
      errorLight: errorLight ?? this.errorLight,
      warningLight: warningLight ?? this.warningLight,
      infoLight: infoLight ?? this.infoLight,
      navBarBackground: navBarBackground ?? this.navBarBackground,
      navBarShadow: navBarShadow ?? this.navBarShadow,
    );
  }

  @override
  AppColorScheme lerp(AppColorScheme? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      primarySurface: Color.lerp(primarySurface, other.primarySurface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      statusDraftBg: Color.lerp(statusDraftBg, other.statusDraftBg, t)!,
      statusPendingBg: Color.lerp(statusPendingBg, other.statusPendingBg, t)!,
      statusActiveBg: Color.lerp(statusActiveBg, other.statusActiveBg, t)!,
      statusInProgressBg: Color.lerp(statusInProgressBg, other.statusInProgressBg, t)!,
      statusConditionsMetBg: Color.lerp(statusConditionsMetBg, other.statusConditionsMetBg, t)!,
      statusCompletedBg: Color.lerp(statusCompletedBg, other.statusCompletedBg, t)!,
      statusDisputedBg: Color.lerp(statusDisputedBg, other.statusDisputedBg, t)!,
      statusCancelledBg: Color.lerp(statusCancelledBg, other.statusCancelledBg, t)!,
      statusRefundedBg: Color.lerp(statusRefundedBg, other.statusRefundedBg, t)!,
      successLight: Color.lerp(successLight, other.successLight, t)!,
      errorLight: Color.lerp(errorLight, other.errorLight, t)!,
      warningLight: Color.lerp(warningLight, other.warningLight, t)!,
      infoLight: Color.lerp(infoLight, other.infoLight, t)!,
      navBarBackground: Color.lerp(navBarBackground, other.navBarBackground, t)!,
      navBarShadow: Color.lerp(navBarShadow, other.navBarShadow, t)!,
    );
  }
}

/// Convenience extension to access theme-variant colors from any BuildContext.
extension AppColorSchemeExtension on BuildContext {
  AppColorScheme get colors =>
      Theme.of(this).extension<AppColorScheme>() ?? AppColorScheme.light;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
