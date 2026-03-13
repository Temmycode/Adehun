import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      illustration: 'assets/illustrations/illustration 1.svg',
      title: 'Secure Escrow\nMade Simple',
      subtitle:
          'Adehun holds funds safely until both parties are satisfied. No more trust issues with online transactions.',
      accentWord: 'Escrow',
    ),
    _OnboardingPage(
      illustration: 'assets/illustrations/illustration 2.svg',
      title: 'Protection For\nBoth Parties',
      subtitle:
          'Whether you\'re paying for a service or delivering one, Adehun ensures fair deals with clear conditions.',
      accentWord: 'Both',
    ),
    _OnboardingPage(
      illustration: 'assets/illustrations/illustration 3.svg',
      title: 'Ready To Start\nSecure Deals?',
      subtitle:
          'Create agreements, set conditions, and let Adehun handle the trust. Your money, your terms.',
      accentWord: 'Secure',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/auth');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () => context.go('/auth'),
                  child: Text(
                    'Skip',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final illustrationSize = (constraints.maxWidth * 0.7)
                            .clamp(180.0, 280.0);
                        return Column(
                          children: [
                            const Spacer(flex: 1),
                            // Illustration — free-floating with soft shadow
                            Container(
                              height: illustrationSize,
                              width: index != 1
                                  ? double.maxFinite
                                  : illustrationSize,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.08,
                                    ),
                                    blurRadius: 40,
                                    offset: const Offset(0, 12),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: SvgPicture.asset(
                                  page.illustration,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Spacer(flex: 1),
                            // Title with accent
                            _buildTitle(page.title, page.accentWord),
                            const SizedBox(height: 16),
                            // Subtitle
                            Text(
                              page.subtitle,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: colors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                            const Spacer(flex: 2),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // Bottom section: dots + button
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page dots
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        width: index == _currentPage ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Next button with circular progress
                  GestureDetector(
                    onTap: _nextPage,
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: CustomPaint(
                        painter: _CircularProgressPainter(
                          progress: (_currentPage + 1) / _pages.length,
                          trackColor: AppColors.primary.withValues(alpha: 0.15),
                          progressColor: AppColors.primary,
                          strokeWidth: 3,
                        ),
                        child: Center(
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            child: const Icon(
                              CupertinoIcons.arrow_right,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title, String accentWord) {
    final colors = context.colors;
    final parts = title.split(accentWord);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.displayMedium.copyWith(
          color: colors.textPrimary,
        ),
        children: [
          if (parts.isNotEmpty) TextSpan(text: parts[0]),
          TextSpan(
            text: accentWord,
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.accent,
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final String illustration;
  final String title;
  final String subtitle;
  final String accentWord;

  _OnboardingPage({
    required this.illustration,
    required this.title,
    required this.subtitle,
    required this.accentWord,
  });
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
