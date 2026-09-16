import 'package:flutter/material.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_tokens.dart';

/// The one card surface. Bordered and flat by default; `floating` swaps the
/// border for the soft shadow, for hero elements only.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? color;
  final Color? borderColor;
  final bool bordered;
  final bool floating;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? margin;
  final Clip clipBehavior;

  const AppCard({
    super.key,
    required this.child,
    this.padding = AppInsets.card,
    this.radius = AppRadius.lg,
    this.color,
    this.borderColor,
    this.bordered = true,
    this.floating = false,
    this.onTap,
    this.onLongPress,
    this.margin,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: bordered && !floating
          ? BorderSide(color: borderColor ?? colors.cardBorder)
          : BorderSide.none,
    );

    Widget body = Material(
      color: color ?? colors.surface,
      shape: shape,
      clipBehavior: clipBehavior,
      child: onTap == null && onLongPress == null
          ? Padding(padding: padding, child: child)
          : InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              child: Padding(padding: padding, child: child),
            ),
    );

    if (floating) {
      body = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: AppShadows.floating(context),
        ),
        child: body,
      );
    }

    if (margin != null) {
      body = Padding(padding: margin!, child: body);
    }
    return body;
  }
}
