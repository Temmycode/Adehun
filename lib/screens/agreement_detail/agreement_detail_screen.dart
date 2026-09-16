import 'package:adehun_mvp/controllers/agreement_controller.dart';
import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/controllers/condition_controller.dart';
import 'package:adehun_mvp/controllers/dispute_controller.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/models/participant.dart';
import 'package:adehun_mvp/domain/states/agreement_state.dart';
import 'package:adehun_mvp/usecases/params/add_condition_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_color_scheme.dart';
import '../../theme/app_motion.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_tokens.dart';
import '../../utils/agreement_status.dart';
import '../../utils/condition_status.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_action_bar.dart';
import '../../widgets/condition_editor_sheet.dart';
import '../../widgets/list_state_placeholder.dart';
import 'agreement_actions.dart';
import 'agreement_summary_header.dart';
import 'conditions_timeline.dart';
import 'disputes_section.dart';
import 'funding_overlay.dart';
import 'next_step_banner.dart';
import 'parties_section.dart';
import 'sheets/agreement_sheets.dart';

class AgreementDetailScreen extends ConsumerStatefulWidget {
  final String agreementId;

  const AgreementDetailScreen({super.key, required this.agreementId});

  @override
  ConsumerState<AgreementDetailScreen> createState() =>
      _AgreementDetailScreenState();
}

class _AgreementDetailScreenState extends ConsumerState<AgreementDetailScreen> {
  /// Whether *this* screen kicked off the accept/fund that is in flight.
  ///
  /// `isAccepting` and `fundingStage` live on one shared, keep-alive state
  /// object, so reading them raw puts the blocking overlay over every
  /// agreement the user opens, not just the one being funded.
  bool _actingHere = false;

  String get _id => widget.agreementId;

  AgreementResponse? get _agreement {
    return ref
        .watch(agreementControllerProvider)
        .maybeWhen(
          data: (state) => state.agreements
              .where((agreement) => agreement.id == _id)
              .firstOrNull,
          orElse: () => null,
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.wait([
        ref
            .read(conditionControllerProvider.notifier)
            .getAgreementConditions(_id),
        _loadInvitation(),
        // Unconditional rather than gated on a DISPUTED status: the agreement
        // may still be loading here, and resolved disputes are worth showing
        // on an active agreement too. The controller reads cache first.
        ref.read(disputeControllerProvider.notifier).getAgreementDisputes(_id),
      ]);
    });
  }

  Future<void> _loadInvitation() async {
    final cached = ref
        .read(agreementControllerProvider)
        .maybeWhen(data: (state) => state.invitations[_id], orElse: () => null);
    if (cached == null) {
      await ref
          .read(agreementControllerProvider.notifier)
          .getAgreementInvitation(_id);
    }
  }

  Future<void> _refresh() async {
    await Future.wait([
      ref.read(agreementControllerProvider.notifier).refresh(),
      ref.read(conditionControllerProvider.notifier).refresh(_id),
      ref.read(disputeControllerProvider.notifier).refresh(_id),
    ]);
  }

  /// Whether the signed-in user is the one who pays into escrow.
  bool get _isDepositor {
    final email = ref.read(authControllerProvider).userData?.email;
    return email != null && _agreement?.depositor?.email == email;
  }

  void _toast(String message, {bool success = false}) {
    if (!mounted) return;
    showAppToast(
      context,
      message,
      kind: success ? ToastKind.success : ToastKind.error,
    );
  }

  // ── Actions ──────────────────────────────────────────────────────────────

  Future<void> _onAgree() async {
    final isDepositor = _isDepositor;
    final amount = double.tryParse(_agreement?.amount ?? '') ?? 0;
    final confirmed = await showAgreeConfirmationSheet(
      context,
      isDepositor: isDepositor,
      amount: amount,
      otherPartyName: _counterpartName(),
    );
    if (!confirmed || !mounted) return;

    setState(() => _actingHere = true);
    try {
      final accepted = await ref
          .read(agreementControllerProvider.notifier)
          .acceptAgreement(_id);
      if (!mounted) return;

      if (!accepted) {
        _toast("Couldn't activate the agreement. Please try again.");
        return;
      }
      if (!isDepositor) {
        _toast('Agreement activated.', success: true);
        return;
      }
      // Accepting debits the depositor; funding can still fail after a
      // successful accept, which the Fund escrow action then recovers from.
      await _fundEscrow(alreadyActivated: true, keepFlag: true);
    } finally {
      if (mounted) setState(() => _actingHere = false);
    }
  }

  Future<void> _fundEscrow({
    bool alreadyActivated = false,
    bool keepFlag = false,
  }) async {
    if (!keepFlag) {
      setState(() => _actingHere = true);
    }
    try {
      await _doFund(alreadyActivated);
    } finally {
      if (!keepFlag && mounted) setState(() => _actingHere = false);
    }
  }

  Future<void> _doFund(bool alreadyActivated) async {
    final funded = await ref
        .read(agreementControllerProvider.notifier)
        .fundAgreement(_id);
    if (!mounted) return;

    if (funded) {
      _toast(
        alreadyActivated
            ? 'Agreement activated and funds moved into escrow.'
            : 'Funds moved into escrow.',
        success: true,
      );
      return;
    }
    // No fundError means funding didn't apply to this user rather than that
    // it failed. Nothing to report.
    final error = ref.read(agreementControllerProvider).value?.fundError;
    if (error == null) return;
    _toast(error);
    ref.read(agreementControllerProvider.notifier).clearFundError();
  }

  Future<void> _onCancel() async {
    final confirmed = await showCancelConfirmationSheet(context);
    if (!confirmed || !mounted) return;

    final cancelled = await ref
        .read(agreementControllerProvider.notifier)
        .cancelAgreement(_id);
    if (!mounted) return;

    if (cancelled) {
      _toast('Agreement cancelled.', success: true);
      return;
    }
    // The server explains a refused cancel, most often "the escrow is already
    // funded, raise a dispute instead", so prefer its wording.
    final error = ref.read(agreementControllerProvider).value?.fundError;
    if (error == null) return;
    _toast(error);
    ref.read(agreementControllerProvider.notifier).clearFundError();
  }

  void _onRaiseDispute() => context.push('/dispute/$_id');

  Future<void> _perform(AgreementAction action) async {
    switch (action) {
      case AgreementAction.agree:
        await _onAgree();
      case AgreementAction.fund:
        await _fundEscrow();
      case AgreementAction.raiseDispute:
        _onRaiseDispute();
      case AgreementAction.cancel:
        await _onCancel();
    }
  }

  Future<void> _onAddCondition() async {
    final me = ref.read(authControllerProvider).userData;
    final agreement = _agreement;
    if (me == null || agreement == null) return;

    final parties = <ConditionParty>[
      for (final p in [agreement.depositor, agreement.beneficiary])
        if (p != null && p.id != null)
          ConditionParty(
            id: p.id!,
            name: p.name ?? p.email ?? 'Other party',
            role: p.role ?? '',
            isMe: p.email != null && p.email == me.email,
            imageUrl: p.profilePictureUrl,
          ),
    ];

    final draft = await showConditionEditorSheet(context, parties: parties);
    if (draft == null || !mounted) return;

    final selected = [
      agreement.depositor,
      agreement.beneficiary,
    ].where((p) => p?.id == draft.partyId).firstOrNull;
    final email = selected?.email;
    if (email == null || email.isEmpty) {
      _toast("Couldn't resolve who this condition is for.");
      return;
    }

    final notifier = ref.read(conditionControllerProvider.notifier);
    await notifier.addConditionToAgreement(
      _id,
      AddConditionParams(
        agreementId: _id,
        title: draft.title,
        description: draft.description.isEmpty
            ? draft.title
            : draft.description,
        requiredFromEmail: email,
      ),
    );
    if (!mounted) return;
    final error = ref.read(conditionControllerProvider).errorMessage;
    if (error != null) {
      _toast(error);
      notifier.clearError();
    } else {
      _toast('Condition added.', success: true);
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Participant? _counterpart() {
    final a = _agreement;
    if (a == null) return null;
    return _isDepositor ? a.beneficiary : a.depositor;
  }

  String _counterpartName() {
    final p = _counterpart();
    final name = p?.name?.trim();
    if (name != null && name.isNotEmpty) {
      return name.split(RegExp(r'\s+')).first;
    }
    final invite = ref
        .read(agreementControllerProvider)
        .value
        ?.invitations[_id];
    final email = p?.email ?? invite?.email;
    if (email != null && email.isNotEmpty) return email.split('@').first;
    return 'the other party';
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final me = ref.watch(authControllerProvider).userData;
    final agreementAsync = ref.watch(agreementControllerProvider);
    final agreement = _agreement;

    if (me == null) return const SizedBox.shrink();

    if (agreement == null) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: const AppTopBar(title: 'Agreement'),
        body: agreementAsync.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListStatePlaceholder.error(
                heading: "Couldn't find this agreement",
                detail:
                    'It may have been removed, or your list is out of date.',
                retryLabel: 'Refresh',
                onRetry: _refresh,
              ),
      );
    }

    final status = AgreementStatusHelper.normalize(agreement.status);
    final isDepositor = _isDepositor;
    final isParty =
        isDepositor ||
        (agreement.beneficiary?.email != null &&
            agreement.beneficiary!.email == me.email);
    final amount = double.tryParse(agreement.amount ?? '') ?? 0;

    final conditionState = ref.watch(conditionControllerProvider);
    final conditions = conditionState.conditionsFor(_id);
    final conditionsLoading = conditionState.isLoading && conditions.isEmpty;
    final disputes = ref.watch(disputeControllerProvider).disputesFor(_id);
    final hasLiveDispute = ref
        .watch(disputeControllerProvider)
        .hasLiveDispute(_id);

    final invitation = agreementAsync.value?.invitations[_id];
    final invitationLoading = agreementAsync.value?.invitationLoading ?? false;
    final isCancelling = agreementAsync.value?.isCancelling ?? false;
    final isFunding = agreementAsync.value?.isFundingAgreement(_id) ?? false;
    // Both of these are global to the controller, so they only count when this
    // screen is the one doing the work. Otherwise the blocking overlay lands
    // on whatever agreement the user happens to open next.
    final isAccepting =
        _actingHere && (agreementAsync.value?.isAccepting ?? false);
    final stage = isFunding
        ? (agreementAsync.value?.fundingStage ?? EscrowFundingStage.idle)
        : EscrowFundingStage.idle;

    final actions = resolveAgreementActions(
      status: status,
      isDepositor: isDepositor,
      isFunded: agreement.isFunded,
      currentUserAccepted: agreement.currentUserAccepted,
      hasConditions: conditions.isNotEmpty,
      hasLiveDispute: hasLiveDispute,
    );
    final canAdd = AgreementStatusHelper.canAddConditions(status);
    final counterpartName = _counterpartName();
    final met = conditions
        .where((c) => ConditionStatusHelper.isMet(c.status))
        .length;

    final nextStep = nextStepFor(
      status: status,
      isDepositor: isDepositor,
      isFunded: agreement.isFunded,
      currentUserAccepted: agreement.currentUserAccepted,
      hasConditions: conditions.isNotEmpty,
      hasLiveDispute: hasLiveDispute,
      otherPartyName: counterpartName,
      conditionsMet: met,
      conditionsTotal: conditions.length,
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppTopBar(
        title: 'Agreement',
        actions: [
          if (actions.overflow.isNotEmpty)
            AppIconButton(
              icon: Iconsax.more_copy,
              semanticLabel: 'More options',
              onPressed: () async {
                final choice = await showAgreementOptionsSheet(
                  context,
                  actions: actions.overflow,
                );
                if (choice != null) _perform(choice);
              },
            ),
        ],
      ),
      bottomNavigationBar: actions.hasBar
          ? BottomActionBar(
              primary: actions.primary != null
                  ? PrimaryButton(
                      label: agreementActionLabel(
                        actions.primary!,
                        isDepositor: isDepositor,
                      ),
                      icon: actions.primary == AgreementAction.fund
                          ? Iconsax.wallet_add
                          : Iconsax.tick_circle,
                      loading: isFunding || isAccepting,
                      onPressed: () => _perform(actions.primary!),
                    )
                  : SecondaryButton(
                      label: agreementActionLabel(
                        actions.secondary!,
                        isDepositor: isDepositor,
                      ),
                      tone: ButtonTone.danger,
                      loading: isCancelling,
                      onPressed: () => _perform(actions.secondary!),
                    ),
              secondary: actions.primary != null && actions.secondary != null
                  ? SecondaryButton(
                      label: actions.secondary == AgreementAction.cancel
                          ? 'Cancel'
                          : 'Dispute',
                      tone: ButtonTone.danger,
                      loading: isCancelling,
                      onPressed: () => _perform(actions.secondary!),
                    )
                  : null,
            )
          : null,
      body: Stack(
        children: [
          RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.sm,
                AppSpacing.gutter,
                AppSpacing.xxxl,
              ),
              children: [
                AgreementSummaryHeader(
                  agreement: agreement,
                  counterpart: _counterpart(),
                  counterpartName: counterpartName,
                  isDepositor: isDepositor,
                  isParty: isParty,
                ).entrance(context, 0),
                const SizedBox(height: AppSpacing.lg),
                NextStepBanner(copy: nextStep).entrance(context, 1),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  'Parties',
                  style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.md),
                PartiesSection(
                  depositor: agreement.depositor,
                  beneficiary: agreement.beneficiary,
                  invitationEmail: invitation?.email,
                  currentUserEmail: me.email,
                  loading: invitationLoading,
                ).entrance(context, 2),
                const SizedBox(height: AppSpacing.xxl),
                ConditionsTimeline(
                  conditions: conditions,
                  loading: conditionsLoading,
                  canAdd: canAdd,
                  showProgress: !canAdd,
                  currentUserEmail: me.email,
                  onAdd: _onAddCondition,
                  onTap: (condition) => context.push(
                    '/condition/${condition.id}?agreementId=$_id',
                  ),
                ).entrance(context, 3),
                DisputesSection(disputes: disputes, currentUserEmail: me.email),
              ],
            ),
          ),
          FundingOverlay(
            isAccepting: isAccepting,
            stage: stage,
            amount: amount,
          ),
        ],
      ),
    );
  }
}
