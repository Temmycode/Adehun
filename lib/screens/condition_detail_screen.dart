import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/mock_data.dart';
import '../widgets/status_badge.dart';

class ConditionDetailScreen extends StatelessWidget {
  final String conditionId;

  const ConditionDetailScreen({super.key, required this.conditionId});

  Map<String, dynamic>? _findCondition() {
    for (final agreement in MockData.agreements) {
      final conditions = agreement['conditions'] as List;
      for (final condition in conditions) {
        if (condition['id'] == conditionId) {
          return condition;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final condition = _findCondition();
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

    final status = condition['status'] as String;
    final assets = condition['assets'] as List;
    final requiredFrom =
        condition['requiredFrom'] as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Condition Details', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            StatusBadge(status: status),
            const SizedBox(height: 12),
            Text(
              condition['title'] as String,
              style: AppTextStyles.h1,
            ),
            const SizedBox(height: 8),
            Text(
              condition['description'] as String,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            // Required from participant info
            if (requiredFrom != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.15),
                      child: Text(
                        requiredFrom['initials'] as String,
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
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Row(
                            children: [
                              Text(
                                requiredFrom['name'] == MockData.userName
                                    ? 'You'
                                    : requiredFrom['name'] as String,
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              if (requiredFrom['role'] != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    (requiredFrom['role'] as String)
                                        .substring(0, 1)
                                        .toUpperCase() +
                                        (requiredFrom['role'] as String)
                                            .substring(1),
                                    style:
                                        AppTextStyles.labelSmall.copyWith(
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
                Text(
                  'Assets (${assets.length})',
                  style: AppTextStyles.h3,
                ),
                if (status != 'MET')
                  GestureDetector(
                    onTap: () =>
                        context.push('/upload-assets/$conditionId'),
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
                          const Icon(Iconsax.add,
                              color: Colors.white, size: 16),
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

            if (assets.isEmpty)
              _EmptyAssets(conditionId: conditionId)
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
                        side: const BorderSide(color: AppColors.error),
                      ),
                      icon: const Icon(CupertinoIcons.xmark, size: 18),
                      label: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          context.push('/success/conditions-met'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                      ),
                      icon: const Icon(Iconsax.tick_circle, size: 18),
                      label: const Text('Approve'),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _AssetCard extends StatelessWidget {
  final Map<String, dynamic> asset;

  const _AssetCard({required this.asset});

  @override
  Widget build(BuildContext context) {
    final name = asset['name'] as String;
    final type = asset['type'] as String;
    final status = asset['status'] as String;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          // File icon/preview
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: type == 'image'
                  ? AppColors.primarySurface
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              type == 'image'
                  ? Iconsax.gallery_copy
                  : Iconsax.document_copy,
              color: type == 'image'
                  ? AppColors.primary
                  : AppColors.textSecondary,
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Iconsax.cloud_add_copy,
              color: AppColors.textTertiary,
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
