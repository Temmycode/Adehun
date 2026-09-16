import 'package:adehun_mvp/controllers/agreement_controller.dart';
import 'package:adehun_mvp/controllers/assets_controller.dart';
import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/controllers/condition_controller.dart';
import 'package:adehun_mvp/usecases/params/reject_condition_params.dart';
import 'package:adehun_mvp/utils/agreement_status.dart';
import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/domain/states/condition_state.dart';
import 'package:adehun_mvp/utils/random_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
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
  ConditionResponse? _findCondition(ConditionState conditionState) {
    final matches = conditionState
        .conditionsFor(widget.agreementId)
        .where((condition) => condition.id == widget.conditionId);
    return matches.isEmpty ? null : matches.first;
  }

  void getAssets() {
    final assetsProvider = ref.read(assetsControllerProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      assetsProvider.getConditionAssets(widget.conditionId);
    });
  }

  @override
  void initState() {
    super.initState();
    getAssets();
  }

  /// Only the depositor (the payer) signs off on conditions, and only while
  /// the agreement is active and the condition is still open.
  bool _canDecide(String status) {
    final email = ref.read(authControllerProvider).userData?.email;
    final agreement = ref
        .read(agreementControllerProvider)
        .maybeWhen(
          data: (s) => s.agreements
              .where((a) => a.id == widget.agreementId)
              .firstOrNull,
          orElse: () => null,
        );
    if (email == null || agreement == null) return false;
    final isDepositor = agreement.depositor?.email == email;
    final isActive = AgreementStatusHelper.isActiveLike(agreement.status);
    const decidable = {'pending', 'submitted', 'rejected'};
    return isDepositor && isActive && decidable.contains(status.toLowerCase());
  }

  Future<void> _approve() async {
    final notifier = ref.read(conditionControllerProvider.notifier);
    await notifier.approveCondition(widget.conditionId);
    if (!mounted) return;
    final error = ref.read(conditionControllerProvider).errorMessage;
    if (error != null) {
      _snack(error, isError: true);
      notifier.clearError();
      return;
    }
    _snack('Condition approved');
    // The agreement may have completed (auto-release); refresh the list.
    ref.read(agreementControllerProvider.notifier).refresh();
  }

  Future<void> _reject(BuildContext context) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reject condition'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Tell them what needs to change',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Reject'),
          ),
        ],
      ),
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
      _snack(error, isError: true);
      notifier.clearError();
      return;
    }
    _snack('Condition rejected');
  }

  void _snack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.error : null,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _refreshConditionDetails() async {
    await Future.wait([
      ref
          .read(conditionControllerProvider.notifier)
          .refresh(widget.agreementId),
      ref
          .read(assetsControllerProvider.notifier)
          .getConditionAssets(widget.conditionId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final conditionState = ref.watch(conditionControllerProvider);
    final condition = _findCondition(conditionState);
    if (condition == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: () => context.pop(),
          ),
        ),
        body: conditionState.isLoading
            ? const SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: ConditionDetailSkeleton(),
              )
            : const Center(child: Text('Condition not found')),
      );
    }

    final status = condition.status ?? "No status";
    final requiredFrom = condition.requiredFromParticipant;
    final currentUser = ref.watch(authControllerProvider).userData;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Condition Details', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshConditionDetails,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              StatusPill.agreement(status),
              const SizedBox(height: 12),
              Text(condition.title ?? "No title", style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                condition.description ?? "No description",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),

              // Required from participant info
              if (requiredFrom != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.primarySurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.15,
                        ),
                        child: Text(
                          getInitials(requiredFrom.user?.name ?? ""),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Required from',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Row(
                              children: [
                                Text(
                                  requiredFrom.user?.email == currentUser?.email
                                      ? 'You'
                                      : requiredFrom.user?.name ?? "",
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                if (requiredFrom.role != null) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      (requiredFrom.role as String)
                                              .substring(0, 1)
                                              .toUpperCase() +
                                          (requiredFrom.role as String)
                                              .substring(1),
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.primary,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 28),
              // Assets section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text('Assets (${assets.length})', style: AppTextStyles.h3),
                  if (status != 'MET')
                    GestureDetector(
                      onTap: () {
                        context.push('/upload-assets/${widget.conditionId}');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Iconsax.add,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Upload',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              Consumer(
                builder: (context, ref, _) {
                  final assetState = ref.watch(assetsControllerProvider);
                  final assets = assetState.assetsFor(widget.conditionId);

                  // Only spin when there is nothing cached to show yet.
                  if (assets.isEmpty && assetState.isLoading) {
                    return const AssetListSkeleton();
                  }

                  return Column(
                    crossAxisAlignment: .start,
                    children: [
                      if (assets.isEmpty)
                        _EmptyAssets(conditionId: widget.conditionId)
                      else
                        ...assets.map((asset) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _AssetCard(asset: asset),
                          );
                        }),

                      // The depositor decides on a condition while the
                      // agreement is active. The beneficiary only uploads.
                      if (_canDecide(status)) ...[
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: conditionState.isRejecting
                                    ? null
                                    : () => _reject(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                  side: const BorderSide(
                                    color: AppColors.error,
                                  ),
                                ),
                                icon: const Icon(
                                  CupertinoIcons.xmark,
                                  size: 18,
                                ),
                                label: const Text('Reject'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: conditionState.isApproving
                                    ? null
                                    : _approve,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                ),
                                icon: const Icon(Iconsax.tick_circle, size: 18),
                                label: Text(
                                  conditionState.isApproving
                                      ? 'Approving…'
                                      : 'Approve',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssetCard extends StatelessWidget {
  final AssetsResponse asset;

  const _AssetCard({required this.asset});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final name = asset.file.name.split('/').last;
    final type = asset.file.type;
    final status = asset.isApproved ? 'Approved' : 'Pending';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Row(
        children: [
          // File icon/preview
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: type == .image
                  ? colors.primarySurface
                  : colors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              type == .image ? Iconsax.gallery_copy : Iconsax.document_copy,
              color: type == .image ? AppColors.primary : colors.textSecondary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.labelLarge),
                const SizedBox(height: 2),
                Text(
                  type == .image ? 'Image file' : 'Document',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          StatusPill.agreement(status, size: StatusPillSize.sm),
        ],
      ),
    );
  }
}

class _EmptyAssets extends StatelessWidget {
  final String conditionId;

  const _EmptyAssets({required this.conditionId});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Iconsax.cloud_add_copy,
              color: colors.textTertiary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text('No Assets Uploaded', style: AppTextStyles.h3),
          const SizedBox(height: 6),
          Text(
            'Upload proof of work to mark\nthis condition as met',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.push('/upload-assets/$conditionId'),
            icon: const Icon(Iconsax.document_upload_copy, size: 18),
            label: const Text('Upload Asset'),
          ),
        ],
      ),
    );
  }
}
