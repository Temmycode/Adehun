import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
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
                      color: AppColors.textSecondary,
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
                        final illustrationSize =
                            (constraints.maxWidth * 0.7).clamp(180.0, 280.0);
                        return Column(
                      children: [
                        const Spacer(flex: 1),
                        // Illustration
                        Container(
                          height: illustrationSize,
                          width: illustrationSize,
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.all(32),
                          child: SvgPicture.asset(
                            page.illustration,
                            fit: BoxFit.contain,
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
                            color: AppColors.textSecondary,
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
                  // Next button
                  GestureDetector(
                    onTap: _nextPage,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Iconsax.arrow_right_2,
                        color: Colors.white,
                        size: 24,
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
    final parts = title.split(accentWord);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.displayMedium,
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
