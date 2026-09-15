import 'package:adehun_mvp/constants/asset_types.dart';
import 'package:adehun_mvp/constants/dispute_enums.dart';
import 'package:adehun_mvp/controllers/agreement_controller.dart';
import 'package:adehun_mvp/controllers/dispute_controller.dart';
import 'package:adehun_mvp/core/utils/format_file_size.dart';
import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';

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
  DisputeCategory _selectedCategory = DisputeCategory.qualityIssues;
  final List<FileResponse> _selectedFiles = [];

  /// Errors stay hidden until the first submit attempt, so the field doesn't
  /// scold the user before they have typed anything.
  bool _submitAttempted = false;

  int get _descriptionLength => _descriptionController.text.trim().length;

  bool get _isDescriptionValid =>
      _descriptionLength >= _minDescriptionLength &&
      _descriptionLength <= _maxDescriptionLength;

  @override
  void initState() {
    super.initState();
    // Keeps the counter and the submit button's enabled state in step with
    // what's typed.
    _descriptionController.addListener(_onDescriptionChanged);
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_onDescriptionChanged);
    _descriptionController.dispose();
    super.dispose();
  }

  void _onDescriptionChanged() => setState(() {});

  Future<void> _pickFiles() async {
    final result = await FilePicker.pickFiles(allowMultiple: true);
    if (result == null) return;

    setState(() {
      _selectedFiles.addAll(result.files.map(FileResponse.fromFile));
    });
  }

  Future<void> _submit() async {
    setState(() => _submitAttempted = true);
    if (!_isDescriptionValid) return;

    final raised = await ref
        .read(disputeControllerProvider.notifier)
        .raiseDispute(
          agreementId: widget.agreementId,
          category: _selectedCategory,
          description: _descriptionController.text.trim(),
          files: _selectedFiles,
        );

    if (!mounted) return;
    // On failure we stay put so the user can retry; the error snackbar is wired
    // up in build() via ref.listen.
    if (!raised) return;

    // Raising a dispute freezes the agreement server-side, so pull the fresh
    // status before returning to the detail screen.
    await ref.read(agreementControllerProvider.notifier).refresh();

    if (!mounted) return;
    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dispute submitted. Our team will review it.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final disputeState = ref.watch(disputeControllerProvider);

    // Surface errors as a snackbar exactly once per new error value.
    ref.listen(disputeControllerProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Raise Dispute', style: AppTextStyles.h3),
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
            // Warning banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.warningLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Iconsax.info_circle_copy,
                    color: AppColors.accent,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Disputes should be a last resort. Please try to resolve issues directly with the other party first.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.accentDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text('Dispute Category', style: AppTextStyles.labelLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DisputeCategory.selectable.map((category) {
                return _CategoryChip(
                  category: category,
                  selected: _selectedCategory,
                  onTap: () => setState(() => _selectedCategory = category),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),
            Text('Describe the Issue', style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              // Gives a hard cap plus the built-in "n/2000" counter.
              maxLength: _maxDescriptionLength,
              decoration: InputDecoration(
                hintText: 'Explain what went wrong and what you expected...',
                helperText: 'At least $_minDescriptionLength characters',
                errorText: _submitAttempted && !_isDescriptionValid
                    ? 'Please describe the issue in at least $_minDescriptionLength characters'
                    : null,
              ),
            ),

            const SizedBox(height: 24),
            Text('Supporting Evidence', style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickFiles,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.cardBorder),
                ),
                child: Column(
                  children: [
                    Icon(
                      Iconsax.paperclip_copy,
                      color: colors.textTertiary,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to attach files',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Attached files
            if (_selectedFiles.isNotEmpty) ...[
              const SizedBox(height: 12),
              ..._selectedFiles.asMap().entries.map((entry) {
                final index = entry.key;
                final file = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          file.type == AssetType.image
                              ? Iconsax.gallery_copy
                              : Iconsax.document_copy,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(file.name, style: AppTextStyles.labelMedium),
                              Text(
                                formatFileSize(file.size.toInt()),
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFiles.removeAt(index);
                            });
                          },
                          child: Icon(
                            CupertinoIcons.xmark,
                            color: colors.textTertiary,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: disputeState.isRaising || !_isDescriptionValid
                    ? null
                    : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: disputeState.isRaising
                    ? const CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )
                    : const Text('Submit Dispute'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final DisputeCategory category;
  final DisputeCategory selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSelected = category == selected;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : colors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : colors.cardBorder,
          ),
        ),
        child: Text(
          category.label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? Colors.white : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
