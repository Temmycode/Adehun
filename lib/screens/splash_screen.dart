import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/router/auth_route_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../widgets/mesh_surface.dart';
import '../widgets/orbiting_blobs.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      final prefs = ref.read(preferencesServiceProvider);
      authRouteNotifier.setFirstLaunch(prefs.isFirstLaunch);
      // A stored token, not the prefs flag, is what makes a session.
      if (authRouteNotifier.hasSession) {
        final pending = authRouteNotifier.consumeRedirectAfterLogin();
        context.go(pending ?? '/home');
      } else if (prefs.isFirstLaunch) {
        context.go('/onboarding');
      } else {
        context.go('/auth');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduced = AppMotion.reduced(context);

    Widget mark = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AdehunMark(size: 96),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Adehun',
          style: AppTextStyles.displayLarge.copyWith(
            color: Colors.white,
            fontSize: 38,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Agreements you can trust',
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    );

    if (!reduced) {
      mark = mark
          .animate()
          .fadeIn(duration: AppMotion.slow, curve: AppMotion.curve)
          .scale(
            begin: const Offset(0.86, 0.86),
            end: const Offset(1, 1),
            duration: 600.ms,
            curve: Curves.easeOutBack,
          );
    }

    return Scaffold(
      body: MeshSurface(
        gradient: AppGradients.brandDeep,
        child: SizedBox.expand(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // The same blobs that carry the auth screen, dimmed right down
              // so the wordmark still leads.
              Opacity(
                opacity: 0.5,
                child: OrbitingBlobs(
                  size: MediaQuery.sizeOf(context).width * 1.1,
                  blobs: const [
                    BlobSpec(
                      size: 0.34,
                      color: Color(0xFF2E8B6E),
                      orbit: 0.34,
                      phase: 0,
                      blur: 40,
                    ),
                    BlobSpec(
                      size: 0.27,
                      color: AppColors.accent,
                      orbit: 0.30,
                      phase: 0.5,
                      blur: 46,
                    ),
                    BlobSpec(
                      size: 0.22,
                      color: AppColors.gold,
                      orbit: 0.26,
                      phase: 0.3,
                      blur: 50,
                    ),
                  ],
                ),
              ),
              mark,
            ],
          ),
        ),
      ),
    );
  }
}

/// The "A" tile used on splash, auth and the invite landing page.
class AdehunMark extends StatelessWidget {
  final double size;
  final bool onPrimary;

  const AdehunMark({super.key, this.size = 48, this.onPrimary = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: onPrimary ? const Color(0xFFFFFCF5) : AppColors.primary,
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: onPrimary
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: size * 0.3,
                  offset: Offset(0, size * 0.1),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        'A',
        style: AppTextStyles.displayLarge.copyWith(
          color: onPrimary ? AppColors.primary : Colors.white,
          fontSize: size * 0.5,
          fontWeight: FontWeight.w800,
          height: 1,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
