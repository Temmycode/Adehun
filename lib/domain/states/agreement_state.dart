// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/models/invitation_response.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AgreementState {
  final List<AgreementResponse> agreements;
  final AgreementResponse? selectedAgreement;
  final Map<String, InvitationResponse> invitations;
  final bool isAccepting;
  final bool isCreating;
  final bool invitationLoading;

  const AgreementState({
    this.agreements = const [],
    this.selectedAgreement,
    this.isAccepting = false,
    this.isCreating = false,
    this.invitations = const {},
    this.invitationLoading = false,
  });

  AgreementState copyWith({
    List<AgreementResponse>? agreements,
    AgreementResponse? selectedAgreement,
    Map<String, InvitationResponse>? invitations,
    bool? isAccepting,
    bool? isCreating,
    bool? invitationLoading,
  }) {
    return AgreementState(
      agreements: agreements ?? this.agreements,
      invitations: invitations ?? this.invitations,
      selectedAgreement: selectedAgreement ?? this.selectedAgreement,
      isAccepting: isAccepting ?? this.isAccepting,
      isCreating: isCreating ?? this.isCreating,
      invitationLoading: invitationLoading ?? this.invitationLoading,
    );
  }
}
