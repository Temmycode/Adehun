import 'package:adehun_mvp/domain/models/agreement_create_response.dart';
import 'package:adehun_mvp/domain/models/bank.dart';
import 'package:adehun_mvp/domain/models/invite_lookup.dart';
import 'package:adehun_mvp/domain/models/transaction.dart';
import 'package:adehun_mvp/domain/models/transaction_list_response.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:adehun_mvp/domain/models/wallet_code_response.dart';
import 'package:adehun_mvp/domain/models/withdrawal_response.dart';
import 'package:adehun_mvp/usecases/params/create_agreement_params.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _transaction({String type = 'deposit', String status = 'completed'}) => {
  'id': 't1',
  'reference': 'dep_x',
  'type': type,
  'direction': 'credit',
  'status': status,
  'amount': '100.00',
  'currency': 'NGN',
  'balance_after': '100.00',
  'escrow_after': '0.00',
  'description': null,
  'agreement_id': null,
  'condition_id': null,
  'counterparty_user_id': null,
  'created_at': '2026-09-15T10:00:00Z',
  'processed_at': null,
};

void main() {
  test('unknown ledger enums degrade instead of throwing', () {
    final tx = Transaction.fromJson(_transaction(type: 'brand_new', status: 'odd'));
    expect(tx.type, TransactionType.unknown);
    expect(tx.status, TransactionStatus.unknown);
    expect(Transaction.fromJson(_transaction()).type, TransactionType.deposit);
  });

  test('transaction list tolerates a missing summary', () {
    final list = TransactionListResponse.fromJson({
      'transactions': [_transaction()],
      'total': 1,
      'skip': 0,
      'limit': 20,
    });
    expect(list.summary, isNull);
    expect(list.transactions.single.id, 't1');
  });

  test('user data carries is_admin with a safe default', () {
    expect(UserData.fromJson({'id': 'u', 'name': 'n', 'email': 'e'}).isAdmin, isFalse);
    expect(
      UserData.fromJson({'id': 'u', 'name': 'n', 'email': 'e', 'is_admin': true}).isAdmin,
      isTrue,
    );
  });

  test('agreement create response keeps derived fields', () {
    final created = AgreementCreateResponse.fromJson({
      'id': 'a1',
      'title': 't',
      'description': 'd',
      'amount': '10.00',
      'status': 'pending',
      'created_at': '2026-09-15T10:00:00Z',
      'conditions': [],
      'condition_count': 2,
      'conditions_met_count': 1,
      'current_user_accepted': true,
      'is_funded': true,
    });
    final agreement = created.toAgreementResponse();
    expect(agreement.isFunded, isTrue);
    expect(agreement.currentUserAccepted, isTrue);
    expect(agreement.conditionsMetCount, 1);
  });

  test('fund init response exposes the server reference', () {
    final fund = WalletCodeResponse.fromJson({
      'access_code': 'ac',
      'reference': 'ESC-1',
      'amount': '2500.00',
    });
    expect(fund.reference, 'ESC-1');
    expect(WalletCodeResponse.fromJson({'access_code': 'ac'}).reference, '');
  });

  test('withdrawal response status helpers', () {
    final wd = WithdrawalResponse.fromJson({
      'reference': 'WD-1',
      'amount': '400.00',
      'currency': 'NGN',
      'status': 'pending',
      'available_balance': '600.00',
    });
    expect(wd.isPending, isTrue);
    expect(wd.isFailed, isFalse);
    expect(
      WithdrawalResponse.fromJson({'reference': 'r', 'amount': '1', 'status': 'refunded'}).isFailed,
      isTrue,
    );
  });

  test('bank account masks the number', () {
    final account = BankAccount.fromJson({
      'id': 'b1',
      'account_number': '0123456789',
      'account_name': 'ADA LOVELACE',
      'bank_code': '001',
      'bank_name': 'Test Bank',
      'currency': 'NGN',
      'is_default': true,
      'created_at': '2026-09-15T10:00:00Z',
    });
    expect(account.maskedNumber, '****6789');
    expect(account.isDefault, isTrue);
    expect(Bank.fromJson({'name': 'X', 'code': '1'}).currency, isNull);
  });

  test('invite lookup applies defaults', () {
    final lookup = InviteLookup.fromJson({'agreement_id': 'a1'});
    expect(lookup.inviterName, 'Someone');
    expect(lookup.status, 'pending');
  });

  test('agreement amounts are formatted to two decimals', () {
    expect(CreateAgreementParams.formatAmount(1500.5), '1500.50');
    expect(CreateAgreementParams.formatAmount(10), '10.00');
  });
}
