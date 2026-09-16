import 'package:adehun_mvp/controllers/agreement_controller.dart';
import 'package:adehun_mvp/controllers/attention_controller.dart';
import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/controllers/invitation_providers.dart';
import 'package:adehun_mvp/controllers/stats_controller.dart';
import 'package:adehun_mvp/controllers/unread_count_controller.dart';
import 'package:adehun_mvp/controllers/wallet_card_balance_notifier.dart';
import 'package:adehun_mvp/controllers/wallet_data_controller.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/models/attention_item.dart';
import 'package:adehun_mvp/shell/app_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_motion.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../utils/agreement_status.dart';
import '../widgets/agreement_card.dart';
import '../widgets/app_card.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/attention_card.dart';
import '../widgets/avatar_initials.dart';
import '../widgets/how_escrow_works_card.dart';
import '../widgets/list_state_placeholder.dart';
import '../widgets/section_header.dart';
import '../widgets/skeletons.dart';
import '../widgets/wallet_card.dart';

const _howItWorksDismissedKey = 'home_how_it_works_dismissed';
const _maxActiveOnHome = 5;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late bool _howItWorksDismissed;

  @override
  void initState() {
    super.initState();
    _howItWorksDismissed =
        ref.read(sharedPreferencesProvider).getBool(_howItWorksDismissedKey) ??
        false;
  }

  Future<void> _refresh() async {
    ref.read(walletDataControllerProvider.notifier).refresh();
    ref.read(unreadCountControllerProvider.notifier).refresh();
    await Future.wait<Object?>([
      ref.refresh(agreementControllerProvider.future),
      ref.refresh(invitedAgreementsProvider.future),
      ref.read(statsControllerProvider.notifier).refresh(),
    ]);
  }

  void _dismissHowItWorks() {
    setState(() => _howItWorksDismissed = true);
    ref.read(sharedPreferencesProvider).setBool(_howItWorksDismissedKey, true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final user = ref.watch(authControllerProvider).userData;
    final unread = ref.watch(unreadCountControllerProvider).value ?? 0;
    final agreements = ref.watch(agreementControllerProvider);
    final attention = ref.watch(attentionItemsProvider);
    final attentionLoading =
        agreements.isLoading || ref.watch(invitedAgreementsProvider).isLoading;

    final allAgreements = agreements.value?.agreements ?? const [];
    final active = allAgreements
        .where((a) => AgreementStatusHelper.isActiveLike(a.status))
        .take(_maxActiveOnHome)
        .toList();
    final hasNone = agreements.hasValue && allAgreements.isEmpty;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.md,
                    AppSpacing.gutter,
                    0,
                  ),
                  child: Row(
                    children: [
                      AvatarInitials(
                        name: user?.name,
                        imageUrl: user?.profilePictureUrl,
                        size: 44,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // With no name yet, the greeting carries the line
                            // on its own rather than sitting above a "there".
                            if (_firstName(user?.name) case final name?) ...[
                              Text(
                                _greeting(),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.h2.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                            ] else
                              Text(
                                _greeting(),
                                style: AppTextStyles.h2.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                          ],
                        ),
                      ),
                      AppIconButton(
                        icon: Iconsax.notification_copy,
                        semanticLabel: unread > 0
                            ? 'Notifications, $unread unread'
                            : 'Notifications',
                        showDot: unread > 0,
                        onPressed: () => context.push('/notifications'),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.xl,
                    AppSpacing.gutter,
                    0,
                  ),
                  child: WalletCard(
                    compact: true,
                    balanceVisible: balanceVisibleNotifier,
                    onFundWallet: () => context.push('/fund-wallet'),
                    onWithdraw: () => context.push('/withdraw'),
                  ).entrance(context, 0),
                ),
              ),

              if (attentionLoading && attention.isEmpty)
                const _AttentionSection.loading()
              else if (attention.isNotEmpty)
                _AttentionSection(items: attention),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.xxl,
                    AppSpacing.gutter,
                    0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _QuickAction(
                          icon: Iconsax.add_circle,
                          label: 'New agreement',
                          tint: AppColors.primary,
                          background: colors.primarySurface,
                          onTap: () => context.push('/create-agreement'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _QuickAction(
                          icon: Iconsax.wallet_add,
                          label: 'Fund wallet',
                          tint: AppColors.accentDark,
                          background: colors.accentLight,
                          onTap: () => context.push('/fund-wallet'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _QuickAction(
                          icon: Iconsax.document_text,
                          label: 'Agreements',
                          tint: AppColors.goldDark,
                          background: colors.goldLight,
                          onTap: () => context.go('/agreements'),
                        ),
                      ),
                    ],
                  ).entrance(context, 1),
                ),
              ),

              if (hasNone && !_howItWorksDismissed)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.gutter,
                      AppSpacing.xxl,
                      AppSpacing.gutter,
                      0,
                    ),
                    child: HowEscrowWorksCard(
                      onDismiss: _dismissHowItWorks,
                      onCreate: () => context.push('/create-agreement'),
                    ).entrance(context, 2),
                  ),
                ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.xxl,
                    bottom: AppSpacing.sm,
                  ),
                  child: SectionHeader(
                    title: 'Active agreements',
                    actionLabel: allAgreements.isEmpty ? null : 'See all',
                    onAction: () => context.go('/agreements'),
                  ),
                ),
              ),

              agreements.when(
                data: (_) {
                  if (active.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: AppInsets.screen,
                        child: AppCard(
                          padding: EdgeInsets.zero,
                          child: hasNone
                              ? ListStatePlaceholder(
                                  compact: true,
                                  icon: Iconsax.document_text_copy,
                                  title: 'No agreements yet',
                                  message:
                                      'Create one to hold money safely until the work is done.',
                                  actionLabel: 'Create an agreement',
                                  primaryAction: true,
                                  onAction: () =>
                                      context.push('/create-agreement'),
                                )
                              : ListStatePlaceholder(
                                  compact: true,
                                  icon: Iconsax.timer_1_copy,
                                  title: 'Nothing active right now',
                                  message:
                                      'Pending and completed agreements live in the full list.',
                                  actionLabel: 'View all agreements',
                                  onAction: () => context.go('/agreements'),
                                ),
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: AppInsets.screen,
                    sliver: SliverList.separated(
                      itemCount: active.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final agreement = active[index];
                        return AgreementCard(
                          agreement: agreement,
                          onTap: () =>
                              context.push('/agreement/${agreement.id}'),
                        ).entrance(context, index + 2);
                      },
                    ),
                  );
                },
                loading: () => const SliverPadding(
                  padding: AppInsets.screen,
                  sliver: SliverToBoxAdapter(
                    child: AgreementListSkeleton(count: 3),
                  ),
                ),
                error: (err, _) => SliverToBoxAdapter(
                  child: Padding(
                    padding: AppInsets.screen,
                    child: AppCard(
                      padding: EdgeInsets.zero,
                      child: ListStatePlaceholder.error(
                        compact: true,
                        heading: "Couldn't load your agreements",
                        detail: 'Pull down to try again.',
                        onRetry: _refresh,
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: SizedBox(height: context.navBottomPadding),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  /// Null when we do not know the user's name yet, so the caller can fall
  /// back rather than greeting them as "there".
  static String? _firstName(String? name) {
    final trimmed = (name ?? '').trim();
    if (trimmed.isEmpty) return null;
    return trimmed.split(RegExp(r'\s+')).first;
  }
}

class _AttentionSection extends StatelessWidget {
  final List<AttentionItem> items;
  final bool loading;

  const _AttentionSection({required this.items}) : loading = false;

  const _AttentionSection.loading() : items = const [], loading = true;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Needs your attention',
              trailing: loading || items.isEmpty
                  ? null
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        '${items.length}',
                        style: AppTextStyles.numberSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 68,
              child: loading
                  ? const AttentionListSkeleton()
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: AppInsets.screen,
                      itemCount: items.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return AttentionCard(
                          key: ValueKey(item.key),
                          item: item,
                          onTap: () => context.push(item.route),
                        ).entrance(context, index);
                      },
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
  final Color tint;
  final Color background;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.tint,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.sm,
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: tint, size: 22),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelMedium.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
