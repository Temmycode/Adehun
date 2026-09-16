// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives one withdrawal: submit, then wait for settlement.
///
/// Settlement arrives over the wallet socket (`WITHDRAWAL_COMPLETED` /
/// `WITHDRAWAL_FAILED`) and, as a fallback, by polling the status endpoint,
/// because a dropped socket must not leave the screen stuck on "pending".

@ProviderFor(WithdrawController)
final withdrawControllerProvider = WithdrawControllerProvider._();

/// Drives one withdrawal: submit, then wait for settlement.
///
/// Settlement arrives over the wallet socket (`WITHDRAWAL_COMPLETED` /
/// `WITHDRAWAL_FAILED`) and, as a fallback, by polling the status endpoint,
/// because a dropped socket must not leave the screen stuck on "pending".
final class WithdrawControllerProvider
    extends $NotifierProvider<WithdrawController, WithdrawState> {
  /// Drives one withdrawal: submit, then wait for settlement.
  ///
  /// Settlement arrives over the wallet socket (`WITHDRAWAL_COMPLETED` /
  /// `WITHDRAWAL_FAILED`) and, as a fallback, by polling the status endpoint,
  /// because a dropped socket must not leave the screen stuck on "pending".
  WithdrawControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'withdrawControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$withdrawControllerHash();

  @$internal
  @override
  WithdrawController create() => WithdrawController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WithdrawState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WithdrawState>(value),
    );
  }
}

String _$withdrawControllerHash() =>
    r'e49057a72acd442f5b06fecabcc0015306339859';

/// Drives one withdrawal: submit, then wait for settlement.
///
/// Settlement arrives over the wallet socket (`WITHDRAWAL_COMPLETED` /
/// `WITHDRAWAL_FAILED`) and, as a fallback, by polling the status endpoint,
/// because a dropped socket must not leave the screen stuck on "pending".

abstract class _$WithdrawController extends $Notifier<WithdrawState> {
  WithdrawState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<WithdrawState, WithdrawState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WithdrawState, WithdrawState>,
              WithdrawState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
