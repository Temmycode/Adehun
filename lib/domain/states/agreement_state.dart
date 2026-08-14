// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/models/agreement_invitation_response.dart';
import 'package:adehun_mvp/domain/models/invitation_response.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AgreementState {
  final List<AgreementResponse> agreements;
  final AgreementResponse? selectedAgreement;
  final List<InvitationResponse> agreementInvitations;
  final Map<String, AgreementInvitationResponse> invitations;
  final bool isAccepting;
  final bool isDeclining;
  final bool isCreating;
  final bool invitationLoading;
  final bool isGettingInvitations;

  const AgreementState({
    this.agreements = const [],
    this.selectedAgreement,
    this.agreementInvitations = const [],
    this.isAccepting = false,
    this.isDeclining = false,
    this.isCreating = false,
    this.invitations = const {},
    this.invitationLoading = false,
    this.isGettingInvitations = false,
  });

  AgreementState copyWith({
    List<AgreementResponse>? agreements,
    AgreementResponse? selectedAgreement,
    List<InvitationResponse>? agreementInvitations,
    Map<String, AgreementInvitationResponse>? invitations,
    bool? isAccepting,
    bool? isDeclining,
    bool? isCreating,
    bool? invitationLoading,
    bool? isGettingInvitations,
  }) {
    return AgreementState(
      agreements: agreements ?? this.agreements,
      invitations: invitations ?? this.invitations,
      agreementInvitations: agreementInvitations ?? this.agreementInvitations,
      selectedAgreement: selectedAgreement ?? this.selectedAgreement,
      isAccepting: isAccepting ?? this.isAccepting,
      isDeclining: isDeclining ?? this.isDeclining,
      isCreating: isCreating ?? this.isCreating,
      invitationLoading: invitationLoading ?? this.invitationLoading,
      isGettingInvitations: isGettingInvitations ?? this.isGettingInvitations,
    );
  }
}
