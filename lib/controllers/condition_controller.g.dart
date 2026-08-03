// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ConditionController)
final conditionControllerProvider = ConditionControllerProvider._();

final class ConditionControllerProvider
    extends $NotifierProvider<ConditionController, ConditionState> {
  ConditionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conditionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conditionControllerHash();

  @$internal
  @override
  ConditionController create() => ConditionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConditionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConditionState>(value),
    );
  }
}

String _$conditionControllerHash() =>
    r'1955d7962f1c7f782783e783612eb40877eaed18';

abstract class _$ConditionController extends $Notifier<ConditionState> {
  ConditionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ConditionState, ConditionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConditionState, ConditionState>,
              ConditionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
