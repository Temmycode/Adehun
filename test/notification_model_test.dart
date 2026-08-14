import 'package:adehun_mvp/domain/models/notification_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('agreement acceptance metadata is stored as ACTIVE', () {
    final notification = NotificationModel(
      id: 'n1',
      type: 'agreement_accepted',
      title: 'Agreement accepted',
      message: 'The agreement was accepted.',
      isRead: false,
      createdAt: DateTime.now(),
      metadata: {'agreement_id': 'agreement-1'},
    ).markAgreementDecisionStatus(accepted: true);

    expect(notification.agreementDecisionStatus, 'ACTIVE');
    expect(notification.isAgreementAccepted, isTrue);
    expect(notification.isAgreementDeclined, isFalse);
  });

  test('agreement decline metadata is stored as CANCELLED', () {
    final notification = NotificationModel(
      id: 'n2',
      type: 'agreement_declined',
      title: 'Agreement declined',
      message: 'The agreement was declined.',
      isRead: false,
      createdAt: DateTime.now(),
      metadata: {'agreement_id': 'agreement-2'},
    ).markAgreementDecisionStatus(accepted: false);

    expect(notification.agreementDecisionStatus, 'CANCELLED');
    expect(notification.isAgreementAccepted, isFalse);
    expect(notification.isAgreementDeclined, isTrue);
  });
}
