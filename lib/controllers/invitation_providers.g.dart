// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(invitedAgreements)
final invitedAgreementsProvider = InvitedAgreementsProvider._();

final class InvitedAgreementsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InvitationResponse>>,
          List<InvitationResponse>,
          FutureOr<List<InvitationResponse>>
        >
    with
        $FutureModifier<List<InvitationResponse>>,
        $FutureProvider<List<InvitationResponse>> {
  InvitedAgreementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invitedAgreementsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invitedAgreementsHash();

  @$internal
  @override
  $FutureProviderElement<List<InvitationResponse>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<InvitationResponse>> create(Ref ref) {
    return invitedAgreements(ref);
  }
}

String _$invitedAgreementsHash() => r'b0c414c1012216755bda9fbd35f54149e6d34a45';
