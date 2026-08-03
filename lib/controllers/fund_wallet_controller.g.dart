// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund_wallet_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Deliberately `keepAlive` — a payment in flight must not be disposed
/// mid-checkout. Callers that only `ref.read` this (rather than watching it)
/// register no listener, so under autoDispose the provider died on the first
/// await and the Paystack sheet never opened.

@ProviderFor(FundWalletController)
final fundWalletControllerProvider = FundWalletControllerProvider._();

/// Deliberately `keepAlive` — a payment in flight must not be disposed
/// mid-checkout. Callers that only `ref.read` this (rather than watching it)
/// register no listener, so under autoDispose the provider died on the first
/// await and the Paystack sheet never opened.
final class FundWalletControllerProvider
    extends $NotifierProvider<FundWalletController, FundWalletState> {
  /// Deliberately `keepAlive` — a payment in flight must not be disposed
  /// mid-checkout. Callers that only `ref.read` this (rather than watching it)
  /// register no listener, so under autoDispose the provider died on the first
  /// await and the Paystack sheet never opened.
  FundWalletControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fundWalletControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fundWalletControllerHash();

  @$internal
  @override
  FundWalletController create() => FundWalletController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FundWalletState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FundWalletState>(value),
    );
  }
}

String _$fundWalletControllerHash() =>
    r'fc7bce3211ff3be7a25f47602fbd6edcb9d6fe55';

/// Deliberately `keepAlive` — a payment in flight must not be disposed
/// mid-checkout. Callers that only `ref.read` this (rather than watching it)
/// register no listener, so under autoDispose the provider died on the first
/// await and the Paystack sheet never opened.

abstract class _$FundWalletController extends $Notifier<FundWalletState> {
  FundWalletState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FundWalletState, FundWalletState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FundWalletState, FundWalletState>,
              FundWalletState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
