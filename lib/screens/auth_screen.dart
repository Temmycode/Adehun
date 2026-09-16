import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_motion.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import 'splash_screen.dart' show AdehunMark;

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final isLoading = ref.watch(authLoadingProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final artHeight = (constraints.maxHeight * 0.26).clamp(
              140.0,
              220.0,
            );
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.lg,
                AppSpacing.gutter,
                AppSpacing.xxl,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      constraints.maxHeight - AppSpacing.lg - AppSpacing.xxl,
                ),
                // The Spacer below needs a bounded height, which a scroll view
                // does not provide on its own.
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const AdehunMark(size: 36, onPrimary: false),
                          const SizedBox(width: AppSpacing.md),
                          Text(
                            'Adehun',
                            style: AppTextStyles.h2.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ).entrance(context, 0),
                      const SizedBox(height: AppSpacing.xxxl),
                      Container(
                        height: artHeight,
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(AppRadius.xl + 8),
                        ),
                        child: SvgPicture.asset(
                          'assets/illustrations/onboarding_safe.svg',
                          fit: BoxFit.contain,
                        ),
                      ).entrance(context, 1),
                      const SizedBox(height: AppSpacing.xxxl),
                      Text(
                        'Welcome to Adehun',
                        style: AppTextStyles.displayMedium.copyWith(
                          color: colors.textPrimary,
                        ),
                      ).entrance(context, 2),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Sign in with Google to create or join an agreement in under a minute.',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ).entrance(context, 3),
                      const SizedBox(height: AppSpacing.xxl),
                      const _TrustStrip().entrance(context, 4),
                      const Spacer(),
                      const SizedBox(height: AppSpacing.xxl),
                      _GoogleSignInButton(
                        loading: isLoading,
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          ref
                              .read(authControllerProvider.notifier)
                              .googleSignIn();
                        },
                      ).entrance(context, 5),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'By continuing you agree to our Terms of Service and Privacy Policy.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TrustStrip extends StatelessWidget {
  const _TrustStrip();

  static const _items = [
    (Iconsax.shield_tick_copy, 'Bank-grade encryption on every transaction'),
    (Iconsax.lock_copy, 'Money stays in escrow until both sides agree'),
    (Iconsax.rotate_left_copy, 'Cancel any time before an agreement is funded'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        for (final (icon, text) in _items)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colors.primarySurface,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(icon, size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const _GoogleSignInButton({required this.loading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: 'Continue with Google',
      child: OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: colors.surface,
          foregroundColor: colors.textPrimary,
          disabledForegroundColor: colors.textPrimary,
          side: BorderSide(color: colors.cardBorder, width: 1.5),
        ),
        child: AnimatedSwitcher(
          duration: AppMotion.fast,
          child: loading
              ? const SizedBox(
                  key: ValueKey('spinner'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : Row(
                  key: const ValueKey('label'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/google.png',
                      width: 22,
                      height: 22,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'Continue with Google',
                      style: AppTextStyles.buttonLarge.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
