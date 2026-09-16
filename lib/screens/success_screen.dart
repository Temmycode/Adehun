import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_motion.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_buttons.dart';
import '../widgets/confetti_burst.dart';

class SuccessScreen extends StatefulWidget {
  final String type;

  /// The agreement the success relates to, if any.
  final String? agreementId;

  const SuccessScreen({super.key, required this.type, this.agreementId});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HapticFeedback.mediumImpact();
    });
  }

  void _navigate(String route) {
    const shellRoots = {'/home', '/wallet', '/agreements', '/profile'};
    if (shellRoots.contains(route)) {
      context.go(route);
    } else {
      context.go('/home');
      context.push(route);
    }
  }

  String get _agreementRoute => widget.agreementId == null
      ? '/agreements'
      : '/agreement/${widget.agreementId}';

  _SuccessConfig get _config {
    return switch (widget.type) {
      'agreement-created' => _SuccessConfig(
          icon: Iconsax.send_2,
          tone: AppColors.primary,
          title: 'Agreement sent',
          body:
              "We've invited the other party. Once they accept, you can fund escrow and get things moving.",
          primaryAction: 'View agreement',
          primaryRoute: _agreementRoute,
          secondaryAction: 'Back to home',
          secondaryRoute: '/home',
        ),
      'funds-deposited' => const _SuccessConfig(
          icon: Iconsax.wallet_add,
          tone: AppColors.success,
          title: 'Wallet topped up',
          body:
              'Your money is in your Adehun wallet, ready to lock into an agreement whenever you are.',
          primaryAction: 'View wallet',
          primaryRoute: '/wallet',
          secondaryAction: 'Back to home',
          secondaryRoute: '/home',
        ),
      'conditions-met' => _SuccessConfig(
          icon: Iconsax.tick_circle,
          tone: AppColors.success,
          title: 'All conditions met',
          body:
              "Everything's been approved. The funds are ready to be released to the beneficiary.",
          primaryAction: 'View agreement',
          primaryRoute: _agreementRoute,
          secondaryAction: 'Back to home',
          secondaryRoute: '/home',
        ),
      'funds-released' => const _SuccessConfig(
          icon: Iconsax.medal_star,
          tone: AppColors.success,
          title: 'Funds released',
          body:
              "The money is on its way to the beneficiary and the agreement is complete. Nicely done.",
          primaryAction: 'Back to home',
          primaryRoute: '/home',
          secondaryAction: 'View agreements',
          secondaryRoute: '/agreements',
        ),
      _ => const _SuccessConfig(
          icon: Iconsax.tick_circle,
          tone: AppColors.primary,
          title: 'Done',
          body: 'That went through successfully.',
          primaryAction: 'Continue',
          primaryRoute: '/home',
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final config = _config;
    final reduced = AppMotion.reduced(context);

    Widget hero = Container(
      width: 132,
      height: 132,
      decoration: BoxDecoration(
        color: config.tone.withValues(alpha: context.isDarkMode ? 0.22 : 0.12),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: config.tone,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: config.tone.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(config.icon, color: Colors.white, size: 48),
        ),
      ),
    );

    if (!reduced) {
      hero = hero.animate().scale(
            begin: const Offset(0.4, 0.4),
            end: const Offset(1, 1),
            duration: 700.ms,
            curve: Curves.elasticOut,
          );
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.lg,
            AppSpacing.gutter,
            AppSpacing.lg,
          ),
          child: Column(
            children: [
              const Spacer(flex: 2),
              ConfettiBurst(child: hero),
              const SizedBox(height: AppSpacing.xxxl),
              Text(
                config.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.displayMedium.copyWith(
                  color: colors.textPrimary,
                ),
              ).entrance(context, 3),
              const SizedBox(height: AppSpacing.md),
              Text(
                config.body,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ).entrance(context, 4),
              const Spacer(flex: 3),
              PrimaryButton(
                label: config.primaryAction,
                onPressed: () => _navigate(config.primaryRoute),
              ),
              if (config.secondaryAction != null) ...[
                const SizedBox(height: AppSpacing.xs),
                TertiaryButton(
                  label: config.secondaryAction!,
                  expand: true,
                  onPressed: () => _navigate(config.secondaryRoute!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessConfig {
  final IconData icon;
  final Color tone;
  final String title;
  final String body;
  final String primaryAction;
  final String primaryRoute;
  final String? secondaryAction;
  final String? secondaryRoute;

  const _SuccessConfig({
    required this.icon,
    required this.tone,
    required this.title,
    required this.body,
    required this.primaryAction,
    required this.primaryRoute,
    this.secondaryAction,
    this.secondaryRoute,
  });
}
