import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';

class SuccessScreen extends StatefulWidget {
  final String type;

  const SuccessScreen({super.key, required this.type});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _SuccessConfig get _config {
    switch (widget.type) {
      case 'agreement-created':
        return _SuccessConfig(
          illustration: 'assets/illustrations/illustration 4.svg',
          title: 'Agreement Created!',
          subtitle:
              'Your escrow agreement has been created successfully. The other party will receive an invitation to accept.',
          primaryAction: 'View Agreement',
          primaryRoute: '/agreement/1',
          secondaryAction: 'Back to Home',
          secondaryRoute: '/home',
          accentColor: AppColors.primary,
        );
      case 'funds-deposited':
        return _SuccessConfig(
          illustration: 'assets/illustrations/illustration 5.svg',
          title: 'Funds Deposited!',
          subtitle:
              'Your wallet has been funded successfully. You can now use these funds for escrow agreements.',
          primaryAction: 'View Wallet',
          primaryRoute: '/wallet',
          secondaryAction: 'Back to Home',
          secondaryRoute: '/home',
          accentColor: AppColors.success,
        );
      case 'conditions-met':
        return _SuccessConfig(
          illustration: 'assets/illustrations/illustration 6.svg',
          title: 'Conditions Met!',
          subtitle:
              'All conditions have been approved. The funds are ready to be released to the beneficiary.',
          primaryAction: 'View Agreement',
          primaryRoute: '/agreement/2',
          secondaryAction: 'Back to Home',
          secondaryRoute: '/home',
          accentColor: AppColors.success,
        );
      case 'funds-released':
        return _SuccessConfig(
          illustration: 'assets/illustrations/illustration 6.svg',
          title: 'Funds Released!',
          subtitle:
              'The escrow funds have been released successfully. The agreement is now complete. Great deal!',
          primaryAction: 'Back to Home',
          primaryRoute: '/home',
          secondaryAction: 'View Agreements',
          secondaryRoute: '/agreements',
          accentColor: AppColors.success,
        );
      default:
        return _SuccessConfig(
          illustration: 'assets/illustrations/illustration 4.svg',
          title: 'Success!',
          subtitle: 'The action was completed successfully.',
          primaryAction: 'Continue',
          primaryRoute: '/home',
          secondaryAction: null,
          secondaryRoute: null,
          accentColor: AppColors.primary,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final config = _config;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(opacity: _fadeAnimation.value, child: child);
            },
            child: Column(
              children: [
                const Spacer(flex: 2),
                // Animated success icon
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    );
                  },
                  child: SizedBox(
                    height: 260,
                    width: 260,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer ripple ring
                        Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: config.accentColor.withValues(alpha: 0.06),
                              width: 1.5,
                            ),
                          ),
                        ),
                        // Middle ripple ring
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: config.accentColor.withValues(alpha: 0.10),
                              width: 1.5,
                            ),
                          ),
                        ),
                        // Inner soft glow
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: config.accentColor.withValues(alpha: 0.05),
                          ),
                        ),
                        // Illustration
                        ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: SvgPicture.asset(
                            config.illustration,
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Checkmark badge
                        Positioned(
                          bottom: 16,
                          right: 30,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: config.accentColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: config.accentColor
                                      .withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Iconsax.tick_circle,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  config.title,
                  style: AppTextStyles.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  config.subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.textSecondary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 2),
                // Primary action
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go(config.primaryRoute),
                    child: Text(config.primaryAction),
                  ),
                ),
                if (config.secondaryAction != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => context.go(config.secondaryRoute!),
                      child: Text(config.secondaryAction!),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessConfig {
  final String illustration;
  final String title;
  final String subtitle;
  final String primaryAction;
  final String primaryRoute;
  final String? secondaryAction;
  final String? secondaryRoute;
  final Color accentColor;

  _SuccessConfig({
    required this.illustration,
    required this.title,
    required this.subtitle,
    required this.primaryAction,
    required this.primaryRoute,
    required this.secondaryAction,
    required this.secondaryRoute,
    required this.accentColor,
  });
}
