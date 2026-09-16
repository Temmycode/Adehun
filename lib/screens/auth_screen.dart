import 'dart:math' as math;
import 'dart:ui';
import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    // Rotation: full 360° orbit
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    // Scale: start small, grow and settle
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.4,
          end: 1.1,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.1,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLoading = ref.watch(authLoadingProvider);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: colors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  // Animated orbiting blobs
                  SizedBox(
                    height: 280,
                    width: 280,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final rotation = _rotationAnimation.value;
                        final scale = _scaleAnimation.value;

                        return Transform.scale(
                          scale: scale,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Primary sphere — orbits at radius 70
                              Positioned(
                                left: 140 + 70 * math.cos(rotation) - 55,
                                top: 140 + 70 * math.sin(rotation) - 55,
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                    sigmaX: 6,
                                    sigmaY: 6,
                                  ),
                                  child: _GlossySphere(
                                    size: 110,
                                    baseColor: AppColors.primary,
                                    highlightOffset: const Alignment(
                                      -0.35,
                                      -0.4,
                                    ),
                                  ),
                                ),
                              ),
                              // Accent sphere — orbits opposite, radius 65
                              Positioned(
                                left:
                                    140 +
                                    65 * math.cos(rotation + math.pi) -
                                    45,
                                top:
                                    140 +
                                    65 * math.sin(rotation + math.pi) -
                                    45,
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                    sigmaX: 7,
                                    sigmaY: 7,
                                  ),
                                  child: _GlossySphere(
                                    size: 90,
                                    baseColor: AppColors.accent,
                                    highlightOffset: const Alignment(
                                      -0.3,
                                      -0.45,
                                    ),
                                  ),
                                ),
                              ),
                              // Third sphere — offset orbit, radius 55
                              Positioned(
                                left:
                                    140 +
                                    55 * math.cos(rotation + math.pi * 0.6) -
                                    40,
                                top:
                                    140 +
                                    55 * math.sin(rotation + math.pi * 0.6) -
                                    40,
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                    sigmaX: 8,
                                    sigmaY: 8,
                                  ),
                                  child: _GlossySphere(
                                    size: 80,
                                    baseColor: AppColors.primaryLight,
                                    highlightOffset: const Alignment(
                                      -0.25,
                                      -0.35,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Spacer(flex: 1),
                  // Welcome text
                  Text(
                    'Welcome to\nAdehun',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.displayMedium.copyWith(
                      height: 1.2,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your trusted escrow partner for\nsafe and secure transactions',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(flex: 2),

                  // Google Sign In button
                  _GoogleSignInButton(),

                  const SizedBox(height: 16),
                  Text(
                    'By continuing, you agree to our Terms of\nService and Privacy Policy',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textTertiary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black54,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class _GoogleSignInButton extends ConsumerWidget {
  void _handleGoogleSignIn(BuildContext context, WidgetRef ref) async {
    final isLoading = ref.watch(authLoadingProvider);
    final authController = ref.read(authControllerProvider.notifier);
    if (isLoading) return;

    await authController.googleSignIn();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleGoogleSignIn(context, ref),
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.surface,
          foregroundColor: colors.textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: colors.cardBorder),
          ),
        ),
        child: Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/google.png', width: 24, height: 24),
            Text(
              'Continue with Google',
              style: AppTextStyles.buttonLarge.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlossySphere extends StatelessWidget {
  final double size;
  final Color baseColor;
  final Alignment highlightOffset;

  const _GlossySphere({
    required this.size,
    required this.baseColor,
    required this.highlightOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Nearly flat gradient — very subtle depth
        gradient: RadialGradient(
          center: highlightOffset,
          radius: 0.95,
          colors: [
            Color.lerp(baseColor, Colors.white, 0.06)!,
            baseColor,
            Color.lerp(baseColor, Colors.black, 0.04)!,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -2,
          ),
        ],
      ),
    );
  }
}
