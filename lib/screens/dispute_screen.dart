import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class DisputeScreen extends StatefulWidget {
  final String agreementId;

  const DisputeScreen({super.key, required this.agreementId});

  @override
  State<DisputeScreen> createState() => _DisputeScreenState();
}

class _DisputeScreenState extends State<DisputeScreen> {
  final _reasonController = TextEditingController();
  String _selectedCategory = 'quality';
  final List<String> _mockFiles = [];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
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
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Iconsax.info_circle_copy,
                      color: AppColors.accent, size: 22),
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
              children: [
                _CategoryChip(
                  label: 'Quality Issues',
                  value: 'quality',
                  selected: _selectedCategory,
                  onTap: () =>
                      setState(() => _selectedCategory = 'quality'),
                ),
                _CategoryChip(
                  label: 'Missed Deadline',
                  value: 'deadline',
                  selected: _selectedCategory,
                  onTap: () =>
                      setState(() => _selectedCategory = 'deadline'),
                ),
                _CategoryChip(
                  label: 'Incomplete Work',
                  value: 'incomplete',
                  selected: _selectedCategory,
                  onTap: () =>
                      setState(() => _selectedCategory = 'incomplete'),
                ),
                _CategoryChip(
                  label: 'Non-responsive',
                  value: 'unresponsive',
                  selected: _selectedCategory,
                  onTap: () =>
                      setState(() => _selectedCategory = 'unresponsive'),
                ),
                _CategoryChip(
                  label: 'Other',
                  value: 'other',
                  selected: _selectedCategory,
                  onTap: () =>
                      setState(() => _selectedCategory = 'other'),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Text('Describe the Issue', style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText:
                    'Explain what went wrong and what you expected...',
              ),
            ),

            const SizedBox(height: 24),
            Text('Supporting Evidence', style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _mockFiles.add('evidence_${_mockFiles.length + 1}.png');
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.cardBorder,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Iconsax.paperclip_copy,
                      color: AppColors.textTertiary,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to attach files',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Attached files
            if (_mockFiles.isNotEmpty) ...[
              const SizedBox(height: 12),
              ..._mockFiles.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Iconsax.gallery_copy,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: AppTextStyles.labelMedium,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _mockFiles.removeAt(entry.key);
                            });
                          },
                          child: const Icon(
                            CupertinoIcons.xmark,
                            color: AppColors.textTertiary,
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
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text('Submit Dispute'),
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
  final String label;
  final String value;
  final String selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
