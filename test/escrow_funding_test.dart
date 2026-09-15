import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/models/escrow_movement_response.dart';
import 'package:adehun_mvp/domain/states/agreement_state.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _agreementJson({bool? isFunded}) => {
  'id': 'agreement-1',
  'title': 'Social Media Graphics',
  'description': 'Five posts',
  'amount': '35000.00',
  'status': 'ACTIVE',
  'depositor': {
    'id': 'p1',
    'role': 'depositor',
    'status': 'accepted',
    'user': {'id': 'u1', 'name': 'Ada Lovelace', 'email': 'ada@example.com'},
  },
  'beneficiary': {
    'id': 'p2',
    'role': 'beneficiary',
    'status': 'accepted',
    'user': {'id': 'u2', 'name': 'Grace Hopper', 'email': 'grace@example.com'},
  },
  'created_at': '2026-08-20T09:30:00Z',
  'condition_count': 2,
  'conditions_met_count': 1,
  'current_user_accepted': true,
  'is_funded': ?isFunded,
};

void main() {
  group('AgreementResponse.isFunded', () {
    test('decodes is_funded from the API', () {
      expect(
        AgreementResponse.fromJson(_agreementJson(isFunded: true)).isFunded,
        isTrue,
      );
      expect(
        AgreementResponse.fromJson(_agreementJson(isFunded: false)).isFunded,
        isFalse,
      );
    });

    // An agreement whose funding state we can't see must read as unfunded, so
    // the Fund Escrow button shows rather than silently hiding.
    test('a missing is_funded defaults to false', () {
      expect(AgreementResponse.fromJson(_agreementJson()).isFunded, isFalse);
    });

    test('copyWith flips isFunded without disturbing anything else', () {
      final original = AgreementResponse.fromJson(_agreementJson());
      final funded = original.copyWith(isFunded: true);

      expect(funded.isFunded, isTrue);
      expect(funded.id, original.id);
      expect(funded.amount, original.amount);
      expect(funded.status, original.status);
      expect(funded.depositor?.email, 'ada@example.com');
      expect(funded.conditionsMetCount, 1);
      expect(original.isFunded, isFalse, reason: 'must not mutate in place');
    });

    test('survives a JSON round trip', () {
      final funded = AgreementResponse.fromJson(
        _agreementJson(),
      ).copyWith(isFunded: true);

      expect(AgreementResponse.fromJson(funded.toJson()).isFunded, isTrue);
    });
  });

  group('EscrowMovementResponse', () {
    test('decodes the fund response', () {
      final movement = EscrowMovementResponse.fromJson({
        'agreement_id': 'agreement-1',
        'amount': '35000.00',
        'reference': 'esc_lock_agreement-1',
        'available_balance': '15000.00',
        'escrow_balance': '35000.00',
        'replayed': false,
      });

      expect(movement.agreementId, 'agreement-1');
      expect(movement.amount, '35000.00');
      expect(movement.reference, 'esc_lock_agreement-1');
      expect(movement.availableBalance, '15000.00');
      expect(movement.escrowBalance, '35000.00');
      expect(movement.replayed, isFalse);
    });

    test('an omitted replayed flag defaults to false', () {
      final movement = EscrowMovementResponse.fromJson({
        'agreement_id': 'a',
        'amount': '1.00',
        'reference': 'r',
        'available_balance': '0.00',
        'escrow_balance': '1.00',
      });

      expect(movement.replayed, isFalse);
    });

    // A replay means the money moved on an earlier attempt. It is success.
    test('decodes a replayed movement', () {
      final movement = EscrowMovementResponse.fromJson({
        'agreement_id': 'a',
        'amount': '1.00',
        'reference': 'r',
        'available_balance': '0.00',
        'escrow_balance': '1.00',
        'replayed': true,
      });

      expect(movement.replayed, isTrue);
    });
  });

  group('AgreementState funding', () {
    const idle = AgreementState();

    test('starts idle with nothing funding', () {
      expect(idle.fundingStage, EscrowFundingStage.idle);
      expect(idle.fundingAgreementId, isNull);
      expect(idle.fundError, isNull);
      expect(idle.isFundingAgreement('agreement-1'), isFalse);
    });

    // The controller is keepAlive, so a global flag would spin the button on an
    // unrelated agreement's screen.
    test('isFundingAgreement is scoped to the agreement being funded', () {
      final funding = idle.copyWith(
        fundingAgreementId: () => 'agreement-1',
        fundingStage: EscrowFundingStage.movingToEscrow,
      );

      expect(funding.isFundingAgreement('agreement-1'), isTrue);
      expect(funding.isFundingAgreement('agreement-2'), isFalse);
    });

    test('a stage without an id is not funding anything', () {
      final stray = idle.copyWith(
        fundingStage: EscrowFundingStage.movingToEscrow,
      );

      expect(stray.isFundingAgreement('agreement-1'), isFalse);
    });

    test('copyWith clears fundingAgreementId and fundError explicitly', () {
      final busy = idle.copyWith(
        fundingAgreementId: () => 'agreement-1',
        fundError: () => 'boom',
        fundingStage: EscrowFundingStage.toppingUp,
      );

      final cleared = busy.copyWith(
        fundingStage: EscrowFundingStage.idle,
        fundingAgreementId: () => null,
        fundError: () => null,
      );

      expect(cleared.fundingAgreementId, isNull);
      expect(cleared.fundError, isNull);
      expect(cleared.isFundingAgreement('agreement-1'), isFalse);
    });

    // The finally block resets the stage but deliberately leaves fundError so
    // the screen can still read it after the call returns.
    test('omitting the wrapped setters preserves the existing values', () {
      final busy = idle.copyWith(
        fundingAgreementId: () => 'agreement-1',
        fundError: () => 'Payment was not completed.',
      );

      final stageOnly = busy.copyWith(
        fundingStage: EscrowFundingStage.movingToEscrow,
      );

      expect(stageOnly.fundError, 'Payment was not completed.');
      expect(stageOnly.fundingAgreementId, 'agreement-1');
    });

    test('funding fields do not disturb the rest of the state', () {
      final withAgreements = idle.copyWith(
        agreements: [AgreementResponse.fromJson(_agreementJson())],
        isAccepting: true,
      );

      final funding = withAgreements.copyWith(
        fundingAgreementId: () => 'agreement-1',
      );

      expect(funding.agreements, hasLength(1));
      expect(funding.isAccepting, isTrue);
    });
  });
}
