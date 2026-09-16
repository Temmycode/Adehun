import 'dart:ui';

import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_buttons.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  /// Deliberately spoken, not written. Each slide leads with the thing the
  /// user is actually worried about, and carries its own accent so the flow
  /// has some colour to it.
  static const _pages = [
    _OnboardingPage(
      illustration: 'assets/illustrations/onboarding_safe.svg',
      title: 'Nobody touches\nyour money',
      accentWord: 'your money',
      body:
          "You pay into Adehun, not into a stranger's account. It sits there, untouched, until the work is actually done.",
      accent: AppColors.primary,
    ),
    _OnboardingPage(
      illustration: 'assets/illustrations/onboarding_protected.svg',
      title: "No more\n'send half first'",
      accentWord: "'send half first'",
      body:
          'Agree what has to happen up front. They can see the money is real. You can see exactly what you are paying for.',
      accent: AppColors.accent,
    ),
    _OnboardingPage(
      illustration: 'assets/illustrations/onboarding_release.svg',
      title: 'You decide when\nthey get paid',
      accentWord: 'when\nthey get paid',
      body:
          'Tick things off as they land. Happy with everything? Release it all in one tap.',
      accent: AppColors.gold,
    ),
  ];

  bool get _isLast => _currentPage == _pages.length - 1;

  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    _pageController.nextPage(duration: AppMotion.slow, curve: AppMotion.curve);
  }

  void _finish() {
    ref.read(preferencesServiceProvider).setFirstLaunch(false);
    context.go('/auth');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final page = _pages[_currentPage];

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // The wash behind everything picks up the current slide's accent, so
          // moving through onboarding actually changes the room's colour.
          Positioned.fill(
            child: AnimatedContainer(
              duration: AppMotion.slow,
              curve: AppMotion.curve,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.7, -0.75),
                  radius: 1.15,
                  colors: [
                    page.accent.withValues(
                      alpha: context.isDarkMode ? 0.26 : 0.18,
                    ),
                    colors.background.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 48,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedOpacity(
                      duration: AppMotion.fast,
                      opacity: _isLast ? 0 : 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.md),
                        child: TertiaryButton(
                          label: 'Skip',
                          onPressed: _isLast ? null : _finish,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (context, index) =>
                        _SlideView(page: _pages[index]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    0,
                    AppSpacing.gutter,
                    AppSpacing.lg,
                  ),
                  child: Column(
                    children: [
                      _Dots(
                        count: _pages.length,
                        current: _currentPage,
                        accent: page.accent,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      PrimaryButton(
                        label: _isLast ? "Let's go" : 'Next',
                        onPressed: _next,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TertiaryButton(
                        label: 'I already have an account',
                        expand: true,
                        onPressed: _finish,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  final _OnboardingPage page;

  const _SlideView({required this.page});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: AppInsets.screen,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final artHeight = (constraints.maxHeight * 0.44).clamp(180.0, 320.0);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: artHeight,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // A soft disc of the slide's accent, sitting behind the
                    // art so the card is lit rather than pasted on.
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 34, sigmaY: 34),
                      child: Container(
                        width: artHeight * 0.86,
                        height: artHeight * 0.86,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: page.accent.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.illustrationCanvas,
                        borderRadius: BorderRadius.circular(AppRadius.xl + 10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textPrimary.withValues(
                              alpha: 0.10,
                            ),
                            blurRadius: 36,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        page.illustration,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              _AccentTitle(
                title: page.title,
                accentWord: page.accentWord,
                accent: page.accent,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                page.body,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AccentTitle extends StatelessWidget {
  final String title;
  final String accentWord;
  final Color accent;

  const _AccentTitle({
    required this.title,
    required this.accentWord,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Bigger and tighter than the rest of the app on purpose: this is the
    // only place the product gets to introduce itself.
    final style = AppTextStyles.displayLarge.copyWith(
      color: colors.textPrimary,
      fontSize: 34,
      height: 1.1,
      letterSpacing: -1,
    );
    final parts = title.split(accentWord);
    // Gold is too light for body-size text on cream, so the accent word uses
    // the darker cut of whichever hue the slide is carrying.
    final inkedAccent = accent == AppColors.gold
        ? AppColors.goldDark
        : accent == AppColors.accent
        ? AppColors.accentDark
        : AppColors.primary;

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          if (parts.isNotEmpty) TextSpan(text: parts[0]),
          TextSpan(
            text: accentWord,
            style: style.copyWith(color: inkedAccent),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int current;
  final Color accent;

  const _Dots({
    required this.count,
    required this.current,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = index == current;
        return AnimatedContainer(
          duration: AppMotion.normal,
          curve: AppMotion.curve,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 26 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? accent : colors.cardBorder,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _OnboardingPage {
  final String illustration;
  final String title;
  final String accentWord;
  final String body;
  final Color accent;

  const _OnboardingPage({
    required this.illustration,
    required this.title,
    required this.accentWord,
    required this.body,
    required this.accent,
  });
}
