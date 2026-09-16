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
  final Color goldLight;
  final Color accentLight;

  // Navigation bar
  final Color navBarBackground;

  /// The single soft shadow colour used by floating elements (nav bar, FAB,
  /// hero cards).
  final Color shadow;

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
    required this.goldLight,
    required this.accentLight,
    required this.navBarBackground,
    required this.shadow,
  });

  // ── Light palette (warm cream) ──
  static const light = AppColorScheme(
    background: Color(0xFFFBF8F3),
    surface: Colors.white,
    surfaceVariant: Color(0xFFF3EEE6),
    cardBorder: Color(0xFFEBE4D9),
    primarySurface: Color(0xFFE6F3EE),
    textPrimary: Color(0xFF1E1B16),
    textSecondary: Color(0xFF6B655B),
    textTertiary: Color(0xFFA39C90),
    statusDraftBg: Color(0xFFF3EEE6),
    statusPendingBg: Color(0xFFFBF0DC),
    statusActiveBg: Color(0xFFE6F3EE),
    statusInProgressBg: Color(0xFFE5EFFA),
    statusConditionsMetBg: Color(0xFFE3F5EC),
    statusCompletedBg: Color(0xFFE3F5EC),
    statusDisputedBg: Color(0xFFFCE8E5),
    statusCancelledBg: Color(0xFFF3EEE6),
    statusRefundedBg: Color(0xFFF2E7DF),
    successLight: Color(0xFFE3F5EC),
    errorLight: Color(0xFFFCE8E5),
    warningLight: Color(0xFFFBF0DC),
    infoLight: Color(0xFFE5EFFA),
    goldLight: Color(0xFFFBF0DC),
    accentLight: Color(0xFFFBE3DC),
    navBarBackground: Colors.white,
    shadow: Color(0x0F1E1B16),
  );

  // ── Dark palette (warm charcoal) ──
  static const dark = AppColorScheme(
    background: Color(0xFF15130F),
    surface: Color(0xFF1E1B16),
    surfaceVariant: Color(0xFF2A2620),
    cardBorder: Color(0xFF35302A),
    primarySurface: Color(0xFF14372B),
    textPrimary: Color(0xFFF4EFE7),
    textSecondary: Color(0xFFA8A094),
    textTertiary: Color(0xFF6E6759),
    statusDraftBg: Color(0xFF2A2620),
    statusPendingBg: Color(0xFF3A2C14),
    statusActiveBg: Color(0xFF14372B),
    statusInProgressBg: Color(0xFF1A2A3D),
    statusConditionsMetBg: Color(0xFF173626),
    statusCompletedBg: Color(0xFF173626),
    statusDisputedBg: Color(0xFF3B1F1C),
    statusCancelledBg: Color(0xFF2A2620),
    statusRefundedBg: Color(0xFF2E241E),
    successLight: Color(0xFF173626),
    errorLight: Color(0xFF3B1F1C),
    warningLight: Color(0xFF3A2C14),
    infoLight: Color(0xFF1A2A3D),
    goldLight: Color(0xFF3A2C14),
    accentLight: Color(0xFF3D2620),
    navBarBackground: Color(0xFF1E1B16),
    shadow: Color(0x59000000),
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
    Color? goldLight,
    Color? accentLight,
    Color? navBarBackground,
    Color? shadow,
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
      goldLight: goldLight ?? this.goldLight,
      accentLight: accentLight ?? this.accentLight,
      navBarBackground: navBarBackground ?? this.navBarBackground,
      shadow: shadow ?? this.shadow,
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
      statusInProgressBg:
          Color.lerp(statusInProgressBg, other.statusInProgressBg, t)!,
      statusConditionsMetBg:
          Color.lerp(statusConditionsMetBg, other.statusConditionsMetBg, t)!,
      statusCompletedBg:
          Color.lerp(statusCompletedBg, other.statusCompletedBg, t)!,
      statusDisputedBg: Color.lerp(statusDisputedBg, other.statusDisputedBg, t)!,
      statusCancelledBg:
          Color.lerp(statusCancelledBg, other.statusCancelledBg, t)!,
      statusRefundedBg: Color.lerp(statusRefundedBg, other.statusRefundedBg, t)!,
      successLight: Color.lerp(successLight, other.successLight, t)!,
      errorLight: Color.lerp(errorLight, other.errorLight, t)!,
      warningLight: Color.lerp(warningLight, other.warningLight, t)!,
      infoLight: Color.lerp(infoLight, other.infoLight, t)!,
      goldLight: Color.lerp(goldLight, other.goldLight, t)!,
      accentLight: Color.lerp(accentLight, other.accentLight, t)!,
      navBarBackground: Color.lerp(navBarBackground, other.navBarBackground, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

/// Convenience extension to access theme-variant colors from any BuildContext.
extension AppColorSchemeExtension on BuildContext {
  AppColorScheme get colors =>
      Theme.of(this).extension<AppColorScheme>() ?? AppColorScheme.light;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
