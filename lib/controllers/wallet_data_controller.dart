import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/models/wallet_data.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_data_controller.g.dart';

/// Live wallet balances.
///
/// Seeded over HTTP, updated by websocket frames, and refetched whenever the
/// app returns to the foreground (the socket has almost certainly dropped by
/// then and delivers nothing for the time it was down).
@Riverpod(keepAlive: true)
class WalletDataController extends _$WalletDataController {
  AppLifecycleListener? _lifecycle;

  @override
  Stream<WalletData> build() {
    final repository = ref.watch(walletRepositoryProvider);

    _lifecycle = AppLifecycleListener(onResume: () => repository.refresh());
    ref.onDispose(() {
      _lifecycle?.dispose();
      repository.closeWalletSocket();
    });

    return repository.walletData;
  }

  Future<void> refresh() => ref.read(walletRepositoryProvider).refresh();
}
