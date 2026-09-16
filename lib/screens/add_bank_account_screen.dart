import 'package:adehun_mvp/controllers/bank_account_controller.dart';
import 'package:adehun_mvp/domain/models/bank.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_bottom_sheet.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_toast.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/info_banner.dart';
import '../widgets/labeled_field.dart';

class AddBankAccountScreen extends ConsumerStatefulWidget {
  const AddBankAccountScreen({super.key});

  @override
  ConsumerState<AddBankAccountScreen> createState() =>
      _AddBankAccountScreenState();
}

class _AddBankAccountScreenState extends ConsumerState<AddBankAccountScreen> {
  final _numberController = TextEditingController();
  Bank? _bank;
  bool _makeDefault = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(bankAccountControllerProvider.notifier);
      notifier.clearResolved();
      notifier.loadBanks();
    });
    _numberController.addListener(_maybeResolve);
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  String get _number => _numberController.text.trim();

  /// Nigerian NUBAN numbers are 10 digits; resolve as soon as we have one.
  void _maybeResolve() {
    final notifier = ref.read(bankAccountControllerProvider.notifier);
    if (_number.length == 10 && _bank != null) {
      notifier.resolve(accountNumber: _number, bankCode: _bank!.code);
    } else {
      notifier.clearResolved();
    }
    setState(() {});
  }

  Future<void> _pickBank() async {
    final state = ref.read(bankAccountControllerProvider);
    final chosen = await showAppBottomSheet<Bank>(
      context,
      title: 'Choose your bank',
      builder: (_) => _BankPicker(banks: state.banks),
    );
    if (chosen == null) return;
    setState(() => _bank = chosen);
    _maybeResolve();
  }

  Future<void> _save() async {
    final bank = _bank;
    if (bank == null) return;
    final ok = await ref.read(bankAccountControllerProvider.notifier).add(
          accountNumber: _number,
          bankCode: bank.code,
          makeDefault: _makeDefault,
        );
    if (!mounted) return;
    if (ok) {
      showAppToast(context, 'Bank account added', kind: ToastKind.success);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(bankAccountControllerProvider);
    final resolved = state.resolved;
    final canSave = resolved != null && !state.isSaving && _number.length == 10;

    ref.listen(bankAccountControllerProvider, (prev, next) {
      final error = next.errorMessage;
      if (error != null && error != prev?.errorMessage) {
        showAppToast(context, error, kind: ToastKind.error);
        ref.read(bankAccountControllerProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AppTopBar(title: 'Add bank account'),
      bottomNavigationBar: BottomActionBar(
        primary: PrimaryButton(
          label: 'Save account',
          loading: state.isSaving,
          onPressed: canSave ? _save : null,
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
            Text(
              'Withdrawals are paid to this account. We confirm the account name with your bank before saving.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Bank',
              style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Semantics(
              button: true,
              label: _bank?.name ?? 'Choose your bank',
              child: Material(
                color: colors.surfaceVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.input,
                  side: BorderSide(color: colors.cardBorder),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: state.isLoadingBanks ? null : _pickBank,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      children: [
                        Icon(Iconsax.bank_copy, color: colors.textSecondary),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            _bank?.name ??
                                (state.isLoadingBanks
                                    ? 'Loading banks…'
                                    : 'Choose your bank'),
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: _bank == null
                                  ? colors.textTertiary
                                  : colors.textPrimary,
                            ),
                          ),
                        ),
                        Icon(Iconsax.arrow_down_1, color: colors.textTertiary),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            LabeledField(
              label: 'Account number',
              hint: '10-digit NUBAN',
              controller: _numberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              prefix: const Icon(Iconsax.card_copy),
            ),
            const SizedBox(height: AppSpacing.lg),
            AnimatedSwitcher(
              duration: AppMotion.normal,
              child: state.isResolving
                  ? const InfoBanner(
                      key: ValueKey('resolving'),
                      tone: BannerTone.neutral,
                      icon: Iconsax.refresh,
                      message: 'Checking the account name with your bank…',
                    )
                  : resolved != null
                      ? InfoBanner(
                          key: const ValueKey('resolved'),
                          tone: BannerTone.success,
                          title: resolved.accountName,
                          message: 'Account verified.',
                        )
                      : const SizedBox.shrink(key: ValueKey('none')),
            ),
            const SizedBox(height: AppSpacing.lg),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _makeDefault,
              activeTrackColor: AppColors.primary,
              onChanged: (v) => setState(() => _makeDefault = v),
              title: Text(
                'Use for withdrawals by default',
                style: AppTextStyles.bodyLarge.copyWith(color: colors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BankPicker extends StatefulWidget {
  final List<Bank> banks;
  const _BankPicker({required this.banks});

  @override
  State<_BankPicker> createState() => _BankPickerState();
}

class _BankPickerState extends State<_BankPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final filtered = widget.banks
        .where((b) => b.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: Column(
        children: [
          TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Search banks',
              prefixIcon: Icon(Iconsax.search_normal_1_copy),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No banks match',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(filtered[i].name),
                      trailing: Icon(
                        Iconsax.arrow_right_3_copy,
                        size: 16,
                        color: colors.textTertiary,
                      ),
                      onTap: () => Navigator.pop(context, filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
