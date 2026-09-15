// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_data_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Live wallet balances.
///
/// Seeded over HTTP, updated by websocket frames, and refetched whenever the
/// app returns to the foreground (the socket has almost certainly dropped by
/// then and delivers nothing for the time it was down).

@ProviderFor(WalletDataController)
final walletDataControllerProvider = WalletDataControllerProvider._();

/// Live wallet balances.
///
/// Seeded over HTTP, updated by websocket frames, and refetched whenever the
/// app returns to the foreground (the socket has almost certainly dropped by
/// then and delivers nothing for the time it was down).
final class WalletDataControllerProvider
    extends $StreamNotifierProvider<WalletDataController, WalletData> {
  /// Live wallet balances.
  ///
  /// Seeded over HTTP, updated by websocket frames, and refetched whenever the
  /// app returns to the foreground (the socket has almost certainly dropped by
  /// then and delivers nothing for the time it was down).
  WalletDataControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletDataControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletDataControllerHash();

  @$internal
  @override
  WalletDataController create() => WalletDataController();
}

String _$walletDataControllerHash() =>
    r'24c0884d451f195bd92055396bb83239d79df81e';

/// Live wallet balances.
///
/// Seeded over HTTP, updated by websocket frames, and refetched whenever the
/// app returns to the foreground (the socket has almost certainly dropped by
/// then and delivers nothing for the time it was down).

abstract class _$WalletDataController extends $StreamNotifier<WalletData> {
  Stream<WalletData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<WalletData>, WalletData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WalletData>, WalletData>,
              AsyncValue<WalletData>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
