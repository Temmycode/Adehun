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

  static const _pages = [
    _OnboardingPage(
      illustration: 'assets/illustrations/onboarding_safe.svg',
      title: 'Your money is held safely',
      accentWord: 'safely',
      body:
          'Pay into Adehun, not the other person. We hold the money until the work is done and you say so.',
    ),
    _OnboardingPage(
      illustration: 'assets/illustrations/onboarding_protected.svg',
      title: 'Both sides are protected',
      accentWord: 'protected',
      body:
          'Agree on clear conditions up front. The seller knows the money is there. The buyer only releases it when the conditions are met.',
    ),
    _OnboardingPage(
      illustration: 'assets/illustrations/onboarding_release.svg',
      title: "Release when you're happy",
      accentWord: 'happy',
      body:
          "Tick off each condition as it's delivered. When everything checks out, release the funds in one tap.",
    ),
  ];

  bool get _isLast => _currentPage == _pages.length - 1;

  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: AppMotion.slow,
      curve: AppMotion.curve,
    );
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
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
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
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => _SlideView(page: _pages[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.sm,
                AppSpacing.gutter,
                AppSpacing.lg,
              ),
              child: Column(
                children: [
                  _Dots(count: _pages.length, current: _currentPage),
                  const SizedBox(height: AppSpacing.xl),
                  PrimaryButton(
                    label: _isLast ? 'Get started' : 'Next',
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
          final artHeight = (constraints.maxHeight * 0.42).clamp(180.0, 300.0);
          return Column(
            children: [
              const Spacer(),
              Container(
                height: artHeight,
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.xl + 8),
                ),
                child: SvgPicture.asset(page.illustration, fit: BoxFit.contain),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              _AccentTitle(title: page.title, accentWord: page.accentWord),
              const SizedBox(height: AppSpacing.md),
              Text(
                page.body,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(flex: 2),
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

  const _AccentTitle({required this.title, required this.accentWord});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = AppTextStyles.displayMedium.copyWith(color: colors.textPrimary);
    final parts = title.split(accentWord);
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          if (parts.isNotEmpty) TextSpan(text: parts[0]),
          TextSpan(
            text: accentWord,
            style: style.copyWith(color: AppColors.primary),
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

  const _Dots({required this.count, required this.current});

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
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : colors.cardBorder,
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

  const _OnboardingPage({
    required this.illustration,
    required this.title,
    required this.accentWord,
    required this.body,
  });
}
