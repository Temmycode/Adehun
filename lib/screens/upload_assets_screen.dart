import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';

class UploadAssetsScreen extends StatefulWidget {
  final String conditionId;

  const UploadAssetsScreen({super.key, required this.conditionId});

  @override
  State<UploadAssetsScreen> createState() => _UploadAssetsScreenState();
}

class _UploadAssetsScreenState extends State<UploadAssetsScreen> {
  final List<_MockFile> _selectedFiles = [];

  void _pickFiles() {
    // Mock file selection
    setState(() {
      _selectedFiles.addAll([
        _MockFile(
          name: 'deliverable_v2.pdf',
          size: '2.4 MB',
          type: 'pdf',
        ),
        _MockFile(
          name: 'screenshot_proof.png',
          size: '1.1 MB',
          type: 'image',
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Upload Assets', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Upload proof of work for this condition. You can upload images, documents, or any relevant files.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Upload area
            GestureDetector(
              onTap: _selectedFiles.isEmpty ? _pickFiles : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: colors.primarySurface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                    // Dashed border effect via decoration
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Iconsax.cloud_add_copy,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Tap to select files',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PNG, JPG, PDF, ZIP up to 10MB',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            // Selected files
            if (_selectedFiles.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected Files (${_selectedFiles.length})',
                    style: AppTextStyles.h3,
                  ),
                  GestureDetector(
                    onTap: _pickFiles,
                    child: Text(
                      'Add more',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._selectedFiles.asMap().entries.map((entry) {
                final index = entry.key;
                final file = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: file.type == 'image'
                                ? colors.primarySurface
                                : colors.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            file.type == 'image'
                                ? Iconsax.gallery_copy
                                : Iconsax.document_copy,
                            color: file.type == 'image'
                                ? AppColors.primary
                                : colors.textSecondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(file.name,
                                  style: AppTextStyles.labelLarge),
                              Text(file.size,
                                  style: AppTextStyles.bodySmall),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            CupertinoIcons.xmark,
                            color: colors.textTertiary,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedFiles.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],

            const Spacer(),
            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedFiles.isNotEmpty
                    ? () => context.pop()
                    : null,
                child: const Text('Submit Assets'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _MockFile {
  final String name;
  final String size;
  final String type;

  _MockFile({required this.name, required this.size, required this.type});
}
