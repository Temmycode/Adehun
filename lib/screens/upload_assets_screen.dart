import 'package:adehun_mvp/controllers/assets_controller.dart';
import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_card.dart';
import '../widgets/app_toast.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/info_banner.dart';
import '../widgets/section_header.dart';
import 'dispute_screen.dart' show FileRow;

class UploadAssetsScreen extends ConsumerStatefulWidget {
  final String conditionId;

  const UploadAssetsScreen({super.key, required this.conditionId});

  @override
  ConsumerState<UploadAssetsScreen> createState() => _UploadAssetsScreenState();
}

class _UploadAssetsScreenState extends ConsumerState<UploadAssetsScreen> {
  final List<FileResponse> _files = [];

  Future<void> _pickFiles() async {
    final result = await FilePicker.pickFiles(allowMultiple: true);
    if (result == null) return;
    setState(() => _files.addAll(result.files.map(FileResponse.fromFile)));
  }

  Future<void> _upload() async {
    final ok = await ref
        .read(assetsControllerProvider.notifier)
        .uploadConditionAssets(widget.conditionId, _files);
    if (!mounted) return;
    if (ok) {
      showAppToast(context, 'Proof submitted for review', kind: ToastKind.success);
      context.pop();
      return;
    }
    final error = ref.read(assetsControllerProvider).errorMessage;
    if (error != null) showAppToast(context, error, kind: ToastKind.error);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final assetState = ref.watch(assetsControllerProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AppTopBar(title: 'Upload proof'),
      bottomNavigationBar: BottomActionBar(
        primary: PrimaryButton(
          label: _files.isEmpty
              ? 'Submit proof'
              : 'Submit ${_files.length} file${_files.length == 1 ? '' : 's'}',
          loading: assetState.isAdding,
          onPressed: assetState.isAdding || _files.isEmpty ? null : _upload,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          AppSpacing.sm,
          AppSpacing.gutter,
          AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InfoBanner(
              tone: BannerTone.info,
              message:
                  'Show that this condition is done. The other party reviews what you upload and approves it to release the money.',
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppCard(
              onTap: _pickFiles,
              color: colors.primarySurface,
              bordered: false,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Icon(
                      Iconsax.cloud_add,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Tap to choose files',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Photos, PDFs, documents or ZIPs',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (_files.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(
                title: 'Selected (${_files.length})',
                padding: EdgeInsets.zero,
                actionLabel: 'Add more',
                onAction: _pickFiles,
              ),
              const SizedBox(height: AppSpacing.sm),
              for (var i = 0; i < _files.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: FileRow(
                    file: _files[i],
                    onRemove: () => setState(() => _files.removeAt(i)),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
