import 'package:adehun_mvp/constants/asset_types.dart';
import 'package:adehun_mvp/controllers/agreement_controller.dart';
import 'package:adehun_mvp/controllers/assets_controller.dart';
import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/controllers/condition_controller.dart';
import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/domain/states/condition_state.dart';
import 'package:adehun_mvp/usecases/params/reject_condition_params.dart';
import 'package:adehun_mvp/utils/agreement_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../utils/condition_status.dart';
import '../widgets/app_bottom_sheet.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_card.dart';
import '../widgets/app_toast.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/avatar_initials.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/info_banner.dart';
import '../widgets/labeled_field.dart';
import '../widgets/list_state_placeholder.dart';
import '../widgets/section_header.dart';
import '../widgets/skeletons.dart';
import '../widgets/status_pill.dart';

class ConditionDetailScreen extends ConsumerStatefulWidget {
  final String conditionId;
  final String agreementId;

  const ConditionDetailScreen({
    super.key,
    required this.conditionId,
    required this.agreementId,
  });

  @override
  ConsumerState<ConditionDetailScreen> createState() =>
      _ConditionDetailScreenState();
}

class _ConditionDetailScreenState extends ConsumerState<ConditionDetailScreen> {
  ConditionResponse? _find(ConditionState state) => state
      .conditionsFor(widget.agreementId)
      .where((c) => c.id == widget.conditionId)
      .firstOrNull;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(assetsControllerProvider.notifier).getConditionAssets(widget.conditionId);
    });
  }

  /// Only the depositor (the payer) signs off on conditions, and only while
  /// the agreement is active and the condition is still open.
  bool _canDecide(String? status) {
    final email = ref.read(authControllerProvider).userData?.email;
    final agreement = ref.read(agreementControllerProvider).maybeWhen(
          data: (s) => s.agreements
              .where((a) => a.id == widget.agreementId)
              .firstOrNull,
          orElse: () => null,
        );
    if (email == null || agreement == null) return false;
    final isDepositor = agreement.depositor?.email == email;
    final isActive = AgreementStatusHelper.isActiveLike(agreement.status);
    const decidable = {
      ConditionStatusHelper.pending,
      ConditionStatusHelper.submitted,
      ConditionStatusHelper.rejected,
    };
    return isDepositor &&
        isActive &&
        decidable.contains(ConditionStatusHelper.normalize(status));
  }

  Future<void> _approve() async {
    final notifier = ref.read(conditionControllerProvider.notifier);
    await notifier.approveCondition(widget.conditionId);
    if (!mounted) return;
    final error = ref.read(conditionControllerProvider).errorMessage;
    if (error != null) {
      showAppToast(context, error, kind: ToastKind.error);
      notifier.clearError();
      return;
    }
    showAppToast(context, 'Condition approved', kind: ToastKind.success);
    // The agreement may have completed (auto-release); refresh the list.
    ref.read(agreementControllerProvider.notifier).refresh();
  }

  Future<void> _reject() async {
    final reason = await showAppBottomSheet<String>(
      context,
      builder: (sheetContext) => const _RejectSheet(),
    );
    if (reason == null || reason.length < 3 || !mounted) return;

    final notifier = ref.read(conditionControllerProvider.notifier);
    await notifier.rejectCondition(
      RejectConditionParams(
        conditionId: widget.conditionId,
        rejectedReason: reason,
      ),
    );
    if (!mounted) return;
    final error = ref.read(conditionControllerProvider).errorMessage;
    if (error != null) {
      showAppToast(context, error, kind: ToastKind.error);
      notifier.clearError();
      return;
    }
    showAppToast(context, 'Sent back with your notes', kind: ToastKind.info);
  }

  Future<void> _refresh() async {
    await Future.wait([
      ref.read(conditionControllerProvider.notifier).refresh(widget.agreementId),
      ref.read(assetsControllerProvider.notifier).getConditionAssets(widget.conditionId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final conditionState = ref.watch(conditionControllerProvider);
    final condition = _find(conditionState);

    if (condition == null) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: const AppTopBar(title: 'Condition'),
        body: conditionState.isLoading
            ? const SingleChildScrollView(
                padding: AppInsets.screen,
                child: ConditionDetailSkeleton(),
              )
            : ListStatePlaceholder.error(
                heading: "Couldn't find this condition",
                detail: 'It may have been removed, or the list is out of date.',
                retryLabel: 'Refresh',
                onRetry: _refresh,
              ),
      );
    }

    final status = condition.status;
    final isMet = ConditionStatusHelper.isMet(status);
    final rejected = ConditionStatusHelper.isRejected(status);
    final requiredFrom = condition.requiredFromParticipant;
    final me = ref.watch(authControllerProvider).userData;
    final whoIsMe = requiredFrom?.user?.email != null &&
        requiredFrom!.user!.email == me?.email;
    final canDecide = _canDecide(status);
    final assetState = ref.watch(assetsControllerProvider);
    final assets = assetState.assetsFor(widget.conditionId);
    final assetsLoading = assets.isEmpty && assetState.isLoading;
    final description = condition.description?.trim();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AppTopBar(title: 'Condition'),
      bottomNavigationBar: canDecide
          ? BottomActionBar(
              secondary: SecondaryButton(
                label: 'Send back',
                tone: ButtonTone.danger,
                loading: conditionState.isRejecting,
                onPressed: conditionState.isRejecting ? null : _reject,
              ),
              primary: PrimaryButton(
                label: 'Approve',
                icon: Iconsax.tick_circle,
                loading: conditionState.isApproving,
                onPressed: conditionState.isApproving ? null : _approve,
              ),
            )
          : null,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.sm,
            AppSpacing.gutter,
            AppSpacing.xxxl,
          ),
          children: [
            StatusPill.condition(status, size: StatusPillSize.md),
            const SizedBox(height: AppSpacing.md),
            Text(
              condition.title ?? 'Untitled condition',
              style: AppTextStyles.h1.copyWith(color: colors.textPrimary),
            ),
            if (description != null && description.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
            if (rejected && (condition.rejectedReason?.trim().isNotEmpty ?? false)) ...[
              const SizedBox(height: AppSpacing.lg),
              InfoBanner(
                tone: BannerTone.error,
                title: 'Sent back',
                message: condition.rejectedReason!.trim(),
              ),
            ],
            if (requiredFrom != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    AvatarInitials(
                      name: whoIsMe ? me?.name : requiredFrom.user?.name,
                      imageUrl: requiredFrom.user?.profilePictureUrl,
                      size: 36,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isMet ? 'Delivered by' : 'Needs',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                          Text(
                            whoIsMe
                                ? 'You'
                                : (requiredFrom.user?.name ?? 'the other party'),
                            style: AppTextStyles.labelLarge.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (requiredFrom.role?.isNotEmpty ?? false)
                      StatusPill(
                        label: _titleCase(requiredFrom.role!),
                        foreground: AppColors.primary,
                        background: colors.primarySurface,
                        size: StatusPillSize.sm,
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),
            SectionHeader(
              title: 'Proof of work',
              padding: EdgeInsets.zero,
              actionLabel: isMet ? null : 'Upload',
              onAction: () => context.push('/upload-assets/${widget.conditionId}'),
            ),
            const SizedBox(height: AppSpacing.md),
            if (assetsLoading)
              const AssetListSkeleton()
            else if (assets.isEmpty)
              AppCard(
                padding: EdgeInsets.zero,
                child: ListStatePlaceholder(
                  compact: true,
                  icon: Iconsax.cloud_add_copy,
                  title: 'Nothing uploaded yet',
                  message: whoIsMe
                      ? 'Upload photos or files that show this is done.'
                      : 'The other party has not uploaded anything yet.',
                  actionLabel: whoIsMe && !isMet ? 'Upload proof' : null,
                  primaryAction: true,
                  onAction: whoIsMe && !isMet
                      ? () => context.push('/upload-assets/${widget.conditionId}')
                      : null,
                ),
              )
            else
              for (var i = 0; i < assets.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: i == assets.length - 1 ? 0 : AppSpacing.sm,
                  ),
                  child: _AssetCard(asset: assets[i]),
                ),
          ],
        ),
      ),
    );
  }

  static String _titleCase(String value) =>
      value.isEmpty ? value : value[0].toUpperCase() + value.substring(1).toLowerCase();
}

class _AssetCard extends StatelessWidget {
  final AssetsResponse asset;

  const _AssetCard({required this.asset});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final name = asset.file.name.split('/').last;
    final isImage = asset.file.type == AssetType.image;

    return AppCard(
      padding: const EdgeInsets.all(14),
      radius: AppRadius.md,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isImage ? colors.primarySurface : colors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.xs + 2),
            ),
            child: Icon(
              isImage ? Iconsax.gallery_copy : Iconsax.document_copy,
              color: isImage ? AppColors.primary : colors.textSecondary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isImage ? 'Image' : 'Document',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          asset.isApproved
              ? StatusPill(
                  label: 'Approved',
                  foreground: AppColors.success,
                  background: colors.successLight,
                  icon: Iconsax.tick_circle,
                  size: StatusPillSize.sm,
                )
              : StatusPill(
                  label: 'Pending',
                  foreground: colors.textSecondary,
                  background: colors.surfaceVariant,
                  icon: Iconsax.timer_1_copy,
                  size: StatusPillSize.sm,
                ),
        ],
      ),
    );
  }
}

class _RejectSheet extends StatefulWidget {
  const _RejectSheet();

  @override
  State<_RejectSheet> createState() => _RejectSheetState();
}

class _RejectSheetState extends State<_RejectSheet> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ready = _controller.text.trim().length >= 3;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Send it back',
          style: AppTextStyles.h2.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Tell them what needs to change so they can fix it and resubmit.',
          style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),
        LabeledField(
          label: 'What needs to change?',
          hint: 'e.g. The logo is missing from the final files',
          controller: _controller,
          autofocus: true,
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: AppSpacing.xxl),
        PrimaryButton(
          label: 'Send back',
          tone: ButtonTone.danger,
          onPressed: ready
              ? () => Navigator.of(context).pop(_controller.text.trim())
              : null,
        ),
        const SizedBox(height: AppSpacing.xs),
        TertiaryButton(
          label: 'Cancel',
          expand: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
