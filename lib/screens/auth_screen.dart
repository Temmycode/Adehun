import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Illustration
              Container(
                height: 260,
                width: 260,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(32),
                ),
                padding: const EdgeInsets.all(32),
                child: SvgPicture.asset(
                  'assets/illustrations/illustration 4.svg',
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(flex: 1),
              // Welcome text
              Text(
                'Welcome to\nAdehun',
                textAlign: TextAlign.center,
                style: AppTextStyles.displayMedium.copyWith(
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your trusted escrow partner for\nsafe and secure transactions',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 2),
              // Google Sign In button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/profile-completion'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.textPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: AppColors.cardBorder),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google icon
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: _GoogleLogo(),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Continue with Google',
                        style: AppTextStyles.buttonLarge.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'By continuing, you agree to our Terms of\nService and Privacy Policy',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Blue
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawCircle(Offset(w / 2, h / 2), w / 2, bluePaint);

    // White center
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w / 2, h / 2), w / 3.2, whitePaint);

    // G shape approximation with colored arcs
    final rect = Rect.fromLTWH(w * 0.1, h * 0.1, w * 0.8, h * 0.8);

    // Red (top-right)
    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.18;
    canvas.drawArc(rect, -0.9, -1.2, false, redPaint);

    // Yellow (bottom-right)
    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.18;
    canvas.drawArc(rect, 2.0, 1.0, false, yellowPaint);

    // Green (bottom-left)
    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.18;
    canvas.drawArc(rect, 1.0, 1.0, false, greenPaint);

    // Blue bar
    canvas.drawRect(
      Rect.fromLTWH(w * 0.5, h * 0.38, w * 0.4, h * 0.24),
      bluePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
