import 'package:flutter/material.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_tokens.dart';

/// Pinned bottom area holding the screen's primary action. Sits above the
/// keyboard and the home indicator. Put it in `Scaffold.bottomNavigationBar`.
class BottomActionBar extends StatelessWidget {
  final Widget primary;
  final Widget? secondary;
  final Widget? above;
  final bool showDivider;

  const BottomActionBar({
    super.key,
    required this.primary,
    this.secondary,
    this.above,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        border: showDivider
            ? Border(top: BorderSide(color: colors.cardBorder))
            : null,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.md,
            AppSpacing.gutter,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (above != null) ...[
                above!,
                const SizedBox(height: AppSpacing.md),
              ],
              if (secondary != null)
                Row(
                  children: [
                    Expanded(child: secondary!),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(flex: 2, child: primary),
                  ],
                )
              else
                primary,
            ],
          ),
        ),
      ),
    );
  }
}
