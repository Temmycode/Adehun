import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/domain/models/wallet_code_response.dart';
import 'package:adehun_mvp/domain/models/wallet_data.dart';
import 'package:adehun_mvp/domain/models/withdrawal_response.dart';

abstract class WalletRepository {
  Future<DataState<WalletCodeResponse>> fundWallet(
    double amount,
    String channel,
  );

  /// Current balances over HTTP.
  Future<DataState<WalletData>> getWallet();

  /// Live balances: seeded from [getWallet], then updated by websocket frames.
  /// Re-seeds from HTTP on every reconnect.
  Stream<WalletData> get walletData;

  /// `WITHDRAWAL_COMPLETED` / `WITHDRAWAL_FAILED` frames, keyed by reference.
  Stream<Map<String, dynamic>> get withdrawalEvents;

  /// Forces an HTTP refetch and pushes the result into [walletData].
  Future<void> refresh();

  /// [amount] is a 2dp decimal string; [bankAccountId] null means the default.
  Future<DataState<WithdrawalResponse>> withdraw({
    required String amount,
    String? bankAccountId,
  });

  Future<DataState<WithdrawalResponse>> getWithdrawal(String reference);

  void closeWalletSocket();
}
