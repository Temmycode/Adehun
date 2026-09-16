import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_motion.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../widgets/orbiting_blobs.dart';
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
            // The blobs are the hero, so they get whatever room is going
            // spare once the copy and the button have taken theirs.
            final field = (constraints.maxHeight * 0.34).clamp(220.0, 320.0);

            return Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.lg,
                AppSpacing.gutter,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const AdehunMark(size: 34, onPrimary: false),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        'Adehun',
                        style: AppTextStyles.h2.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Center(child: OrbitingBlobs(size: field)),
                  const Spacer(),
                  Text(
                    'Welcome to\nAdehun',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: colors.textPrimary,
                    ),
                  ).entrance(context, 0),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Hold the money safely, agree the terms, and pay out when the work lands.',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ).entrance(context, 1),
                  const SizedBox(height: AppSpacing.xl),
                  const _TrustRow().entrance(context, 2),
                  const SizedBox(height: AppSpacing.xxl),
                  _GoogleSignInButton(
                    loading: isLoading,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ref.read(authControllerProvider.notifier).googleSignIn();
                    },
                  ).entrance(context, 3),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'By continuing you agree to our Terms of Service and Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Three short reassurances on one line. The full-sentence version of this
/// took a third of the screen and read like terms and conditions.
class _TrustRow extends StatelessWidget {
  const _TrustRow();

  static const _items = [
    (Iconsax.shield_tick, 'Bank-grade'),
    (Iconsax.lock_1, 'Held in escrow'),
    (Iconsax.flash_1, 'Set up in a minute'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        for (var i = 0; i < _items.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colors.primarySurface,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(_items[i].$1, size: 18, color: AppColors.primary),
                ),
                const SizedBox(height: 6),
                Text(
                  _items[i].$2,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
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
