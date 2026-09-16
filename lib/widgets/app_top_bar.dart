import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';

/// The app bar every pushed screen uses: a circular back button, a left
/// aligned title with an optional subtitle, and trailing actions.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;
  final bool centerTitle;
  final Color? backgroundColor;

  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBack = true,
    this.onBack,
    this.centerTitle = false,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitle == null ? 60 : 68);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppBar(
      backgroundColor: backgroundColor ?? colors.background,
      toolbarHeight: preferredSize.height,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      titleSpacing: showBack ? AppSpacing.sm : AppSpacing.gutter,
      leadingWidth: showBack ? kMinTapTarget + AppSpacing.gutter : 0,
      leading: showBack
          ? Padding(
              padding: const EdgeInsets.only(left: AppSpacing.gutter),
              child: AppBackButton(onPressed: onBack),
            )
          : null,
      title: Column(
        crossAxisAlignment:
            centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
        ],
      ),
      actions: actions == null
          ? null
          : [
              ...actions!,
              const SizedBox(width: AppSpacing.md),
            ],
    );
  }
}

/// 44px circular back control. Pops the router by default.
class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.icon = Iconsax.arrow_left_2_copy,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: 'Back',
      child: Material(
        color: colors.surface,
        shape: CircleBorder(side: BorderSide(color: colors.cardBorder)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed ??
              () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
          child: SizedBox(
            width: kMinTapTarget,
            height: kMinTapTarget,
            child: Icon(icon, size: 20, color: colors.textPrimary),
          ),
        ),
      ),
    );
  }
}

/// Circular icon control for app bar actions and inline icon buttons.
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool showDot;
  final Color? color;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
    this.showDot = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: colors.surface,
        shape: CircleBorder(side: BorderSide(color: colors.cardBorder)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: kMinTapTarget,
            height: kMinTapTarget,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, size: 20, color: color ?? colors.textPrimary),
                if (showDot)
                  Positioned(
                    top: 11,
                    right: 11,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.surface, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
