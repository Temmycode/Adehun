import 'package:adehun_mvp/constants/asset_types.dart';
import 'package:adehun_mvp/constants/dispute_enums.dart';
import 'package:adehun_mvp/controllers/agreement_controller.dart';
import 'package:adehun_mvp/controllers/dispute_controller.dart';
import 'package:adehun_mvp/core/utils/format_file_size.dart';
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
import '../widgets/app_chip.dart';
import '../widgets/app_toast.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/info_banner.dart';
import '../widgets/labeled_field.dart';

/// The API rejects anything outside this range with a 422, so the form
/// enforces it rather than letting the user discover it the hard way.
const _minDescriptionLength = 20;
const _maxDescriptionLength = 2000;

class DisputeScreen extends ConsumerStatefulWidget {
  final String agreementId;

  const DisputeScreen({super.key, required this.agreementId});

  @override
  ConsumerState<DisputeScreen> createState() => _DisputeScreenState();
}

class _DisputeScreenState extends ConsumerState<DisputeScreen> {
  final _descriptionController = TextEditingController();
  DisputeCategory _category = DisputeCategory.qualityIssues;
  final List<FileResponse> _files = [];
  bool _submitAttempted = false;

  int get _length => _descriptionController.text.trim().length;

  bool get _isValid =>
      _length >= _minDescriptionLength && _length <= _maxDescriptionLength;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.pickFiles(allowMultiple: true);
    if (result == null) return;
    setState(() => _files.addAll(result.files.map(FileResponse.fromFile)));
  }

  Future<void> _submit() async {
    setState(() => _submitAttempted = true);
    if (!_isValid) return;

    final raised = await ref.read(disputeControllerProvider.notifier).raiseDispute(
          agreementId: widget.agreementId,
          category: _category,
          description: _descriptionController.text.trim(),
          files: _files,
        );
    if (!mounted || !raised) return;

    // Raising a dispute freezes the agreement server-side, so pull the fresh
    // status before returning to the detail screen.
    await ref.read(agreementControllerProvider.notifier).refresh();
    if (!mounted) return;
    context.pop();
    showAppToast(
      context,
      'Dispute submitted. Our team will review it.',
      kind: ToastKind.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final disputeState = ref.watch(disputeControllerProvider);

    ref.listen(disputeControllerProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        showAppToast(context, next.errorMessage!, kind: ToastKind.error);
      }
    });

    final tooShort = _submitAttempted && !_isValid;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AppTopBar(title: 'Raise a dispute'),
      bottomNavigationBar: BottomActionBar(
        primary: PrimaryButton(
          label: 'Submit dispute',
          tone: ButtonTone.danger,
          loading: disputeState.isRaising,
          onPressed: disputeState.isRaising ? null : _submit,
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
              tone: BannerTone.warning,
              title: 'What happens when you raise a dispute',
              message:
                  'The agreement freezes and the money stays locked until our team reviews it and decides. Try to sort it out with the other party first if you can.',
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              "What's the problem?",
              style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final category in DisputeCategory.selectable)
                  AppChip(
                    label: category.label,
                    selected: _category == category,
                    onTap: () => setState(() => _category = category),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            LabeledField(
              label: 'Tell us what happened',
              hint: 'What went wrong, and what you expected instead',
              helper: tooShort
                  ? null
                  : '$_length / $_maxDescriptionLength · at least $_minDescriptionLength characters',
              controller: _descriptionController,
              maxLines: 6,
              maxLength: _maxDescriptionLength,
              textCapitalization: TextCapitalization.sentences,
              autovalidateMode: AutovalidateMode.always,
              validator: (_) => tooShort
                  ? 'Please describe the issue in at least $_minDescriptionLength characters'
                  : null,
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Evidence (optional)',
              style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              onTap: _pickFiles,
              color: colors.surfaceVariant,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: Column(
                children: [
                  Icon(Iconsax.paperclip_copy, color: colors.textSecondary, size: 26),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _files.isEmpty ? 'Attach screenshots or files' : 'Attach more',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Chats, receipts, photos of what was delivered',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (_files.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
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

/// A picked file with its size and a remove control. Shared with upload.
class FileRow extends StatelessWidget {
  final FileResponse file;
  final VoidCallback? onRemove;

  const FileRow({super.key, required this.file, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isImage = file.type == AssetType.image;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      radius: AppRadius.md,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isImage ? colors.primarySurface : colors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.xs + 2),
            ),
            child: Icon(
              isImage ? Iconsax.gallery_copy : Iconsax.document_copy,
              color: isImage ? AppColors.primary : colors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  formatFileSize(file.size.toInt()),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onRemove != null)
            Semantics(
              button: true,
              label: 'Remove file',
              child: InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Icon(
                    Iconsax.close_circle_copy,
                    color: colors.textTertiary,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
