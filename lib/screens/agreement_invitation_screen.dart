import 'package:adehun_mvp/controllers/agreement_controller.dart';
import 'package:adehun_mvp/controllers/condition_controller.dart';
import 'package:adehun_mvp/controllers/invitation_providers.dart';
import 'package:adehun_mvp/domain/models/invitation_response.dart';
import 'package:adehun_mvp/widgets/list_state_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Shows a pending invitation for [agreementId] and lets the user accept or
/// decline it. The invitation is resolved from the server (never from a
/// payload smuggled through the URL).
class AgreementInvitationScreen extends ConsumerStatefulWidget {
  final String agreementId;

  const AgreementInvitationScreen({super.key, required this.agreementId});

  @override
  ConsumerState<AgreementInvitationScreen> createState() =>
      _AgreementInvitationScreenState();
}

class _AgreementInvitationScreenState
    extends ConsumerState<AgreementInvitationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(conditionControllerProvider.notifier)
          .getAgreementConditions(widget.agreementId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final invitations = ref.watch(invitedAgreementsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Agreement Invitation', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      body: invitations.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ListStatePlaceholder.error(
          heading: "Couldn't load the invitation",
          detail: err.toString(),
          onRetry: () => ref.invalidate(invitedAgreementsProvider),
        ),
        data: (list) {
          final matches = list.where(
            (inv) => inv.agreement.id == widget.agreementId,
          );
          if (matches.isEmpty) {
            return ListStatePlaceholder(
              icon: Iconsax.document_text_copy,
              title: 'Invitation not found',
              message:
                  'It may have been accepted, declined, or has expired. '
                  'Open the agreement from your list instead.',
              actionLabel: 'Go to agreements',
              onAction: () => context.go('/agreements'),
            );
          }
          return _InvitationBody(invitation: matches.first);
        },
      ),
    );
  }
}

class _InvitationBody extends ConsumerWidget {
  final InvitationResponse invitation;

  const _InvitationBody({required this.invitation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final agreement = invitation.agreement;
    final invitedBy = invitation.invitedByUser;
    final amount = double.tryParse(agreement.amount ?? '0') ?? 0;
    final conditions =
        ref.watch(conditionControllerProvider).conditions[agreement.id] ?? [];
    final agState = ref.watch(agreementControllerProvider);
    final isAccepting = agState.maybeWhen(
      data: (s) => s.isAccepting,
      orElse: () => false,
    );
    final isDeclining = agState.maybeWhen(
      data: (s) => s.isDeclining,
      orElse: () => false,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.primarySurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    invitedBy.initials,
                    style: AppTextStyles.h3.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                Text('${invitedBy.name} invited you', style: AppTextStyles.h3),
                const SizedBox(height: 4),
                Text(
                  'to an escrow agreement',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Agreement Summary', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow('Title', agreement.title ?? 'No title'),
                const SizedBox(height: 12),
                _DetailRow(
                  'Description',
                  agreement.description ?? 'No description',
                ),
                const SizedBox(height: 12),
                _DetailRow('Amount', '₦${_formatAmount(amount)}'),
                const SizedBox(height: 12),
                _DetailRow('Your Role', invitation.role),
                const SizedBox(height: 12),
                _DetailRow('Conditions', '${conditions.length} conditions'),
              ],
            ),
          ),
          if (conditions.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('Conditions', style: AppTextStyles.h3),
            const SizedBox(height: 10),
            ...conditions.map(
              (condition) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: colors.surfaceVariant,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Iconsax.tick_square_copy,
                        color: colors.textTertiary,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        condition.title ?? 'No title',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isDeclining
                      ? null
                      : () {
                          if (agreement.id == null) return;
                          ref
                              .read(agreementControllerProvider.notifier)
                              .declineAgreement(agreement.id!);
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                  ),
                  child: isDeclining
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.error,
                          ),
                        )
                      : const Text('Decline'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: isAccepting
                      ? null
                      : () {
                          if (agreement.id == null) return;
                          _acceptAndFund(context, ref, agreement.id!);
                        },
                  child: isAccepting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Accept'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Accepts, then moves the escrow funds in (a no-op for a beneficiary).
  Future<void> _acceptAndFund(
    BuildContext context,
    WidgetRef ref,
    String agreementId,
  ) async {
    final notifier = ref.read(agreementControllerProvider.notifier);

    final accepted = await notifier.acceptAgreement(agreementId);
    if (!context.mounted) return;

    if (!accepted) {
      _showSnack(context, "Couldn't accept the agreement. Please try again.");
      return;
    }
    ref.invalidate(invitedAgreementsProvider);

    await notifier.fundAgreement(agreementId);
    if (!context.mounted) return;

    final error = ref.read(agreementControllerProvider).value?.fundError;
    if (error == null) {
      context.go('/agreement/$agreementId');
      return;
    }

    _showSnack(context, error);
    notifier.clearFundError();
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
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
      if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
      buffer.write(whole[i]);
    }
    return '$buffer.$decimal';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: AppTextStyles.bodySmall),
        ),
        Expanded(child: Text(value, style: AppTextStyles.labelLarge)),
      ],
    );
  }
}
