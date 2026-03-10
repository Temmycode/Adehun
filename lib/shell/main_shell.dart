import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/wallet')) return 1;
    if (location.startsWith('/agreements')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Scale nav bar dimensions based on screen width
    final fabSize = (screenWidth * 0.145).clamp(48.0, 58.0);
    final centerGap = (screenWidth * 0.18).clamp(56.0, 76.0);

    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: bottomPadding + 10,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // The floating bar
            Container(
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 1),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Left side — Home, Wallet
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _NavItem(
                          icon: Iconsax.home_2_copy,
                          activeIcon: Iconsax.home_2,
                          isActive: index == 0,
                          onTap: () => context.go('/home'),
                        ),
                        _NavItem(
                          icon: Iconsax.wallet_3_copy,
                          activeIcon: Iconsax.wallet_3,
                          isActive: index == 1,
                          onTap: () => context.go('/wallet'),
                        ),
                      ],
                    ),
                  ),
                  // Center gap for FAB — proportional to screen width
                  SizedBox(width: centerGap),
                  // Right side — Agreements, Profile
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _NavItem(
                          icon: Iconsax.document_text_copy,
                          activeIcon: Iconsax.document_text,
                          isActive: index == 3,
                          onTap: () => context.go('/agreements'),
                        ),
                        _NavItem(
                          icon: Iconsax.profile_circle_copy,
                          activeIcon: Iconsax.profile_circle,
                          isActive: index == 4,
                          onTap: () => context.go('/profile'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Center FAB — elevated above the bar
            Positioned(
              bottom: 20,
              child: GestureDetector(
                onTap: () => context.push('/create-agreement'),
                child: Container(
                  width: fabSize,
                  height: fabSize,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Icon(Iconsax.add,
                      color: Colors.white, size: fabSize * 0.48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        height: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : AppColors.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 4),
            // Dot indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
