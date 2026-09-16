import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';

/// Floating tab bar with labels and a centre "create" button.
class AppNavBar extends StatelessWidget {
  static const double height = 68;
  static const double bottomMargin = 10;
  static const double fabSize = 58;

  final int index;
  final int pendingBadge;
  final ValueChanged<int> onTap;
  final VoidCallback onCreate;

  const AppNavBar({
    super.key,
    required this.index,
    required this.pendingBadge,
    required this.onTap,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: bottomPadding + bottomMargin,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: height,
            decoration: BoxDecoration(
              color: colors.navBarBackground,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: colors.cardBorder),
              boxShadow: AppShadows.floating(context),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _NavItem(
                    icon: Iconsax.home_2_copy,
                    activeIcon: Iconsax.home_2,
                    label: 'Home',
                    isActive: index == 0,
                    onTap: () => onTap(0),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Iconsax.wallet_3_copy,
                    activeIcon: Iconsax.wallet_3,
                    label: 'Wallet',
                    isActive: index == 1,
                    onTap: () => onTap(1),
                  ),
                ),
                const SizedBox(width: fabSize + AppSpacing.md),
                Expanded(
                  child: _NavItem(
                    icon: Iconsax.document_text_copy,
                    activeIcon: Iconsax.document_text,
                    label: 'Agreements',
                    isActive: index == 3,
                    badgeCount: pendingBadge,
                    onTap: () => onTap(3),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Iconsax.profile_circle_copy,
                    activeIcon: Iconsax.profile_circle,
                    label: 'Profile',
                    isActive: index == 4,
                    onTap: () => onTap(4),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: height - fabSize / 2 - 6,
            child: _CreateButton(onTap: onCreate),
          ),
        ],
      ),
    );
  }
}

/// How much bottom padding a tab screen's scroll view needs so the last item
/// clears the floating nav bar.
extension NavInset on BuildContext {
  double get navBottomPadding =>
      AppNavBar.height +
      AppNavBar.bottomMargin +
      MediaQuery.paddingOf(this).bottom +
      AppSpacing.lg;
}

class _CreateButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: 'Create agreement',
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          width: AppNavBar.fabSize,
          height: AppNavBar.fabSize,
          decoration: BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
            border: Border.all(color: colors.navBarBackground, width: 4),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Iconsax.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int badgeCount;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tint = isActive ? AppColors.primary : colors.textSecondary;

    return Semantics(
      button: true,
      selected: isActive,
      label: badgeCount > 0 ? '$label, $badgeCount pending' : label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: AppMotion.fast,
                  curve: AppMotion.curve,
                  width: 44,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isActive ? colors.primarySurface : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Icon(isActive ? activeIcon : icon, color: tint, size: 22),
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: 2,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(color: colors.navBarBackground, width: 1.5),
                      ),
                      child: Text(
                        badgeCount > 9 ? '9+' : '$badgeCount',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelSmall.copyWith(
                color: tint,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
