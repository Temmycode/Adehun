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
    extends $AsyncNotifierProvider<ConditionController, ConditionState> {
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
}

String _$conditionControllerHash() =>
    r'28b35c70e029d516619a2af5129c773e9a631a90';

abstract class _$ConditionController extends $AsyncNotifier<ConditionState> {
  FutureOr<ConditionState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ConditionState>, ConditionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ConditionState>, ConditionState>,
              AsyncValue<ConditionState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
