import 'package:adehun_mvp/providers/agreement_controller.dart';
import 'package:adehun_mvp/providers/auth_controller.dart';
import 'package:adehun_mvp/providers/condition_controller.dart';
import 'package:adehun_mvp/providers/stats_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_color_scheme.dart';
import '../constants/mock_data.dart';
import '../widgets/wallet_card.dart';
import '../widgets/agreement_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final agreementController = context.read<AgreementController>();
    final conditionsController = context.read<ConditionController>();

    Future.wait([
      agreementController.getAllAgreements(),
      conditionsController.getUsersConditions(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Get active agreements only
    final activeAgreements = MockData.agreements
        .where(
          (a) =>
              a['status'] == 'ACTIVE' ||
              a['status'] == 'CONDITIONS_IN_PROGRESS' ||
              a['status'] == 'PENDING_ACCEPTANCE',
        )
        .toList();

    String generateInitials(String username) {
      return username.split(' ').map((name) => name[0]).join('');
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar
            Consumer<AuthController>(
              builder: (context, auth, _) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: colors.primarySurface,
                          child: Text(
                            generateInitials(auth.user?.name ?? "User"),
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
                                auth.user?.name ?? "User",
                                style: AppTextStyles.h3.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _IconButton(
                          icon: Iconsax.notification_copy,
                          badgeCount: 2,
                          onTap: () => context.push('/notifications'),
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
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final agreement = activeAgreements[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AgreementCard(
                      agreement: agreement,
                      onTap: () =>
                          context.push('/agreement/${agreement['id']}'),
                    ),
                  );
                }, childCount: activeAgreements.length),
              ),
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
                top: 8,
                right: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$badgeCount',
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

    return Consumer<StatsController>(
      builder: (context, statsProvider, _) {
        final maxVal = statsProvider.agreementStats.totalAgreements > 0
            ? statsProvider.agreementStats.totalAgreements
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
                count: statsProvider.agreementStats.activeAgreements,
                fraction:
                    statsProvider.agreementStats.activeAgreements / maxVal,
                color: AppColors.primary,
              ),
              const SizedBox(height: 12),
              _BarRow(
                label: 'Completed',
                count: statsProvider.agreementStats.completedAgreements,
                fraction:
                    statsProvider.agreementStats.completedAgreements / maxVal,
                color: AppColors.success,
              ),
              const SizedBox(height: 12),
              _BarRow(
                label: 'Total',
                count: statsProvider.agreementStats.totalAgreements,
                fraction: 1.0,
                color: AppColors.accent,
              ),
            ],
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
