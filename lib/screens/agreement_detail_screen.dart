import 'package:adehun_mvp/controllers/agreement_controller.dart';
import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/controllers/condition_controller.dart';
import 'package:adehun_mvp/controllers/dispute_controller.dart';
import 'package:adehun_mvp/core/utils/relative_time.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/domain/models/dispute_response.dart';
import 'package:adehun_mvp/domain/models/participant.dart';
import 'package:adehun_mvp/domain/states/agreement_state.dart';
import 'package:adehun_mvp/usecases/params/add_condition_params.dart';
import 'package:adehun_mvp/utils/random_functions.dart';
import 'package:adehun_mvp/widgets/dispute_status_pill.dart';
import 'package:adehun_mvp/widgets/profile_image.dart';
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

  Future<void> getAgreementDisputes() async {
    final agreementId = widget.agreementId;
    await ref
        .read(disputeControllerProvider.notifier)
        .getAgreementDisputes(agreementId);
  }

  void loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.wait([
        getAgreementConditions(),
        getAgreementInvitation(),
        // Unconditional rather than gated on a DISPUTED status: the agreement
        // may still be loading here, and resolved disputes are worth showing
        // on an active agreement too. The controller reads cache first.
        getAgreementDisputes(),
      ]);
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
      ref.read(disputeControllerProvider.notifier).refresh(widget.agreementId),
    ]);
  }

  /// Whether the signed-in user is the one who pays into escrow.
  bool get _isDepositor {
    final email = ref.read(authControllerProvider).userData?.email;
    return email != null && _agreement?.depositor?.email == email;
  }

  void _showSnack(String message, {bool success = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? AppColors.success : AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  }

  /// Accepts, then — for the depositor only — moves the money into escrow.
  ///
  /// Funding can fail after a successful accept, leaving an active but unfunded
  /// agreement. That's what the Fund Escrow button in [_buildActionButtons] is
  /// for, so we only report the failure here.
  void _acceptAgreement(BuildContext dialogContext) async {
    Navigator.pop(dialogContext);

    final isDepositor = _isDepositor;

    final accepted = await ref
        .read(agreementControllerProvider.notifier)
        .acceptAgreement(widget.agreementId);

    if (!mounted) return;

    if (!accepted) {
      _showSnack("Couldn't activate the agreement. Please try again.");
      return;
    }

    if (!isDepositor) {
      _showSnack('Agreement activated successfully!', success: true);
      return;
    }

    await _fundEscrow(alreadyActivated: true);
  }

  Future<void> _fundEscrow({bool alreadyActivated = false}) async {
    final funded = await ref
        .read(agreementControllerProvider.notifier)
        .fundAgreement(widget.agreementId);

    if (!mounted) return;

    if (funded) {
      _showSnack(
        alreadyActivated
            ? 'Agreement activated and funds moved into escrow.'
            : 'Funds moved into escrow.',
        success: true,
      );
      return;
    }

    // No fundError means funding didn't apply to this user (they aren't the
    // depositor) rather than that it failed. Nothing to report.
    final error = ref.read(agreementControllerProvider).value?.fundError;
    if (error == null) return;

    _showSnack(error);
    ref.read(agreementControllerProvider.notifier).clearFundError();
  }

  void _confirmCancel(BuildContext context) {
    final colors = context.colors;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(
              Iconsax.close_circle_copy,
              color: AppColors.error,
              size: 24,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text('Cancel Agreement', style: AppTextStyles.h3)),
          ],
        ),
        content: Text(
          'This ends the agreement for both parties and cannot be undone.',
          style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Keep it',
              style: AppTextStyles.labelLarge.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _cancelAgreement();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Cancel Agreement'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelAgreement() async {
    final cancelled = await ref
        .read(agreementControllerProvider.notifier)
        .cancelAgreement(widget.agreementId);

    if (!mounted) return;

    if (cancelled) {
      _showSnack('Agreement cancelled.', success: true);
      return;
    }

    // The server explains a refused cancel — most often "the escrow is already
    // funded, raise a dispute instead" — so prefer its wording.
    final error = ref.read(agreementControllerProvider).value?.fundError;
    if (error == null) return;

    _showSnack(error);
    ref.read(agreementControllerProvider.notifier).clearFundError();
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
      body: Stack(
        children: [
          RefreshIndicator(
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
                                  depositor?.profilePictureUrl,
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
                              Expanded(
                                child: Divider(color: colors.cardBorder),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Icon(
                                  Iconsax.arrow_swap_copy,
                                  color: colors.textTertiary,
                                  size: 20,
                                ),
                              ),
                              Expanded(
                                child: Divider(color: colors.cardBorder),
                              ),
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
                                  beneficiary?.profilePictureUrl,
                                  label: 'Beneficiary',
                                  name:
                                      beneficiary?.name ??
                                      invitation?.email ??
                                      "No beneficiary",
                                  initials: getInitials(
                                    beneficiary?.name ??
                                        invitation?.email ??
                                        "",
                                  ),
                                  isYou:
                                      beneficiary?.email == currentUser.email,
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
                      final conditionState = ref.watch(
                        conditionControllerProvider,
                      );
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
                              !AgreementStatusHelper.canAddConditions(
                                status,
                              )) ...[
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
                                _showAddConditionSheet(
                                  ref,
                                  depositor,
                                  beneficiary,
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
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

                  _buildDisputesSection(currentUser.email),

                  // Action buttons based on status
                  const SizedBox(height: 24),
                  _buildActionButtons(context, ref, status),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildProgressOverlay(amount),
        ],
      ),
    );
  }

  /// Blocks the screen while accepting or funding is in flight.
  ///
  /// The barrier is the point: without it a user can tap Raise Dispute or
  /// navigate away while their money is moving.
  Widget _buildProgressOverlay(double amount) {
    final colors = context.colors;
    final isAccepting = ref.watch(
      agreementControllerProvider.select((s) => s.value?.isAccepting ?? false),
    );
    final stage = ref.watch(
      agreementControllerProvider.select(
        (s) => s.value?.fundingStage ?? EscrowFundingStage.idle,
      ),
    );

    if (!isAccepting && stage == EscrowFundingStage.idle) {
      return const SizedBox.shrink();
    }

    final (label, subline) = switch (stage) {
      EscrowFundingStage.toppingUp => ('Opening secure checkout…', null),
      EscrowFundingStage.awaitingSettlement => (
        'Confirming your payment…',
        'This can take up to 30 seconds.',
      ),
      EscrowFundingStage.movingToEscrow => (
        'Moving ₦${_formatAmount(amount)} into escrow…',
        null,
      ),
      EscrowFundingStage.idle => ('Activating agreement…', null),
    };

    return Positioned.fill(
      child: AbsorbPointer(
        child: ColoredBox(
          color: colors.background.withValues(alpha: 0.85),
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 48),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.cardBorder),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelLarge,
                  ),
                  if (subline != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subline,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Renders nothing until there is something to show — most agreements never
  /// have a dispute, and a skeleton would flash on every visit.
  Widget _buildDisputesSection(String? currentUserEmail) {
    return Consumer(
      builder: (context, ref, _) {
        final disputes = ref
            .watch(disputeControllerProvider)
            .disputesFor(widget.agreementId);

        if (disputes.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text('Disputes', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            ...disputes.map(
              (dispute) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _DisputeCard(
                  dispute: dispute,
                  currentUserEmail: currentUserEmail,
                ),
              ),
            ),
          ],
        );
      },
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
                          onPressed: () async {
                            final title = titleCtrl.text.trim();
                            final description = descCtrl.text.trim();
                            if (title.isEmpty || selectedParticipantId == null) {
                              return;
                            }
                            final selected = participants
                                .where((p) => p?.id == selectedParticipantId)
                                .firstOrNull;
                            final email = selected?.email;
                            if (email == null || email.isEmpty) {
                              _showSnack(
                                "Couldn't resolve who this condition is for.",
                              );
                              return;
                            }

                            Navigator.pop(builderContext);
                            final notifier = ref.read(
                              conditionControllerProvider.notifier,
                            );
                            await notifier.addConditionToAgreement(
                              widget.agreementId,
                              AddConditionParams(
                                agreementId: widget.agreementId,
                                title: title,
                                description: description.isEmpty
                                    ? title
                                    : description,
                                requiredFromEmail: email,
                              ),
                            );
                            if (!mounted) return;
                            final error = ref
                                .read(conditionControllerProvider)
                                .errorMessage;
                            if (error != null) {
                              _showSnack(error);
                              notifier.clearError();
                            } else {
                              _showSnack('Condition added', success: true);
                            }
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
    final isCancelling = ref.watch(
      agreementControllerProvider.select((s) => s.value?.isCancelling ?? false),
    );
    switch (AgreementStatusHelper.normalize(status)) {
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
                onPressed: isCancelling ? null : () => _confirmCancel(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                child: Text(isCancelling ? 'Cancelling…' : 'Cancel Agreement'),
              ),
            ),
          ],
        );
      case AgreementStatusHelper.active:
        // Raising a dispute flips the agreement to DISPUTED server-side, so
        // this case usually stops rendering anyway. The gate covers the gap
        // between a successful POST and the refresh landing, plus reopening
        // from a stale cache. The server 409s either way.
        final hasLiveDispute = ref
            .watch(disputeControllerProvider)
            .hasLiveDispute(widget.agreementId);

        // Recovery path: auto-funding on accept can fail halfway (dismissed
        // payment, settlement timeout), leaving the escrow empty.
        final needsFunding = _agreement?.isFunded == false && _isDepositor;
        final isFunding = ref.watch(
          agreementControllerProvider.select(
            (s) => s.value?.isFundingAgreement(widget.agreementId) ?? false,
          ),
        );

        return Column(
          children: [
            if (needsFunding) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.warningLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.timer_1_copy,
                      color: AppColors.accent,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "This escrow isn't funded yet. The other party can't be "
                        'paid until you move the funds in.',
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
                child: ElevatedButton.icon(
                  // Funding a disputed agreement is nonsense, and the server
                  // rejects it anyway.
                  onPressed: isFunding || hasLiveDispute
                      ? null
                      : () => _fundEscrow(),
                  icon: const Icon(Iconsax.wallet_add, size: 20),
                  label: Text(isFunding ? 'Funding…' : 'Fund Escrow'),
                ),
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: hasLiveDispute
                    ? null
                    : () => context.push('/dispute/${widget.agreementId}'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                child: Text(
                  hasLiveDispute ? 'Dispute in progress' : 'Raise Dispute',
                ),
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

    // Accepting now debits the depositor, so the two parties need to be told
    // very different things.
    final isDepositor = _isDepositor;
    final amount = double.tryParse(_agreement?.amount ?? '') ?? 0;
    // Nullable on a participant who hasn't registered yet.
    final otherParty = isDepositor
        ? _agreement?.beneficiary?.name ?? 'the beneficiary'
        : _agreement?.depositor?.name ?? 'the depositor';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              isDepositor ? Iconsax.wallet_check : Iconsax.people,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isDepositor ? 'Fund & Activate' : 'Confirm Agreement',
                style: AppTextStyles.h3,
              ),
            ),
          ],
        ),
        content: Text(
          isDepositor
              ? "You're about to move ₦${_formatAmount(amount)} from your wallet "
                    'into escrow. It stays there until every condition is '
                    "approved, then goes to $otherParty. If your wallet is "
                    "short, we'll top it up first."
              : 'By agreeing, both parties confirm that all conditions are '
                    'final and the escrow becomes active. $otherParty funds the '
                    "escrow — you won't be charged anything.",
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
            child: Text(isDepositor ? 'Agree & Fund' : 'Agree'),
          ),
        ],
      ),
    );
  }

  void _showOptionsSheet(BuildContext context, String status) {
    final colors = context.colors;
    final hasLiveDispute = ref
        .read(disputeControllerProvider)
        .hasLiveDispute(widget.agreementId);
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
            if (!hasLiveDispute)
              _OptionTile(
                icon: Iconsax.warning_2_copy,
                title: 'Raise Dispute',
                color: AppColors.error,
                onTap: () {
                  Navigator.pop(context);
                  context.push('/dispute/${widget.agreementId}');
                },
              ),
            // A funded escrow can't be cancelled unilaterally — that route is
            // Raise Dispute, which is already in this sheet.
            if (_agreement?.isFunded == false)
              _OptionTile(
                icon: Iconsax.close_circle_copy,
                title: 'Cancel Agreement',
                color: AppColors.error,
                onTap: () {
                  Navigator.pop(context);
                  _confirmCancel(context);
                },
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

class _DisputeCard extends StatelessWidget {
  final DisputeResponse dispute;
  final String? currentUserEmail;

  const _DisputeCard({required this.dispute, this.currentUserEmail});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final raisedBy = dispute.raisedBy;
    final isMine =
        currentUserEmail != null && raisedBy?.email == currentUserEmail;
    final evidenceCount = dispute.evidence?.length ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DisputeStatusPill(status: dispute.status, compact: true),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dispute.category?.label ?? '',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          if (dispute.description != null &&
              dispute.description!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              dispute.description!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Raised by ${isMine ? 'You' : raisedBy?.name ?? 'the other party'}'
                  '${dispute.createdAt != null ? ' · ${dispute.createdAt!.toRelativeTime()}' : ''}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ),
              if (evidenceCount > 0) ...[
                const SizedBox(width: 8),
                Icon(
                  Iconsax.paperclip_copy,
                  size: 14,
                  color: colors.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  '$evidenceCount file${evidenceCount != 1 ? 's' : ''}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
          // Only set once an admin has resolved the dispute.
          if (dispute.resolutionOutcome != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Outcome: ${dispute.resolutionOutcome!.label}',
                    style: AppTextStyles.labelMedium,
                  ),
                  if (dispute.resolutionNotes != null &&
                      dispute.resolutionNotes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      dispute.resolutionNotes!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PartyRow extends StatelessWidget {
  final String label;
  final String name;
  final String initials;
  final bool isYou;
  final String? profileImage;

  const _PartyRow(
    this.profileImage, {
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
          child: profileImage != null
              ? ProfileImage(image: profileImage)
              : Text(
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
