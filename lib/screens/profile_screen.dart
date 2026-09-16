import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/theme/theme_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:adehun_mvp/shell/app_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final user = ref.watch(authControllerProvider).userData;

    String generateInitials(String username) {
      return username.split(' ').map((name) => name[0]).join('');
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Header
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Profile',
                  style: AppTextStyles.h1.copyWith(color: colors.textPrimary),
                ),
              ),
              const SizedBox(height: 28),
              // Profile card
              Consumer(
                builder: (context, ref, _) {
                  final authState = ref.watch(authControllerProvider);
                  final user = authState.userData;
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colors.cardBorder),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: colors.primarySurface,
                          child: Text(
                            generateInitials(user?.name ?? 'User'),
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.primary,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          user?.name ?? 'User',
                          style: AppTextStyles.h2.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'example@example.com',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Settings sections
              _SettingsSection(
                title: 'Account',
                items: [
                  _SettingsItem(
                    icon: Iconsax.user_copy,
                    title: 'Edit Profile',
                    onTap: () => context.push('/edit-profile'),
                  ),
                  _SettingsItem(
                    icon: Iconsax.call_copy,
                    title: 'Phone Number',
                    trailing: user?.phoneNumber ?? 'Not set',
                    onTap: () => context.push('/edit-profile'),
                  ),
                  _SettingsItem(
                    icon: Iconsax.notification_copy,
                    title: 'Notifications',
                    onTap: () => context.push('/notifications'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SettingsSection(
                title: 'Preferences',
                items: [
                  _ThemeSettingsItem(),
                  _SettingsItem(
                    icon: Iconsax.bank_copy,
                    title: 'Bank Accounts',
                    onTap: () => context.push('/bank-accounts'),
                  ),
                  _SettingsItem(
                    icon: Iconsax.lock_copy,
                    title: 'Privacy & Security',
                    onTap: () => _showInfoSheet(
                      context,
                      title: 'Privacy & Security',
                      body:
                          'Your session is protected with short-lived tokens '
                          'stored in the device keychain. Money never moves '
                          'without a verified payment or your explicit '
                          'approval, and every escrow movement is recorded '
                          'in your transaction history.\n\n'
                          'Sign out on shared devices, and contact support '
                          'immediately if you notice activity you do not '
                          'recognise.',
                    ),
                  ),
                  _SettingsItem(
                    icon: Iconsax.info_circle_copy,
                    title: 'Help & Support',
                    onTap: () => _showInfoSheet(
                      context,
                      title: 'Help & Support',
                      body:
                          'Email support@adehun.app with your agreement '
                          'reference and we will get back to you within one '
                          'business day.',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Sign out
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.cardBorder),
                ),
                child: _SettingsItem(
                  icon: Iconsax.logout_copy,
                  title: 'Sign Out',
                  iconColor: AppColors.error,
                  titleColor: AppColors.error,
                  showArrow: false,
                  onTap: () => _showSignOutSheet(context, ref),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Adehun v1.0.0',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.textTertiary,
                ),
              ),
              SizedBox(height: context.navBottomPadding),
            ],
          ),
        ),
      ),
    );
  }
}

void _showSignOutSheet(BuildContext context, WidgetRef ref) {
  final colors = context.colors;

  showModalBottomSheet(
    context: context,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Icon(Iconsax.logout_copy, color: AppColors.error, size: 40),
              const SizedBox(height: 16),
              Text(
                'Sign Out',
                style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to sign out?',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: colors.cardBorder),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.buttonLarge.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(sheetContext);
                        await ref.read(authControllerProvider.notifier).signOut();
                        if (context.mounted) {
                          context.go('/auth');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Sign Out',
                        style: AppTextStyles.buttonLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: AppTextStyles.labelMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.cardBorder),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                items[i],
                if (i < items.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(height: 1, color: colors.cardBorder),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ThemeSettingsItem extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final mode = ref.watch(themeControllerProvider);
    final label = switch (mode) {
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
      ThemeMode.system => 'System',
    };

    return GestureDetector(
      onTap: () => _showThemePicker(context, ref),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              context.isDarkMode ? Iconsax.moon_copy : Iconsax.sun_1_copy,
              color: colors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Appearance',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              CupertinoIcons.chevron_forward,
              size: 14,
              color: colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final themeNotifier = ref.read(themeControllerProvider.notifier);
    final currentMode = ref.read(themeControllerProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Appearance',
                  style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
                ),
                const SizedBox(height: 20),
                _ThemeOption(
                  icon: Iconsax.sun_1_copy,
                  title: 'Light',
                  isSelected: currentMode == ThemeMode.light,
                  onTap: () {
                    themeNotifier.setThemeMode(ThemeMode.light);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 8),
                _ThemeOption(
                  icon: Iconsax.moon_copy,
                  title: 'Dark',
                  isSelected: currentMode == ThemeMode.dark,
                  onTap: () {
                    themeNotifier.setThemeMode(ThemeMode.dark);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 8),
                _ThemeOption(
                  icon: Iconsax.monitor_copy,
                  title: 'System',
                  isSelected: currentMode == ThemeMode.system,
                  onTap: () {
                    themeNotifier.setThemeMode(ThemeMode.system);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? colors.primarySurface : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : colors.cardBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : colors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isSelected ? AppColors.primary : colors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Icon(Iconsax.tick_circle, color: AppColors.primary, size: 22),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final Color? iconColor;
  final Color? titleColor;
  final bool showArrow;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.iconColor,
    this.titleColor,
    this.showArrow = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? colors.textSecondary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: titleColor ?? colors.textPrimary,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            if (showArrow) ...[
              const SizedBox(width: 8),
              Icon(
                CupertinoIcons.chevron_forward,
                size: 14,
                color: colors.textTertiary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void _showInfoSheet(
  BuildContext context, {
  required String title,
  required String body,
}) {
  final colors = context.colors;
  showModalBottomSheet(
    context: context,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h2.copyWith(color: colors.textPrimary)),
          const SizedBox(height: 12),
          Text(
            body,
            style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(sheetContext),
              child: const Text('Got it'),
            ),
          ),
        ],
      ),
    ),
  );
}
