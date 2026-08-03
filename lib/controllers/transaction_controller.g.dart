// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransactionsListController)
final transactionsListControllerProvider =
    TransactionsListControllerProvider._();

final class TransactionsListControllerProvider
    extends $NotifierProvider<TransactionsListController, TransactionState> {
  TransactionsListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionsListControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionsListControllerHash();

  @$internal
  @override
  TransactionsListController create() => TransactionsListController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionState>(value),
    );
  }
}

String _$transactionsListControllerHash() =>
    r'26577001f5301ec4a0d49ffcb4bfe736d5bcf61b';

abstract class _$TransactionsListController
    extends $Notifier<TransactionState> {
  TransactionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TransactionState, TransactionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TransactionState, TransactionState>,
              TransactionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
