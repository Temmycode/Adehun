// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BankAccountController)
final bankAccountControllerProvider = BankAccountControllerProvider._();

final class BankAccountControllerProvider
    extends $NotifierProvider<BankAccountController, BankAccountState> {
  BankAccountControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bankAccountControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bankAccountControllerHash();

  @$internal
  @override
  BankAccountController create() => BankAccountController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BankAccountState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BankAccountState>(value),
    );
  }
}

String _$bankAccountControllerHash() =>
    r'e0f7970bf5aa70b8648503c8abf29ab8761f1f5e';

abstract class _$BankAccountController extends $Notifier<BankAccountState> {
  BankAccountState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BankAccountState, BankAccountState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BankAccountState, BankAccountState>,
              BankAccountState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
