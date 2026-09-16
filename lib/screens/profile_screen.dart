import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/shell/app_nav_bar.dart';
import 'package:adehun_mvp/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_motion.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_bottom_sheet.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_card.dart';
import '../widgets/app_chip.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/avatar_initials.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final user = ref.watch(authControllerProvider).userData;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.md,
            AppSpacing.gutter,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: AppTextStyles.h1.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppCard(
                child: Row(
                  children: [
                    AvatarInitials(
                      name: user?.name,
                      imageUrl: user?.profilePictureUrl,
                      size: 64,
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name?.trim().isNotEmpty == true
                                ? user!.name!
                                : 'Your name',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.h2.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppIconButton(
                      icon: Iconsax.edit_2_copy,
                      semanticLabel: 'Edit profile',
                      onPressed: () => context.push('/edit-profile'),
                    ),
                  ],
                ),
              ).entrance(context, 0),
              const SizedBox(height: AppSpacing.xxl),
              _Section(
                title: 'Account',
                children: [
                  _Row(
                    icon: Iconsax.user_copy,
                    title: 'Edit profile',
                    onTap: () => context.push('/edit-profile'),
                  ),
                  _Row(
                    icon: Iconsax.call_copy,
                    title: 'Phone number',
                    trailing: user?.phoneNumber ?? 'Not set',
                    onTap: () => context.push('/edit-profile'),
                  ),
                  _Row(
                    icon: Iconsax.bank_copy,
                    title: 'Bank accounts',
                    onTap: () => context.push('/bank-accounts'),
                  ),
                  _Row(
                    icon: Iconsax.notification_copy,
                    title: 'Notifications',
                    onTap: () => context.push('/notifications'),
                  ),
                ],
              ).entrance(context, 1),
              const SizedBox(height: AppSpacing.lg),
              _Section(
                title: 'Appearance',
                children: const [_ThemePicker()],
              ).entrance(context, 2),
              const SizedBox(height: AppSpacing.lg),
              _Section(
                title: 'Support',
                children: [
                  _Row(
                    icon: Iconsax.shield_tick_copy,
                    title: 'Privacy & security',
                    onTap: () => _showInfoSheet(
                      context,
                      title: 'Privacy & security',
                      body:
                          'Your session is protected with short-lived tokens stored in the device keychain. Money never moves without a verified payment or your explicit approval, and every escrow movement is recorded in your activity.\n\nSign out on shared devices, and contact support immediately if you notice activity you do not recognise.',
                    ),
                  ),
                  _Row(
                    icon: Iconsax.message_question_copy,
                    title: 'Help & support',
                    onTap: () => _showInfoSheet(
                      context,
                      title: 'Help & support',
                      body:
                          'Email support@adehun.app with your agreement reference and we will get back to you within one business day.',
                    ),
                  ),
                ],
              ).entrance(context, 3),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                padding: EdgeInsets.zero,
                child: _Row(
                  icon: Iconsax.logout_copy,
                  title: 'Sign out',
                  tint: AppColors.error,
                  showChevron: false,
                  onTap: () => _showSignOutSheet(context, ref),
                ),
              ).entrance(context, 4),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Text(
                  'Adehun v1.0.0',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textTertiary,
                  ),
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
  showAppBottomSheet(
    context,
    builder: (sheetContext) {
      final colors = sheetContext.colors;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colors.errorLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Iconsax.logout, color: AppColors.error, size: 26),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Sign out?',
            style: AppTextStyles.h2.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Your agreements and wallet stay exactly as they are. Sign back in any time with Google.',
            style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xxl),
          PrimaryButton(
            label: 'Sign out',
            tone: ButtonTone.danger,
            onPressed: () async {
              Navigator.pop(sheetContext);
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) context.go('/auth');
            },
          ),
          const SizedBox(height: AppSpacing.xs),
          TertiaryButton(
            label: 'Stay signed in',
            expand: true,
            onPressed: () => Navigator.pop(sheetContext),
          ),
        ],
      );
    },
  );
}

void _showInfoSheet(
  BuildContext context, {
  required String title,
  required String body,
}) {
  showAppBottomSheet(
    context,
    title: title,
    builder: (sheetContext) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          body,
          style: AppTextStyles.bodyMedium.copyWith(
            color: sheetContext.colors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        PrimaryButton(
          label: 'Got it',
          onPressed: () => Navigator.pop(sheetContext),
        ),
      ],
    ),
  );
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
          child: Text(
            title,
            style: AppTextStyles.labelMedium.copyWith(color: colors.textSecondary),
          ),
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(height: 1, indent: 52, color: colors.cardBorder),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final Color? tint;
  final bool showChevron;
  final VoidCallback onTap;

  const _Row({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.tint,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(icon, color: tint ?? colors.textSecondary, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: tint ?? colors.textPrimary,
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
            if (showChevron) ...[
              const SizedBox(width: AppSpacing.sm),
              Icon(
                Iconsax.arrow_right_3_copy,
                size: 16,
                color: colors.textTertiary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ThemePicker extends ConsumerWidget {
  const _ThemePicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeControllerProvider);
    final notifier = ref.read(themeControllerProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          for (final (m, icon, label) in const [
            (ThemeMode.light, Iconsax.sun_1_copy, 'Light'),
            (ThemeMode.dark, Iconsax.moon_copy, 'Dark'),
            (ThemeMode.system, Iconsax.monitor_copy, 'Auto'),
          ]) ...[
            Expanded(
              child: AppChip(
                label: label,
                icon: icon,
                selected: mode == m,
                onTap: () => notifier.setThemeMode(m),
              ),
            ),
            if (m != ThemeMode.system) const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
