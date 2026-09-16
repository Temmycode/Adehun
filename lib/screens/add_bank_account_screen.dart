import 'package:adehun_mvp/controllers/bank_account_controller.dart';
import 'package:adehun_mvp/domain/models/bank.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

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
  }

  Future<void> _pickBank() async {
    final state = ref.read(bankAccountControllerProvider);
    final chosen = await showModalBottomSheet<Bank>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _BankPicker(banks: state.banks),
    );
    if (chosen == null) return;
    setState(() => _bank = chosen);
    _maybeResolve();
  }

  Future<void> _save() async {
    final bank = _bank;
    if (bank == null) return;
    final ok = await ref
        .read(bankAccountControllerProvider.notifier)
        .add(
          accountNumber: _number,
          bankCode: bank.code,
          makeDefault: _makeDefault,
        );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Bank account added')));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(bankAccountControllerProvider);
    final resolved = state.resolved;
    final canSave =
        resolved != null && !state.isSaving && _number.length == 10;

    ref.listen(bankAccountControllerProvider, (prev, next) {
      final error = next.errorMessage;
      if (error != null && error != prev?.errorMessage) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error)));
        ref.read(bankAccountControllerProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Add Bank Account', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Withdrawals are paid to the account you add here. The account '
              'name is confirmed with the bank before it is saved.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Text('Bank', style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            InkWell(
              onTap: state.isLoadingBanks ? null : _pickBank,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.cardBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _bank?.name ??
                            (state.isLoadingBanks
                                ? 'Loading banks…'
                                : 'Select your bank'),
                        style: AppTextStyles.bodyMedium.copyWith(
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
            const SizedBox(height: 20),
            Text('Account number', style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: const InputDecoration(hintText: '10-digit number'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            if (state.isResolving)
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Verifying account…',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              )
            else if (resolved != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.successLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Iconsax.tick_circle, color: AppColors.success),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        resolved.accountName,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _makeDefault,
              onChanged: (v) => setState(() => _makeDefault = v),
              title: Text('Use as default for withdrawals',
                  style: AppTextStyles.bodyMedium),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSave ? _save : null,
                child: state.isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save account'),
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
      height: MediaQuery.sizeOf(context).height * 0.75,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search banks',
                prefixIcon: Icon(Iconsax.search_normal_1_copy),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
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
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => ListTile(
                      title: Text(filtered[i].name),
                      onTap: () => Navigator.pop(context, filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
