import 'package:flutter/material.dart';

import 'app_color_scheme.dart';

/// Spacing scale. Use these instead of magic numbers in padding and gaps.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;

  /// Horizontal screen gutter.
  static const double gutter = 20;
}

/// Common edge insets built from the spacing scale.
abstract final class AppInsets {
  static const EdgeInsets screen = EdgeInsets.symmetric(
    horizontal: AppSpacing.gutter,
  );
  static const EdgeInsets card = EdgeInsets.all(AppSpacing.lg);
  static const EdgeInsets sheet = EdgeInsets.fromLTRB(
    AppSpacing.gutter,
    AppSpacing.sm,
    AppSpacing.gutter,
    AppSpacing.xxl,
  );
}

/// Corner radii. Cards use [lg], sheets [xl], buttons and chips [pill].
abstract final class AppRadius {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double pill = 999;

  static BorderRadius get card => BorderRadius.circular(lg);
  static BorderRadius get input => BorderRadius.circular(md);
  static BorderRadius get button => BorderRadius.circular(pill);
  static BorderRadius get chip => BorderRadius.circular(pill);
  static BorderRadius get sheet =>
      const BorderRadius.vertical(top: Radius.circular(xl));
}

/// Elevation, for floating elements only (nav bar, FAB, hero cards).
abstract final class AppShadows {
  /// Two layers, not one: a tight contact shadow that seats the element on
  /// the page, and a wide ambient one that gives it height. A single flat
  /// blur is what makes a surface look pasted on rather than lifted.
  static List<BoxShadow> floating(BuildContext context, {Color? tint}) {
    final base = tint ?? context.colors.shadow;
    return [
      BoxShadow(
        color: base.withValues(alpha: base.a * 0.55),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
      BoxShadow(
        color: base,
        blurRadius: 28,
        offset: const Offset(0, 12),
        spreadRadius: -4,
      ),
    ];
  }
}

/// Motion durations and curves.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Curve curve = Curves.easeOutCubic;

  /// Delay between staggered list items, and how many items get a stagger
  /// before the rest appear immediately.
  static const Duration staggerInterval = Duration(milliseconds: 40);
  static const int staggerCap = 8;

  /// True when the OS asks for reduced motion. Gate decorative animation.
  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);
}

/// Minimum tap target for icon-only controls.
const double kMinTapTarget = 44;
