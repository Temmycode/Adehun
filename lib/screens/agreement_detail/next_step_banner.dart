import 'package:flutter/material.dart';

import '../../utils/agreement_status.dart';
import '../../widgets/info_banner.dart';

typedef NextStepCopy = ({BannerTone tone, String title, String message});

/// What happens next, in plain words, for this user and status.
NextStepCopy nextStepFor({
  required String? status,
  required bool isDepositor,
  required bool isFunded,
  required bool currentUserAccepted,
  required bool hasConditions,
  required bool hasLiveDispute,
  required String otherPartyName,
  required int conditionsMet,
  required int conditionsTotal,
}) {
  switch (AgreementStatusHelper.normalize(status)) {
    case AgreementStatusHelper.draft:
    case AgreementStatusHelper.pending:
      if (!hasConditions) {
        return (
          tone: BannerTone.info,
          title: 'Add at least one condition',
          message:
              'Conditions spell out what has to happen before the money is released. Either side can add them.',
        );
      }
      if (!currentUserAccepted) {
        return (
          tone: BannerTone.warning,
          title: 'Your turn to agree',
          message: isDepositor
              ? 'Check the conditions. When you agree, the amount moves from your wallet into escrow.'
              : 'Check the conditions. When you agree, $otherPartyName funds the escrow. Nothing is charged to you.',
        );
      }
      return (
        tone: BannerTone.neutral,
        title: 'Waiting for $otherPartyName',
        message:
            "You've agreed. The agreement activates as soon as $otherPartyName agrees too.",
      );
    case AgreementStatusHelper.active:
      if (hasLiveDispute) {
        return (
          tone: BannerTone.error,
          title: 'Dispute in progress',
          message:
              'Funds stay locked while our team reviews. We will notify both of you with the outcome.',
        );
      }
      if (!isFunded) {
        return isDepositor
            ? (
                tone: BannerTone.warning,
                title: 'Fund escrow to get started',
                message:
                    "$otherPartyName can't be paid until the money is in escrow. Fund it now so work can begin.",
              )
            : (
                tone: BannerTone.neutral,
                title: 'Waiting for $otherPartyName to fund escrow',
                message:
                    "We'll let you know the moment the money is locked in. No need to start before then.",
              );
      }
      final remaining = conditionsTotal - conditionsMet;
      return isDepositor
          ? (
              tone: BannerTone.success,
              title: 'Money is safely in escrow',
              message: remaining <= 0
                  ? 'Every condition is approved. The funds will be released to $otherPartyName.'
                  : 'Approve each condition as $otherPartyName delivers it. $remaining of $conditionsTotal still to go.',
            )
          : (
              tone: BannerTone.success,
              title: 'Money is safely in escrow',
              message: remaining <= 0
                  ? 'Every condition is approved. The funds are on their way to you.'
                  : 'Deliver each condition and submit it for approval. $remaining of $conditionsTotal still to go.',
            );
    case AgreementStatusHelper.completed:
      return (
        tone: BannerTone.success,
        title: 'Completed',
        message: isDepositor
            ? 'All conditions were approved and the funds went to $otherPartyName. Nice work.'
            : 'All conditions were approved and the funds were released to you. Nice work.',
      );
    case AgreementStatusHelper.disputed:
      return (
        tone: BannerTone.error,
        title: 'Under dispute',
        message:
            'Funds stay locked while our team reviews. We will notify both of you with the outcome.',
      );
    case AgreementStatusHelper.cancelled:
      return (
        tone: BannerTone.neutral,
        title: 'Cancelled',
        message: 'This agreement was cancelled before any money moved.',
      );
    case AgreementStatusHelper.refunded:
      return (
        tone: BannerTone.neutral,
        title: 'Refunded',
        message: isDepositor
            ? 'The escrow amount has been returned to your wallet.'
            : 'The escrow amount was returned to $otherPartyName.',
      );
    default:
      return (
        tone: BannerTone.neutral,
        title: AgreementStatusHelper.displayLabel(status),
        message: 'Pull down to refresh for the latest status.',
      );
  }
}

class NextStepBanner extends StatelessWidget {
  final NextStepCopy copy;
  final String? actionLabel;
  final VoidCallback? onAction;

  const NextStepBanner({
    super.key,
    required this.copy,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return InfoBanner(
      tone: copy.tone,
      title: copy.title,
      message: copy.message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}
