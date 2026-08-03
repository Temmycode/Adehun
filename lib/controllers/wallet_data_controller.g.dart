// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_data_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WalletDataController)
final walletDataControllerProvider = WalletDataControllerProvider._();

final class WalletDataControllerProvider
    extends $StreamNotifierProvider<WalletDataController, WalletData> {
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
    r'0430d7b04fd071142336130a22e52296f7b92ce9';

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
