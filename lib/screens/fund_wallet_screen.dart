import 'package:adehun_mvp/controllers/fund_wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../core/utils/format_currency.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../widgets/amount_field.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_card.dart';
import '../widgets/app_toast.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/info_banner.dart';

class FundWalletScreen extends ConsumerStatefulWidget {
  const FundWalletScreen({super.key});

  @override
  ConsumerState<FundWalletScreen> createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends ConsumerState<FundWalletScreen> {
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _method = 'card';
  double? _amount;

  static const _methods = [
    (
      'card',
      Iconsax.card,
      'Debit card',
      'Instant. Paystack may add a small card fee.',
    ),
    (
      'bank',
      Iconsax.bank,
      'Bank transfer',
      'Transfer from your bank app. Usually a few minutes.',
    ),
    (
      'ussd',
      Iconsax.mobile,
      'USSD',
      'Dial a code from your phone. No internet needed.',
    ),
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _fund() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amount = AmountField.parse(_amountController.text);
    if (amount == null || amount <= 0) return;

    final funded = await ref
        .read(fundWalletControllerProvider.notifier)
        .fundWallet(amount, _method);
    if (!mounted) return;
    // On failure we stay put so the user can retry; the error toast is wired
    // up in build() via ref.listen.
    if (funded) context.push('/success/funds-deposited');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fundState = ref.watch(fundWalletControllerProvider);

    ref.listen(fundWalletControllerProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        showAppToast(context, next.error!, kind: ToastKind.error);
      }
    });

    final amount = _amount ?? 0;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AppTopBar(title: 'Fund wallet'),
      bottomNavigationBar: BottomActionBar(
        primary: PrimaryButton(
          label: amount > 0 ? 'Fund ${formatMoney(amount)}' : 'Fund wallet',
          loading: fundState.isLoading,
          onPressed: fundState.isLoading ? null : _fund,
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
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AmountField(
                controller: _amountController,
                label: 'How much?',
                autofocus: true,
                quickAmounts: const [5000, 10000, 25000, 50000],
                onChanged: (v) => setState(() => _amount = v),
                validator: (value) {
                  final parsed = AmountField.parse(value ?? '');
                  if (parsed == null || parsed <= 0) return 'Enter an amount';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Text(
                'Pay with',
                style: AppTextStyles.labelLarge.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final (id, icon, title, subtitle) in _methods)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _MethodCard(
                    icon: icon,
                    title: title,
                    subtitle: subtitle,
                    selected: _method == id,
                    onTap: () => setState(() => _method = id),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              const InfoBanner(
                tone: BannerTone.neutral,
                icon: Iconsax.shield_tick_copy,
                message:
                    'Payments are processed by Paystack. Your card details never touch Adehun.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _MethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      label: '$title. $subtitle',
      child: AppCard(
        onTap: onTap,
        color: selected ? colors.primarySurface : colors.surface,
        borderColor: selected ? AppColors.primary : colors.cardBorder,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : colors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                icon,
                size: 22,
                color: selected ? Colors.white : colors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AnimatedContainer(
              duration: AppMotion.fast,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.primary : colors.cardBorder,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
