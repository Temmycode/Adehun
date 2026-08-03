import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/domain/models/wallet_code_response.dart';
import 'package:adehun_mvp/domain/models/wallet_data.dart';

abstract class WalletRepository {
  Future<DataState<WalletCodeResponse>> fundWallet(
    double amount,
    String channel,
  );

  Stream<WalletData> get walletData;

  void closeWalletSocket();
}
