// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AgreementListController)
final agreementListControllerProvider = AgreementListControllerProvider._();

final class AgreementListControllerProvider
    extends $AsyncNotifierProvider<AgreementListController, AgreementState> {
  AgreementListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'agreementListControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$agreementListControllerHash();

  @$internal
  @override
  AgreementListController create() => AgreementListController();
}

String _$agreementListControllerHash() =>
    r'e054fe062ba6ed18d75a0a2ade6ca4f77932a07e';

abstract class _$AgreementListController
    extends $AsyncNotifier<AgreementState> {
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
