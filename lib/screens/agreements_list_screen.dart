import 'package:adehun_mvp/controllers/agreement_controller.dart';
import 'package:adehun_mvp/controllers/condition_controller.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_color_scheme.dart';
import '../widgets/agreement_card.dart';
import '../widgets/skeletons.dart';

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
    'Refunded',
  ];

  List<AgreementResponse> _filteredAgreements(
    List<AgreementResponse> agreements,
  ) {
    if (_selectedFilter == 'All') return agreements;
    return agreements.where((a) {
      final status = a.status;
      switch (_selectedFilter) {
        case 'Active':
          return status == 'active' || status == 'CONDITIONS_IN_PROGRESS';
        case 'Pending':
          return status == 'pending' || status == 'DRAFT';
        case 'Completed':
          return status == 'completed' || status == 'CONDITIONS_MET';
        case 'Disputed':
          return status == 'disputed';
        case 'Refunded':
          return status == 'refunded';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
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
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: SizedBox(
                  height: 38,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = filter == _selectedFilter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedFilter = filter),
                          child: Container(
                            alignment: .center,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : colors.cardBorder,
                              ),
                            ),
                            child: Text(
                              filter,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: colors.textSecondary,
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

            Consumer(
              builder: (context, ref, _) {
                final agreementState = ref.watch(agreementControllerProvider);
                final conditionController = ref.read(
                  conditionControllerProvider.notifier,
                );

                return agreementState.when(
                  data: (stateData) {
                    final agreements = _filteredAgreements(
                      stateData.agreements,
                    );
                    if (agreements.isEmpty) {
                      return SliverFillRemaining(child: _EmptyState());
                    } else {
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final agreement = agreements[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AgreementCard(
                                agreement: agreement,
                                conditions: conditionController
                                    .getAgreementConditions(agreement.id!),
                                onTap: () {
                                  context.push('/agreement/${agreement.id}');
                                },
                              ),
                            );
                          }, childCount: agreements.length),
                        ),
                      );
                    }
                  },
                  loading: () => const SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverToBoxAdapter(
                      child: AgreementListSkeleton(),
                    ),
                  ),
                  error: (err, stk) => SliverToBoxAdapter(
                    child: Text(
                      'An error occurred $err',
                      style: TextTheme.of(
                        context,
                      ).bodyMedium?.copyWith(color: Colors.red),
                    ),
                  ),
                );
              },
            ),

            // Agreements list
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
    final colors = context.colors;
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
                color: colors.primarySurface,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Iconsax.document_text_copy,
                color: AppColors.primary,
                size: 44,
              ),
            ),
            const SizedBox(height: 24),
            Text('No Agreements Yet', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'Create your first escrow agreement\nto get started',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
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
