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
    r'cd1cd966fe9f3eb2e4e68fbcaf6212e255b0a295';

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
