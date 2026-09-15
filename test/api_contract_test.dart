import 'package:adehun_mvp/domain/models/notification_type.dart';
import 'package:adehun_mvp/utils/agreement_status.dart';
import 'package:flutter_test/flutter_test.dart';

/// The API's AgreementStatus enum, verbatim. Sent lowercase.
const _apiAgreementStatuses = [
  'pending',
  'active',
  'disputed',
  'completed',
  'cancelled',
  'refunded',
];

/// The API's NotificationType enum, verbatim.
const _apiNotificationTypes = {
  'invitation_received': NotificationType.invitationReceived,
  'agreement_accepted': NotificationType.agreementAccepted,
  'agreement_declined': NotificationType.agreementDeclined,
  'condition_added': NotificationType.conditionAdded,
  'condition_updated': NotificationType.conditionUpdated,
  'agreement_completed': NotificationType.agreementCompleted,
  'agreement_cancelled': NotificationType.agreementCancelled,
  'escrow_funded': NotificationType.escrowFunded,
  'escrow_released': NotificationType.escrowReleased,
  'escrow_refunded': NotificationType.escrowRefunded,
  'wallet_credited': NotificationType.walletCredited,
  'withdrawal_completed': NotificationType.withdrawalCompleted,
  'withdrawal_failed': NotificationType.withdrawalFailed,
  'dispute_raised': NotificationType.disputeRaised,
  'dispute_evidence_added': NotificationType.disputeEvidenceAdded,
  'dispute_under_review': NotificationType.disputeUnderReview,
  'dispute_resolved': NotificationType.disputeResolved,
  'general': NotificationType.general,
};

void main() {
  group('AgreementStatus', () {
    test('every status the API sends normalizes to a known constant', () {
      const known = {
        AgreementStatusHelper.pending,
        AgreementStatusHelper.active,
        AgreementStatusHelper.disputed,
        AgreementStatusHelper.completed,
        AgreementStatusHelper.cancelled,
        AgreementStatusHelper.refunded,
      };

      for (final raw in _apiAgreementStatuses) {
        expect(
          known,
          contains(AgreementStatusHelper.normalize(raw)),
          reason: '$raw did not normalize to a known status',
        );
      }
    });

    test('every status the API sends gets a real display label', () {
      for (final raw in _apiAgreementStatuses) {
        final label = AgreementStatusHelper.displayLabel(raw);
        expect(label, isNotEmpty);
        // A raw enum value leaking into the UI means the switch missed it.
        expect(label, isNot(equals(raw)));
      }
    });

    test('the funded-escrow states are recognised', () {
      expect(AgreementStatusHelper.isActiveLike('active'), isTrue);
      expect(AgreementStatusHelper.isDisputedLike('disputed'), isTrue);
      expect(AgreementStatusHelper.isCompletedLike('completed'), isTrue);
      expect(AgreementStatusHelper.isCancelledLike('cancelled'), isTrue);
      expect(AgreementStatusHelper.isRefundedLike('refunded'), isTrue);
    });

    // Conditions are only editable before the escrow can be funded.
    test('conditions can only be added while pending', () {
      expect(AgreementStatusHelper.canAddConditions('pending'), isTrue);
      expect(AgreementStatusHelper.canAddConditions('active'), isFalse);
      expect(AgreementStatusHelper.canAddConditions('completed'), isFalse);
    });
  });

  group('NotificationType', () {
    test('maps every type the API sends', () {
      _apiNotificationTypes.forEach((raw, expected) {
        expect(
          NotificationType.fromRaw(raw),
          expected,
          reason: '$raw mapped to the wrong variant',
        );
      });
    });

    // A type added server-side must degrade, not throw.
    test('an unknown type falls back to general', () {
      expect(
        NotificationType.fromRaw('something_new'),
        NotificationType.general,
      );
    });

    test('no API type is silently swallowed as general', () {
      final swallowed = _apiNotificationTypes.keys
          .where((raw) => raw != 'general')
          .where(
            (raw) => NotificationType.fromRaw(raw) == NotificationType.general,
          )
          .toList();

      expect(swallowed, isEmpty, reason: 'unmapped types: $swallowed');
    });

    test('event groupings are consistent', () {
      expect(NotificationType.walletCredited.isWalletEvent, isTrue);
      expect(NotificationType.withdrawalFailed.isWalletEvent, isTrue);
      expect(NotificationType.escrowFunded.isWalletEvent, isFalse);

      expect(NotificationType.disputeRaised.isDisputeEvent, isTrue);
      expect(NotificationType.disputeResolved.isDisputeEvent, isTrue);
      expect(NotificationType.general.isDisputeEvent, isFalse);

      expect(NotificationType.escrowRefunded.isEscrowEvent, isTrue);
      expect(NotificationType.walletCredited.isEscrowEvent, isFalse);
    });
  });
}
