import 'package:adehun_mvp/controllers/agreement_controller.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
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
import '../widgets/app_chip.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/list_state_placeholder.dart';
import '../widgets/skeletons.dart';

enum _Filter {
  all('All'),
  active('Active'),
  pending('Pending'),
  completed('Completed'),
  disputed('Disputed'),
  refunded('Refunded');

  final String label;
  const _Filter(this.label);

  bool matches(AgreementResponse a) => switch (this) {
        all => true,
        active => AgreementStatusHelper.isActiveLike(a.status),
        pending => AgreementStatusHelper.isPendingLike(a.status),
        completed => AgreementStatusHelper.isCompletedLike(a.status),
        disputed => AgreementStatusHelper.isDisputedLike(a.status),
        refunded => AgreementStatusHelper.isRefundedLike(a.status),
      };
}

class AgreementsListScreen extends ConsumerStatefulWidget {
  const AgreementsListScreen({super.key});

  @override
  ConsumerState<AgreementsListScreen> createState() =>
      _AgreementsListScreenState();
}

class _AgreementsListScreenState extends ConsumerState<AgreementsListScreen> {
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(agreementControllerProvider);
    final all = state.value?.agreements ?? const <AgreementResponse>[];
    final visible = all.where(_filter.matches).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => ref.refresh(agreementControllerProvider.future),
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
                      Expanded(
                        child: Text(
                          'Agreements',
                          style: AppTextStyles.h1.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      AppIconButton(
                        icon: Iconsax.add,
                        semanticLabel: 'Create agreement',
                        onPressed: () => context.push('/create-agreement'),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.lg,
                    bottom: AppSpacing.sm,
                  ),
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: AppInsets.screen,
                      itemCount: _Filter.values.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final filter = _Filter.values[index];
                        final count = filter == _Filter.all
                            ? all.length
                            : all.where(filter.matches).length;
                        return AppChip(
                          label: filter.label,
                          selected: filter == _filter,
                          count: state.hasValue ? count : null,
                          onTap: () => setState(() => _filter = filter),
                        );
                      },
                    ),
                  ),
                ),
              ),
              state.when(
                data: (_) {
                  if (visible.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: all.isEmpty
                          ? ListStatePlaceholder(
                              icon: Iconsax.document_text_copy,
                              illustrationAsset:
                                  'assets/illustrations/onboarding_release.svg',
                              title: 'No agreements yet',
                              message:
                                  'Create one to hold money safely until the work is done.',
                              actionLabel: 'Create an agreement',
                              primaryAction: true,
                              onAction: () => context.push('/create-agreement'),
                            )
                          : ListStatePlaceholder(
                              icon: Iconsax.filter_copy,
                              title: 'Nothing ${_filter.label.toLowerCase()}',
                              message:
                                  'No agreements match this filter right now.',
                              actionLabel: 'Show all',
                              onAction: () =>
                                  setState(() => _filter = _Filter.all),
                            ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.gutter,
                      AppSpacing.sm,
                      AppSpacing.gutter,
                      0,
                    ),
                    sliver: SliverList.separated(
                      itemCount: visible.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final agreement = visible[index];
                        return AgreementCard(
                          key: ValueKey(agreement.id),
                          agreement: agreement,
                          onTap: () =>
                              context.push('/agreement/${agreement.id}'),
                        ).entrance(context, index);
                      },
                    ),
                  );
                },
                loading: () => const SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.sm,
                    AppSpacing.gutter,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(child: AgreementListSkeleton()),
                ),
                error: (err, _) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: ListStatePlaceholder.error(
                    heading: "Couldn't load your agreements",
                    detail: 'Check your connection and try again.',
                    onRetry: () => ref.invalidate(agreementControllerProvider),
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
}
