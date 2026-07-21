import 'package:adehun_mvp/controllers/assets_controller.dart';
import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/controllers/condition_controller.dart';
import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
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
import '../widgets/status_badge.dart';

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
  ConditionResponse? _findCondition(WidgetRef ref) {
    final conditionState = ref.read(conditionControllerProvider);
    return conditionState.maybeWhen(
      data: (state) => state.conditions[widget.agreementId]?.firstWhere(
        (condition) => condition.id == widget.conditionId,
      ),
      orElse: () => null,
    );
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
    final condition = _findCondition(ref);
    if (condition == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: Text('Condition not found')),
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
              StatusBadge(status: status),
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

                  return assetState.when(
                    data: (state) {
                      final assets = state.assets[widget.conditionId] ?? [];
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

                          // Approve/Reject buttons for review
                          if (status == 'IN_PROGRESS' && assets.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
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
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.success,
                                    ),
                                    icon: const Icon(
                                      Iconsax.tick_circle,
                                      size: 18,
                                    ),
                                    label: const Text('Approve'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      );
                    },
                    loading: () => const _AssetListSkeleton(),
                    error: (err, stk) => const Center(child: Icon(Icons.error)),
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
              color: type == 'image'
                  ? colors.primarySurface
                  : colors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              type == 'image' ? Iconsax.gallery_copy : Iconsax.document_copy,
              color: type == 'image' ? AppColors.primary : colors.textSecondary,
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
                  type == 'image' ? 'Image file' : 'Document',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          StatusBadge(status: status, compact: true),
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

class _AssetListSkeleton extends StatelessWidget {
  const _AssetListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.colors.cardBorder),
              ),
              child: Row(
                children: const [
                  SkeletonBox(width: 48, height: 48, radius: 10),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(width: double.infinity, height: 14),
                        SizedBox(height: 8),
                        SkeletonBox(width: 120, height: 10),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  SkeletonBox(width: 64, height: 20, radius: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
