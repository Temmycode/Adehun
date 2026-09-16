// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AgreementController)
final agreementControllerProvider = AgreementControllerProvider._();

final class AgreementControllerProvider
    extends $AsyncNotifierProvider<AgreementController, AgreementState> {
  AgreementControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'agreementControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$agreementControllerHash();

  @$internal
  @override
  AgreementController create() => AgreementController();
}

String _$agreementControllerHash() =>
    r'4b914171187e22daf8d795bd5b70c85071f31999';

abstract class _$AgreementController extends $AsyncNotifier<AgreementState> {
  FutureOr<AgreementState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AgreementState>, AgreementState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AgreementState>, AgreementState>,
              AsyncValue<AgreementState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
