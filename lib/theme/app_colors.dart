import 'package:flutter/material.dart';

/// Brand and functional colours that do not change between light and dark
/// mode. Theme-variant colours (backgrounds, text, tints) live in
/// [AppColorScheme] and are read through `context.colors`.
///
/// Palette: "Adehun Green" primary (trust, money), a warm clay accent for
/// highlights and celebration, and gold for anything awaiting action.
class AppColors {
  AppColors._();

  // Primary — Adehun Green. White text on it is 6.25:1.
  static const Color primary = Color(0xFF0B6E4F);
  static const Color primaryLight = Color(0xFF2E8B6E);
  static const Color primaryDark = Color(0xFF084F39);
  static const Color primarySurface = Color(0xFFE6F3EE);

  // Accent — clay. Use [textPrimary]-coloured text on it (5.2:1); white text
  // only passes on [accentDark] (4.75:1).
  static const Color accent = Color(0xFFE4674A);
  static const Color accentLight = Color(0xFFFBE3DC);
  static const Color accentDark = Color(0xFFC24E33);

  // Gold — "awaiting action". [gold] for fills and icons, [goldDark] for text.
  static const Color gold = Color(0xFFE9A23B);
  static const Color goldDark = Color(0xFF9A6410);

  // Light-mode neutrals, kept for the rare place that cannot read a context.
  static const Color background = Color(0xFFFBF8F3);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF3EEE6);
  static const Color cardBorder = Color(0xFFEBE4D9);

  // Text
  static const Color textPrimary = Color(0xFF1E1B16);
  static const Color textSecondary = Color(0xFF6B655B);
  static const Color textTertiary = Color(0xFFA39C90);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnDark = Colors.white;

  // Agreement status foregrounds.
  static const Color statusDraft = Color(0xFFA39C90);
  static const Color statusPending = goldDark;
  static const Color statusActive = primary;
  static const Color statusInProgress = Color(0xFF2F7DD1);
  static const Color statusConditionsMet = Color(0xFF1F9D6A);
  static const Color statusCompleted = Color(0xFF1F9D6A);
  static const Color statusDisputed = Color(0xFFD9483B);
  static const Color statusCancelled = Color(0xFF8F887C);
  static const Color statusRefunded = Color(0xFF9C6B4E);

  // Light-mode status tints. Prefer `context.colors.status*Bg`.
  static const Color statusDraftBg = Color(0xFFF3EEE6);
  static const Color statusPendingBg = Color(0xFFFBF0DC);
  static const Color statusActiveBg = Color(0xFFE6F3EE);
  static const Color statusInProgressBg = Color(0xFFE5EFFA);
  static const Color statusConditionsMetBg = Color(0xFFE3F5EC);
  static const Color statusCompletedBg = Color(0xFFE3F5EC);
  static const Color statusDisputedBg = Color(0xFFFCE8E5);
  static const Color statusCancelledBg = Color(0xFFF3EEE6);
  static const Color statusRefundedBg = Color(0xFFF2E7DF);

  // Functional
  static const Color success = Color(0xFF1F9D6A);
  static const Color successLight = Color(0xFFE3F5EC);
  static const Color error = Color(0xFFD9483B);
  static const Color errorLight = Color(0xFFFCE8E5);
  static const Color warning = gold;
  static const Color warningLight = Color(0xFFFBF0DC);
  static const Color info = Color(0xFF2F7DD1);
  static const Color infoLight = Color(0xFFE5EFFA);
}
