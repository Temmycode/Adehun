import 'package:adehun_mvp/domain/states/agreement_state.dart';
import 'package:flutter/material.dart';

import '../../core/utils/format_currency.dart';
import '../../theme/app_color_scheme.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/app_card.dart';

/// Blocks the screen while accepting or funding is in flight.
///
/// The barrier is the point: without it a user can tap Raise Dispute or
/// navigate away while their money is moving.
class FundingOverlay extends StatelessWidget {
  final bool isAccepting;
  final EscrowFundingStage stage;
  final double amount;

  const FundingOverlay({
    super.key,
    required this.isAccepting,
    required this.stage,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    if (!isAccepting && stage == EscrowFundingStage.idle) {
      return const SizedBox.shrink();
    }
    final colors = context.colors;

    final (label, subline) = switch (stage) {
      EscrowFundingStage.toppingUp => ('Opening secure checkout…', null),
      EscrowFundingStage.awaitingSettlement => (
        'Confirming your payment…',
        'This can take up to 30 seconds.',
      ),
      EscrowFundingStage.movingToEscrow => (
        'Moving ${formatMoney(amount)} into escrow…',
        null,
      ),
      EscrowFundingStage.idle => ('Activating agreement…', null),
    };

    return Positioned.fill(
      child: AbsorbPointer(
        child: ColoredBox(
          color: colors.background.withValues(alpha: 0.88),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.huge),
              child: AppCard(
                floating: true,
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: colors.textPrimary,
                      ),
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
      ),
    );
  }
}
