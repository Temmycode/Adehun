import 'package:adehun_mvp/controllers/agreement_controller.dart';
import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/controllers/condition_controller.dart';
import 'package:adehun_mvp/controllers/stats_controller.dart';
import 'package:adehun_mvp/controllers/unread_count_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_color_scheme.dart';
import '../widgets/wallet_card.dart';
import '../widgets/agreement_card.dart';
import '../widgets/skeletons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Get active agreements only

    String generateInitials(String username) {
      return username.split(' ').map((name) => name[0]).join('');
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar
            Consumer(
              builder: (context, ref, _) {
                final user = ref.watch(authControllerProvider).userData;
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: colors.primarySurface,
                          child: Text(
                            generateInitials(user?.name ?? "User"),
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                              Text(
                                user?.name ?? "User",
                                style: AppTextStyles.h3.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, _) {
                            final unreadCount = ref
                                .watch(unreadCountControllerProvider)
                                .maybeWhen(
                                  data: (count) => count,
                                  orElse: () => 0,
                                );
                            return _IconButton(
                              icon: Iconsax.notification_copy,
                              badgeCount: unreadCount,
                              onTap: () => context.push('/notifications'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Wallet card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: WalletCard(
                  compact: true,
                  showActions: false,
                  onFundWallet: () => context.push('/fund-wallet'),
                ),
              ),
            ),

            // Quick actions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickAction(
                        icon: Iconsax.add_circle_copy,
                        label: 'New Agreement',
                        color: AppColors.primary,
                        onTap: () => context.push('/create-agreement'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickAction(
                        icon: Iconsax.wallet_3_copy,
                        label: 'Fund Wallet',
                        color: AppColors.accent,
                        onTap: () => context.push('/fund-wallet'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickAction(
                        icon: Iconsax.document_text_copy,
                        label: 'Agreements',
                        color: AppColors.info,
                        onTap: () => context.go('/agreements'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Analytics overview
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: _AnalyticsCard(),
              ),
            ),

            // Active agreements header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active Agreements',
                      style: AppTextStyles.h3.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),

                    GestureDetector(
                      onTap: () => context.go('/agreements'),
                      child: Text(
                        'See all',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Active agreements list
            Consumer(
              builder: (context, ref, _) {
                final agreementState = ref.watch(agreementControllerProvider);
                final statsState = ref.watch(statsControllerProvider);
                final conditionController = ref.read(
                  conditionControllerProvider.notifier,
                );

                return agreementState.when(
                  data: (stateData) {
                    final activeAgreements = stateData.agreements
                        .where((agt) => agt.status == 'active')
                        .toList();

                    if (activeAgreements.isEmpty) {
                      final hasNoAgreementsAtAll = statsState.maybeWhen(
                        data: (s) => s.totalAgreements == 0,
                        orElse: () => stateData.agreements.isEmpty,
                      );
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(24, 8, 24, 0),
                          child: hasNoAgreementsAtAll
                              ? const _HomeEmptyState()
                              : const _NoActiveAgreementsState(),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final agreement = activeAgreements[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AgreementCard(
                              agreement: agreement,
                              conditions: conditionController
                                  .getAgreementConditions(agreement.id!),
                              onTap: () {
                                context.push('/agreement/${agreement.id}');
                              },
                            ),
                          );
                        }, childCount: activeAgreements.length),
                      ),
                    );
                  },
                  loading: () => const SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverToBoxAdapter(
                      child: AgreementListSkeleton(count: 3),
                    ),
                  ),
                  error: (err, stk) => SliverToBoxAdapter(
                    child: Text(
                      'An error occurred $err',
                      style: TextTheme.of(
                        context,
                      ).bodyMedium?.copyWith(color: Colors.red),
                    ),
                  ),
                );
              },
            ),

            // Bottom spacing to clear floating nav bar
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final int badgeCount;
  final VoidCallback onTap;

  const _IconButton({
    required this.icon,
    this.badgeCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: colors.textPrimary, size: 22),
            if (badgeCount > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      badgeCount > 99 ? '99+' : '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Consumer(
      builder: (context, ref, _) {
        final agreementStats = ref.watch(statsControllerProvider);
        return agreementStats.when(
          data: (stats) {
            final maxVal = stats.totalAgreements > 0
                ? stats.totalAgreements
                : 1;

            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Iconsax.chart_1_copy,
                        size: 16,
                        color: colors.textTertiary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Agreement Overview',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _BarRow(
                    label: 'Active',
                    count: stats.activeAgreements,
                    fraction: stats.activeAgreements / maxVal,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  _BarRow(
                    label: 'Completed',
                    count: stats.completedAgreements,
                    fraction: stats.completedAgreements / maxVal,
                    color: AppColors.success,
                  ),
                  const SizedBox(height: 12),
                  _BarRow(
                    label: 'Total',
                    count: stats.totalAgreements,
                    fraction: stats.totalAgreements == 0 ? 0.0 : 1.0,
                    color: AppColors.accent,
                  ),
                ],
              ),
            );
          },
          loading: () => const AnalyticsCardSkeleton(),
          error: (err, _) => Text(
            'An error occurred $err',
            style: TextTheme.of(
              context,
            ).bodyMedium?.copyWith(color: Colors.red),
          ),
        );
      },
    );
  }
}

class _BarRow extends StatelessWidget {
  final String label;
  final int count;
  final double fraction;
  final Color color;

  const _BarRow({
    required this.label,
    required this.count,
    required this.fraction,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: colors.textSecondary,
              fontSize: 11,
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    height: 8,
                    width: constraints.maxWidth * fraction.clamp(0.0, 1.0),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 20,
          child: Text(
            '$count',
            textAlign: TextAlign.right,
            style: AppTextStyles.numberSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _NoActiveAgreementsState extends StatelessWidget {
  const _NoActiveAgreementsState();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Iconsax.clock_copy,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No active agreements',
            style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Your pending and completed agreements\nare available in the full list',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: () => context.go('/agreements'),
            child: const Text('View all agreements'),
          ),
        ],
      ),
    );
  }
}

class _HomeEmptyState extends StatelessWidget {
  const _HomeEmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.primarySurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Iconsax.document_text_copy,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'No agreements yet',
            style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Create your first escrow agreement\nto see it here',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
