import 'package:adehun_mvp/controllers/agreement_controller.dart';
import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/controllers/condition_controller.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/domain/models/participant.dart';
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
import '../utils/agreement_status.dart';

class AgreementDetailScreen extends ConsumerStatefulWidget {
  final String agreementId;

  const AgreementDetailScreen({super.key, required this.agreementId});

  @override
  ConsumerState<AgreementDetailScreen> createState() =>
      _AgreementDetailScreenState();
}

class _AgreementDetailScreenState extends ConsumerState<AgreementDetailScreen> {
  // Local mutable copy of conditions so we can add new ones in pre-active states

  AgreementResponse? get _agreement {
    return ref
        .watch(agreementControllerProvider)
        .maybeWhen(
          data: (state) => state.agreements.firstWhere(
            (agreement) => agreement.id == widget.agreementId,
            orElse: () => AgreementResponse(),
          ),
          orElse: () => null,
        );
  }

  bool get _canAddConditions {
    return AgreementStatusHelper.canAddConditions(_agreement?.status);
  }

  Future<void> getAgreementConditions() async {
    final agreementId = widget.agreementId;
    await ref
        .read(conditionControllerProvider.notifier)
        .getAgreementConditions(agreementId);
  }

  Future<void> getAgreementInvitation() async {
    final agreementId = widget.agreementId;
    final agreementState = ref.read(agreementControllerProvider);
    final invitation = agreementState.maybeWhen(
      data: (state) => state.invitations[agreementId],
      orElse: () => null,
    );

    if (invitation == null) {
      await ref
          .read(agreementControllerProvider.notifier)
          .getAgreementInvitation(agreementId);
    }
  }

  void loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.wait([getAgreementConditions(), getAgreementInvitation()]);
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> _refreshAgreementDetails() async {
    await Future.wait([
      ref.read(agreementControllerProvider.notifier).refresh(),
      ref
          .read(conditionControllerProvider.notifier)
          .refresh(widget.agreementId),
    ]);
  }

  void _acceptAgreement(BuildContext dialogContext) async {
    Navigator.pop(dialogContext);

    await ref
        .read(agreementControllerProvider.notifier)
        .acceptAgreement(widget.agreementId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Agreement activated successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final agreement = _agreement;
    final currentUser = ref.watch(authControllerProvider).userData;
    final status = AgreementStatusHelper.normalize(agreement?.status);
    final amount = double.parse(agreement?.amount ?? "0");
    final depositor = agreement?.depositor;
    final beneficiary = agreement?.beneficiary;

    if (currentUser == null) {
      return SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text(
          'Agreement Details',
          style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
        ),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (AgreementStatusHelper.isActiveLike(status))
            IconButton(
              icon: const Icon(Iconsax.more_copy),
              onPressed: () => _showOptionsSheet(context, status),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAgreementDetails,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Status & Title
              StatusBadge(status: status),
              const SizedBox(height: 12),
              Text(
                agreement?.title ?? "No title",
                style: AppTextStyles.h1.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                agreement?.description ?? "No description",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),

              const SizedBox(height: 24),
              // Amount card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.walletGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Escrow Amount',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\u20A6${_formatAmount(amount)}',
                      style: AppTextStyles.amountLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Parties
              Text(
                'Parties',
                style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.cardBorder),
                ),
                child: Column(
                  children: [
                    Consumer(
                      builder: (context, ref, _) {
                        final agreementState = ref.watch(
                          agreementControllerProvider,
                        );

                        return agreementState.when(
                          data: (state) {
                            final invitation =
                                state.invitations[widget.agreementId];
                            if (state.invitationLoading) {
                              return const PartyRowSkeleton();
                            }

                            return _PartyRow(
                              label: 'Depositor',
                              name:
                                  depositor?.name ??
                                  invitation?.email ??
                                  "No depositor",
                              initials: getInitials(
                                depositor?.name ?? invitation?.email ?? "",
                              ),
                              isYou: depositor?.email == currentUser.email!,
                            );
                          },
                          error: (err, stk) => Icon(Icons.error),
                          loading: () => const PartyRowSkeleton(),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(child: Divider(color: colors.cardBorder)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(
                              Iconsax.arrow_swap_copy,
                              color: colors.textTertiary,
                              size: 20,
                            ),
                          ),
                          Expanded(child: Divider(color: colors.cardBorder)),
                        ],
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, _) {
                        final agreementState = ref.watch(
                          agreementControllerProvider,
                        );

                        return agreementState.when(
                          data: (state) {
                            final invitation =
                                state.invitations[widget.agreementId];
                            if (state.invitationLoading) {
                              return const PartyRowSkeleton();
                            }
                            return _PartyRow(
                              label: 'Beneficiary',
                              name:
                                  beneficiary?.name ??
                                  invitation?.email ??
                                  "No beneficiary",
                              initials: getInitials(
                                beneficiary?.name ?? invitation?.email ?? "",
                              ),
                              isYou: beneficiary?.email == currentUser.email,
                            );
                          },
                          error: (err, stk) => Icon(Icons.error),
                          loading: () => const PartyRowSkeleton(),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Conditions
              const SizedBox(height: 24),
              Consumer(
                builder: (context, ref, _) {
                  final conditionState = ref.watch(conditionControllerProvider);
                  final conditions = conditionState.conditionsFor(
                    widget.agreementId,
                  );

                  // Only spin when there is nothing cached to show yet.
                  if (conditions.isEmpty && conditionState.isLoading) {
                    return const ConditionListSkeleton();
                  }

                  return Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Conditions',
                            style: AppTextStyles.h3.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          if (conditions.isNotEmpty)
                            Text(
                              '${conditions.where((c) => c.status == 'MET').length}/${conditions.length} met',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                        ],
                      ),

                      // Progress bar (only if conditions exist and agreement is past draft)
                      if (conditions.isNotEmpty &&
                          !AgreementStatusHelper.canAddConditions(status)) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: conditions.isEmpty
                                ? 0
                                : conditions
                                          .where((c) => c.status == 'met')
                                          .length /
                                      conditions.length,
                            minHeight: 6,
                            backgroundColor: colors.surfaceVariant,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.success,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Condition cards
                      if (conditions.isEmpty && !_canAddConditions)
                        _buildEmptyConditions()
                      else ...[
                        ...conditions.map((condition) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _ConditionCard(
                              condition: condition,
                              onTap: () {
                                context.push(
                                  '/condition/${condition.id}?agreementId=${widget.agreementId}',
                                );
                              },
                            ),
                          );
                        }),
                      ],

                      // Add condition button for pre-active agreements
                      if (_canAddConditions) ...[
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            _showAddConditionSheet(ref, depositor, beneficiary);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primary,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Iconsax.add,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Add Condition',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),

              // Action buttons based on status
              const SizedBox(height: 24),
              _buildActionButtons(context, ref, status),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyConditions() {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Iconsax.task_square_copy,
              color: colors.textTertiary,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No conditions defined',
            style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            'Conditions will appear here once added',
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddConditionSheet(
    WidgetRef ref,
    Participant? depositor,
    Participant? beneficiary,
  ) {
    final currentUser = ref.read(authControllerProvider).userData!;
    final colors = context.colors;
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String? selectedParticipantId;

    final participants = [depositor, beneficiary];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (builderContext, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(builderContext).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colors.cardBorder,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        'Add Condition',
                        style: AppTextStyles.h2.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Define what needs to be done and who is responsible',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        'Title',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: titleCtrl,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'e.g., Deliver homepage mockup',
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Description
                      Text(
                        'Description',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: descCtrl,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Describe what this condition entails...',
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Required from
                      Text(
                        'Required From',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Who must fulfill this condition?',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: participants.map((participant) {
                          final pId = participant?.id;
                          final isSelected = selectedParticipantId == pId;
                          final isFirst = participant == participants.first;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: isFirst ? 6 : 0,
                                left: isFirst ? 0 : 6,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setSheetState(() {
                                    selectedParticipantId = pId;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colors.primarySurface
                                        : colors.background,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : colors.cardBorder,
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: isSelected
                                            ? AppColors.primary
                                            : colors.surfaceVariant,
                                        child: Text(
                                          getInitials(participant?.name ?? ""),
                                          style: AppTextStyles.labelMedium
                                              .copyWith(
                                                color: isSelected
                                                    ? Colors.white
                                                    : colors.textSecondary,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        participant?.email == currentUser.email
                                            ? 'You'
                                            : _truncateName(
                                                participant?.name ?? "",
                                              ),
                                        style: AppTextStyles.labelMedium
                                            .copyWith(
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : colors.textPrimary,
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w600,
                                            ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primary.withValues(
                                                  alpha: 0.1,
                                                )
                                              : colors.surfaceVariant,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          _capitalize(
                                            participant?.role ?? "No role",
                                          ),
                                          style: AppTextStyles.labelSmall
                                              .copyWith(
                                                color: isSelected
                                                    ? AppColors.primary
                                                    : colors.textTertiary,
                                                fontSize: 9,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (titleCtrl.text.trim().isEmpty) return;
                            if (selectedParticipantId == null) return;

                            // final selectedParticipant = participants.firstWhere(
                            //   (p) => p?.id == selectedParticipantId,
                            // );

                            // setState(() {
                            //   _localConditions.add({
                            //     'id': 'c_new_${_localConditions.length + 1}',
                            //     'title': titleCtrl.text.trim(),
                            //     'description': descCtrl.text.trim(),
                            //     'status': 'PENDING',
                            //     'requiredFrom': selectedParticipant,
                            //     'addedBy': {
                            //       'id': 'me',
                            //       'name': MockData.userName,
                            //       'initials': MockData.userInitials,
                            //     },
                            //     'assets': <Map<String, dynamic>>[],
                            //   });
                            // });

                            Navigator.pop(builderContext);
                          },
                          child: const Text('Add Condition'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    String status,
  ) {
    final colors = context.colors;
    switch (AgreementStatusHelper.normalize(status)) {
      case AgreementStatusHelper.draft:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Send Invitation'),
          ),
        );
      case AgreementStatusHelper.pending:
        return Column(
          children: [
            // Agree & Activate button — shown when conditions exist
            Consumer(
              builder: (context, ref, _) {
                final conditions = ref
                    .watch(conditionControllerProvider)
                    .conditionsFor(widget.agreementId);

                if (conditions.isNotEmpty &&
                    _agreement?.currentUserAccepted != true) {
                  return Column(
                    crossAxisAlignment: .start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.infoLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Iconsax.people_copy,
                              color: AppColors.info,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Once both parties are satisfied with the conditions, agree to activate the escrow.',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.info,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Mock: just show a confirmation dialog
                            _showAgreeConfirmation(context);
                          },
                          icon: const Icon(Iconsax.tick_circle, size: 20),
                          label: const Text('Agree & Activate'),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.warningLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.timer_1_copy, color: AppColors.accent, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Waiting for the other party to accept this agreement',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.accentDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                child: const Text('Cancel Agreement'),
              ),
            ),
          ],
        );
      case AgreementStatusHelper.active:
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Iconsax.document_upload_copy, size: 20),
                label: const Text('Upload Asset'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.push('/dispute/${widget.agreementId}'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                child: const Text('Raise Dispute'),
              ),
            ),
          ],
        );
      case AgreementStatusHelper.completed:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.successLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.tick_circle, color: AppColors.success, size: 22),
              const SizedBox(width: 10),
              Text(
                'Agreement Completed Successfully',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        );
      case AgreementStatusHelper.disputed:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.errorLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Iconsax.warning_2_copy, color: AppColors.error, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'This agreement is currently under dispute. Our team is reviewing.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        );
      case AgreementStatusHelper.cancelled:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.close_circle, color: colors.textTertiary, size: 22),
              const SizedBox(width: 10),
              Text(
                'This agreement has been cancelled',
                style: AppTextStyles.labelLarge.copyWith(
                  color: colors.textTertiary,
                ),
              ),
            ],
          ),
        );
      case AgreementStatusHelper.refunded:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.statusRefundedBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.refresh_copy,
                color: AppColors.statusRefunded,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Funds have been refunded',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.statusRefunded,
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _showAgreeConfirmation(BuildContext context) {
    final colors = context.colors;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Iconsax.people, color: AppColors.primary, size: 24),
            const SizedBox(width: 10),
            Text('Confirm Agreement', style: AppTextStyles.h3),
          ],
        ),
        content: Text(
          'By agreeing, both parties confirm that all conditions are set and the escrow will become active. Funds will need to be deposited to proceed.',
          style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelLarge.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _acceptAgreement(dialogContext),
            child: const Text(
              'Agree',
            ), // TODO: Create a loading overlay when this is clicked with the agreementState.isAccepting
          ),
        ],
      ),
    );
  }

  void _showOptionsSheet(BuildContext context, String status) {
    final colors = context.colors;
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            _OptionTile(
              icon: Iconsax.document_upload_copy,
              title: 'Upload Asset',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _OptionTile(
              icon: Iconsax.warning_2_copy,
              title: 'Raise Dispute',
              color: AppColors.error,
              onTap: () {
                Navigator.pop(context);
                context.push('/dispute/${widget.agreementId}');
              },
            ),
            _OptionTile(
              icon: Iconsax.close_circle_copy,
              title: 'Cancel Agreement',
              color: AppColors.error,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final whole = parts[0];
    final decimal = parts[1];
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(whole[i]);
    }
    return '${buffer.toString()}.$decimal';
  }

  String _truncateName(String name) {
    if (name.length <= 14) return name;
    return '${name.substring(0, 12)}...';
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

class _PartyRow extends StatelessWidget {
  final String label;
  final String name;
  final String initials;
  final bool isYou;

  const _PartyRow({
    required this.label,
    required this.name,
    required this.initials,
    required this.isYou,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: colors.primarySurface,
          child: Text(
            initials,
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
              Text(label, style: AppTextStyles.bodySmall),
              Row(
                children: [
                  Text(name, style: AppTextStyles.labelLarge),
                  if (isYou) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primarySurface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'You',
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
    );
  }
}

class _ConditionCard extends ConsumerWidget {
  final ConditionResponse condition;
  final VoidCallback? onTap;

  const _ConditionCard({required this.condition, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final status = condition.status ?? "No status";
    // final assets = condition['assets'] as List? ?? [];
    final requiredFrom = condition.requiredFromParticipant;
    final currentUser = ref.watch(authControllerProvider).userData;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getStatusIcon(status),
                    color: _getStatusColor(status),
                    size: 18,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        condition.title ?? "No title",
                        style: AppTextStyles.labelLarge,
                      ),
                      const SizedBox(height: 2),
                      // Text(
                      //   '${assets.length} asset${assets.length != 1 ? 's' : ''}',
                      //   style: AppTextStyles.bodySmall,
                      // ),
                    ],
                  ),
                ),
                StatusBadge(status: status, compact: true),
                const SizedBox(width: 4),
                Icon(
                  CupertinoIcons.chevron_forward,
                  size: 14,
                  color: colors.textTertiary,
                ),
              ],
            ),
            // Required from row
            if (requiredFrom != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: colors.primarySurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 9,
                      backgroundColor: AppColors.primary.withValues(
                        alpha: 0.15,
                      ),
                      child: Text(
                        requiredFrom.user?.name ?? "No initials",
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Required from ${requiredFrom.user?.email == currentUser?.email ? 'You' : requiredFrom.user?.name ?? "No name"}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colors.textSecondary,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'met':
        return AppColors.statusCompleted;
      case 'in_progress':
        return AppColors.statusInProgress;
      case 'pending':
        return AppColors.statusPending;
      default:
        return AppColors.statusDraft;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'met':
        return Iconsax.tick_circle;
      case 'in_progress':
        return Iconsax.clock_copy;
      case 'PENDING':
        return Iconsax.timer_1_copy;
      default:
        return Iconsax.record_circle_copy;
    }
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListTile(
      leading: Icon(icon, color: color ?? colors.textPrimary),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          color: color ?? colors.textPrimary,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
