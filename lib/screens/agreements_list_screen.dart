import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/mock_data.dart';
import '../widgets/agreement_card.dart';

class AgreementsListScreen extends StatefulWidget {
  const AgreementsListScreen({super.key});

  @override
  State<AgreementsListScreen> createState() => _AgreementsListScreenState();
}

class _AgreementsListScreenState extends State<AgreementsListScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Active',
    'Pending',
    'Completed',
    'Disputed',
  ];

  List<Map<String, dynamic>> get _filteredAgreements {
    if (_selectedFilter == 'All') return MockData.agreements;
    return MockData.agreements.where((a) {
      final status = a['status'] as String;
      switch (_selectedFilter) {
        case 'Active':
          return status == 'ACTIVE' || status == 'CONDITIONS_IN_PROGRESS';
        case 'Pending':
          return status == 'PENDING_ACCEPTANCE' || status == 'DRAFT';
        case 'Completed':
          return status == 'COMPLETED' || status == 'CONDITIONS_MET';
        case 'Disputed':
          return status == 'DISPUTED';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final agreements = _filteredAgreements;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Agreements', style: AppTextStyles.h1),
                    GestureDetector(
                      onTap: () => context.push('/create-agreement'),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Iconsax.add,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Filter chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 0, 8),
                child: SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = filter == _selectedFilter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedFilter = filter),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.cardBorder,
                              ),
                            ),
                            child: Text(
                              filter,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Agreements list
            if (agreements.isEmpty)
              SliverFillRemaining(
                child: _EmptyState(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final agreement = agreements[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AgreementCard(
                          agreement: agreement,
                          onTap: () => context
                              .push('/agreement/${agreement['id']}'),
                        ),
                      );
                    },
                    childCount: agreements.length,
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Iconsax.document_text_copy,
                color: AppColors.primary,
                size: 44,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Agreements Yet',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first escrow agreement\nto get started',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/create-agreement'),
              icon: const Icon(Iconsax.add, size: 20),
              label: const Text('Create Agreement'),
            ),
          ],
        ),
      ),
    );
  }
}
