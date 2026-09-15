// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DisputeController)
final disputeControllerProvider = DisputeControllerProvider._();

final class DisputeControllerProvider
    extends $NotifierProvider<DisputeController, DisputeState> {
  DisputeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'disputeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$disputeControllerHash();

  @$internal
  @override
  DisputeController create() => DisputeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DisputeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DisputeState>(value),
    );
  }
}

String _$disputeControllerHash() => r'c7a643f2085ae24f04dd30fae96b0a9500bd3c2c';

abstract class _$DisputeController extends $Notifier<DisputeState> {
  DisputeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DisputeState, DisputeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DisputeState, DisputeState>,
              DisputeState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
