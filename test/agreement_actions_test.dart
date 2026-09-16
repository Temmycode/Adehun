import 'package:adehun_mvp/screens/agreement_detail/agreement_actions.dart';
import 'package:adehun_mvp/screens/agreement_detail/next_step_banner.dart';
import 'package:adehun_mvp/widgets/info_banner.dart';
import 'package:flutter_test/flutter_test.dart';

AgreementActions _resolve({
  String status = 'active',
  bool isDepositor = true,
  bool isFunded = true,
  bool currentUserAccepted = false,
  bool hasConditions = true,
  bool hasLiveDispute = false,
}) =>
    resolveAgreementActions(
      status: status,
      isDepositor: isDepositor,
      isFunded: isFunded,
      currentUserAccepted: currentUserAccepted,
      hasConditions: hasConditions,
      hasLiveDispute: hasLiveDispute,
    );

void main() {
  group('resolveAgreementActions', () {
    test('pending with conditions and not yet agreed offers agree', () {
      final a = _resolve(status: 'pending', isFunded: false);
      expect(a.primary, AgreementAction.agree);
      expect(a.secondary, AgreementAction.cancel);
    });

    test('pending after agreeing only offers cancel', () {
      final a = _resolve(
        status: 'pending',
        isFunded: false,
        currentUserAccepted: true,
      );
      expect(a.primary, isNull);
      expect(a.secondary, AgreementAction.cancel);
      expect(a.hasBar, isTrue);
    });

    test('pending without conditions cannot be agreed yet', () {
      final a = _resolve(status: 'pending', isFunded: false, hasConditions: false);
      expect(a.primary, isNull);
    });

    test('active and unfunded asks the depositor to fund', () {
      final a = _resolve(isFunded: false);
      expect(a.primary, AgreementAction.fund);
      expect(a.overflow, contains(AgreementAction.cancel));
    });

    test('active and unfunded does not ask the beneficiary to fund', () {
      final a = _resolve(isFunded: false, isDepositor: false);
      expect(a.primary, isNull);
      expect(a.secondary, AgreementAction.raiseDispute);
    });

    test('active and funded offers a dispute but no cancel', () {
      final a = _resolve();
      expect(a.primary, isNull);
      expect(a.secondary, AgreementAction.raiseDispute);
      expect(a.overflow, isNot(contains(AgreementAction.cancel)));
    });

    test('a live dispute removes fund and dispute actions', () {
      final a = _resolve(isFunded: false, hasLiveDispute: true);
      expect(a.primary, isNull);
      expect(a.secondary, isNull);
      expect(a.overflow, [AgreementAction.cancel]);
    });

    test('terminal statuses offer nothing', () {
      for (final s in ['completed', 'disputed', 'cancelled', 'refunded']) {
        expect(_resolve(status: s).hasBar, isFalse, reason: s);
      }
    });
  });

  group('nextStepFor', () {
    NextStepCopy copy({
      String status = 'active',
      bool isDepositor = true,
      bool isFunded = true,
      bool currentUserAccepted = false,
      bool hasConditions = true,
      bool hasLiveDispute = false,
      int met = 0,
      int total = 3,
    }) =>
        nextStepFor(
          status: status,
          isDepositor: isDepositor,
          isFunded: isFunded,
          currentUserAccepted: currentUserAccepted,
          hasConditions: hasConditions,
          hasLiveDispute: hasLiveDispute,
          otherPartyName: 'Ada',
          conditionsMet: met,
          conditionsTotal: total,
        );

    test('tells the user when it is their turn to agree', () {
      final c = copy(status: 'pending', isFunded: false);
      expect(c.tone, BannerTone.warning);
      expect(c.title, contains('Your turn'));
    });

    test('names the other party while waiting', () {
      final c = copy(status: 'pending', isFunded: false, currentUserAccepted: true);
      expect(c.title, contains('Ada'));
    });

    test('unfunded active differs by role', () {
      expect(copy(isFunded: false).title, contains('Fund escrow'));
      expect(copy(isFunded: false, isDepositor: false).title, contains('Ada'));
    });

    test('funded active counts remaining conditions', () {
      expect(copy(met: 1, total: 3).message, contains('2 of 3'));
    });
  });
}
