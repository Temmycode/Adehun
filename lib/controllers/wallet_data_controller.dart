import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/models/wallet_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_data_controller.g.dart';

@Riverpod(keepAlive: true)
class WalletDataController extends _$WalletDataController {
  @override
  Stream<WalletData> build() {
    final repository = ref.watch(walletRepositoryProvider);

    ref.onDispose(repository.closeWalletSocket);

    return repository.walletData;
  }
}
