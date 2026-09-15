import 'package:adehun_mvp/domain/models/wallet_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses REST decimal strings and websocket floats alike', () {
    final rest = WalletData.fromJson({
      'available_balance': '12500.50',
      'escrow_balance': '400000.00',
      'total_balance': '412500.50',
      'currency': 'NGN',
    });
    expect(rest.type, 'WALLET_STATE');
    expect(rest.availableBalance, 12500.5);
    expect(rest.totalBalance, 412500.5);

    final ws = WalletData.fromJson({
      'type': 'WALLET_CREDITED',
      'amount': 5000.0,
      'available_balance': 17500.5,
      'escrow_balance': 400000.0,
      'total_balance': 417500.5,
    });
    expect(ws.type, 'WALLET_CREDITED');
    expect(ws.availableBalance, 17500.5);
    expect(ws.currency, 'NGN');
  });

  test('merge keeps balances a partial frame omits', () {
    const base = WalletData(
      type: 'WALLET_STATE',
      availableBalance: 1000,
      escrowBalance: 250,
      totalBalance: 1250,
      currency: 'NGN',
    );

    final afterWithdrawal = base.merge({
      'type': 'WITHDRAWAL_COMPLETED',
      'reference': 'WD-1',
      'amount': 400.0,
      'available_balance': 600.0,
    });
    expect(afterWithdrawal.availableBalance, 600);
    expect(afterWithdrawal.escrowBalance, 250, reason: 'never zeroed');
    expect(afterWithdrawal.totalBalance, 850);
    expect(afterWithdrawal.type, 'WITHDRAWAL_COMPLETED');

    final nullBalances = base.merge({
      'type': 'WITHDRAWAL_FAILED',
      'available_balance': null,
      'escrow_balance': null,
      'total_balance': null,
    });
    expect(nullBalances.availableBalance, 1000);
    expect(nullBalances.escrowBalance, 250);
    expect(nullBalances.totalBalance, 1250);
  });
}
