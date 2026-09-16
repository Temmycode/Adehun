import 'package:adehun_mvp/controllers/agreement_controller.dart';
import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/controllers/fund_wallet_controller.dart';
import 'package:adehun_mvp/controllers/wallet_data_controller.dart';
import 'package:adehun_mvp/usecases/params/create_agreement_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_color_scheme.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/amount_field.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_action_bar.dart';
import '../../widgets/condition_editor_sheet.dart';
import '../../widgets/step_indicator.dart';
import 'draft_condition.dart';
import 'steps/conditions_step.dart';
import 'steps/details_step.dart';
import 'steps/review_step.dart';
import 'steps/role_step.dart';

class CreateAgreementScreen extends ConsumerStatefulWidget {
  const CreateAgreementScreen({super.key});

  @override
  ConsumerState<CreateAgreementScreen> createState() =>
      _CreateAgreementScreenState();
}

class _CreateAgreementScreenState extends ConsumerState<CreateAgreementScreen> {
  static const _labels = ['Details', 'Parties', 'Conditions', 'Review'];

  final _pageController = PageController();
  final _detailsFormKey = GlobalKey<FormState>();
  final _partiesFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _inviteController = TextEditingController();

  int _step = 0;
  String _role = 'depositor';
  bool _conditionsError = false;
  final List<DraftCondition> _conditions = [];

  bool get _isLast => _step == _labels.length - 1;

  String get _otherRole => _role == 'depositor' ? 'beneficiary' : 'depositor';

  String get _otherName {
    final invite = _inviteController.text.trim();
    if (invite.isEmpty) return 'Other party';
    return invite.contains('@') ? invite.split('@').first : invite;
  }

  List<ConditionParty> get _parties => [
        ConditionParty(id: DraftCondition.me, name: 'You', role: _role, isMe: true),
        ConditionParty(id: DraftCondition.other, name: _otherName, role: _otherRole),
      ];

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _inviteController.dispose();
    super.dispose();
  }

  // ── Navigation ───────────────────────────────────────────────────────────

  void _goTo(int step) {
    FocusScope.of(context).unfocus();
    setState(() => _step = step);
    _pageController.animateToPage(
      step,
      duration: AppMotion.slow,
      curve: AppMotion.curve,
    );
  }

  bool _validateStep(int step) {
    switch (step) {
      case 0:
        return _detailsFormKey.currentState?.validate() ?? false;
      case 1:
        return _partiesFormKey.currentState?.validate() ?? false;
      case 2:
        final ok = _conditions.isNotEmpty;
        setState(() => _conditionsError = !ok);
        return ok;
      default:
        return true;
    }
  }

  void _next() {
    if (!_validateStep(_step)) return;
    if (_isLast) {
      _submit();
      return;
    }
    _goTo(_step + 1);
  }

  void _back() {
    if (_step == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    _goTo(_step - 1);
  }

  // ── Conditions ───────────────────────────────────────────────────────────

  Future<void> _addCondition({String? suggestedTitle}) async {
    final draft = await showConditionEditorSheet(
      context,
      parties: _parties,
      suggestedTitle: suggestedTitle,
    );
    if (draft == null || !mounted) return;
    setState(() {
      _conditions.add(DraftCondition(
        title: draft.title,
        description: draft.description,
        partyId: draft.partyId,
      ));
      _conditionsError = false;
    });
  }

  Future<void> _editCondition(int index) async {
    final current = _conditions[index];
    final draft = await showConditionEditorSheet(
      context,
      parties: _parties,
      initial: ConditionDraft(
        title: current.title,
        description: current.description,
        partyId: current.partyId,
      ),
    );
    if (draft == null || !mounted) return;
    setState(() {
      _conditions[index] = DraftCondition(
        title: draft.title,
        description: draft.description,
        partyId: draft.partyId,
      );
    });
  }

  // ── Submit ───────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    final amount = AmountField.parse(_amountController.text) ?? 0;
    final invite = _inviteController.text.trim();

    // The API wants a real email per condition, so both sides have to resolve
    // to one. Conditions on yourself use your own account email.
    final myEmail = ref.read(authControllerProvider).userData?.email?.trim();
    if (myEmail == null || myEmail.isEmpty) {
      _error("Couldn't read your account email. Please sign in again.");
      return;
    }

    // The invite field accepts a phone number, but `required_from_email` only
    // accepts an email, so a phone invite can't carry conditions for the
    // other party. Checked before the top-up so a request that can never
    // succeed doesn't charge the user first.
    final inviteIsEmail = emailRegex.hasMatch(invite);
    final hasConditionForOther = _conditions.any((c) => !c.isForMe);
    if (hasConditionForOther && !inviteIsEmail) {
      _error(
        'Invite the other party by email. Conditions they have to fulfil need an email address, not a phone number.',
      );
      _goTo(1);
      return;
    }

    // A depositor has to cover the escrow up front, so top up the shortfall
    // before creating anything.
    if (_role == 'depositor') {
      // Null rather than zero: the balance arrives over a socket, and treating
      // "not delivered yet" as zero would charge the full amount even when the
      // user already has the funds.
      final double? walletBalance = ref
          .read(walletDataControllerProvider)
          .maybeWhen(data: (data) => data.availableBalance, orElse: () => null);

      if (walletBalance == null) {
        _error("Couldn't read your wallet balance. Please try again.");
        return;
      }

      if (walletBalance < amount) {
        final funded = await ref
            .read(fundWalletControllerProvider.notifier)
            .fundWallet(amount - walletBalance, 'card');
        if (!mounted) return;
        if (!funded) {
          final error = ref.read(fundWalletControllerProvider).error;
          _error(error ?? 'Payment was not completed.');
          return;
        }
      }
    }

    final params = CreateAgreementParams(
      otherParticipantEmailOrPhone: invite,
      role: _role,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      amount: CreateAgreementParams.formatAmount(amount),
      conditions: [
        for (final c in _conditions)
          CreateConditionParams(
            title: c.title,
            description: c.description.isEmpty ? c.title : c.description,
            requiredFromEmail: c.isForMe ? myEmail : invite,
          ),
      ],
    );

    await ref.read(agreementControllerProvider.notifier).createAgreement(params);
  }

  void _error(String message) {
    if (!mounted) return;
    showAppToast(context, message, kind: ToastKind.error);
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Submitting can involve two sequential async legs, topping up the wallet
    // and then creating the agreement. The button reflects both.
    final isCreating = ref.watch(
      agreementControllerProvider.select((s) => s.value?.isCreating ?? false),
    );
    final isFunding = ref.watch(
      fundWalletControllerProvider.select((s) => s.isLoading),
    );
    final isBusy = isCreating || isFunding;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppTopBar(
        title: 'New agreement',
        onBack: _back,
      ),
      bottomNavigationBar: BottomActionBar(
        secondary: _step > 0
            ? SecondaryButton(label: 'Back', onPressed: isBusy ? null : _back)
            : null,
        primary: PrimaryButton(
          label: _isLast ? 'Send agreement' : 'Continue',
          loading: isBusy && _isLast,
          onPressed: isBusy ? null : _next,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.sm,
              AppSpacing.gutter,
              AppSpacing.lg,
            ),
            child: StepIndicator(current: _step, labels: _labels),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _StepPage(
                  child: DetailsStep(
                    formKey: _detailsFormKey,
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                    amountController: _amountController,
                  ),
                ),
                _StepPage(
                  child: RoleStep(
                    formKey: _partiesFormKey,
                    role: _role,
                    onRoleChanged: (role) => setState(() => _role = role),
                    inviteController: _inviteController,
                  ),
                ),
                _StepPage(
                  child: ConditionsStep(
                    conditions: _conditions,
                    otherPartyName: _otherName,
                    showError: _conditionsError,
                    onAdd: _addCondition,
                    onAddFromTemplate: (title) =>
                        _addCondition(suggestedTitle: title),
                    onEdit: _editCondition,
                    onDelete: (i) => setState(() => _conditions.removeAt(i)),
                  ),
                ),
                _StepPage(
                  child: ReviewStep(
                    title: _titleController.text.trim(),
                    description: _descriptionController.text.trim(),
                    amount: AmountField.parse(_amountController.text) ?? 0,
                    role: _role,
                    invite: _inviteController.text.trim(),
                    conditions: _conditions,
                    onEditStep: _goTo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepPage extends StatelessWidget {
  final Widget child;

  const _StepPage({required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.sm,
        AppSpacing.gutter,
        AppSpacing.xxxl,
      ),
      child: child,
    );
  }
}
