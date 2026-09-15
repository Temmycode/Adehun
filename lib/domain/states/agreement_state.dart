// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/models/agreement_invitation_response.dart';
import 'package:adehun_mvp/domain/models/invitation_response.dart';
import 'package:flutter/foundation.dart' show immutable;

/// Where a funding attempt has got to.
///
/// A single bool wouldn't do: the flow spans up to three separate waits, and
/// the settlement wait can run for tens of seconds. A user who isn't told what
/// they're waiting for will kill the app mid-payment.
enum EscrowFundingStage {
  idle,

  /// Paystack checkout is open, topping up a wallet shortfall.
  toppingUp,

  /// Waiting for the top-up to be credited server-side before moving to escrow.
  awaitingSettlement,

  /// The fund call itself is in flight.
  movingToEscrow,
}

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
  final bool isCancelling;
  final EscrowFundingStage fundingStage;

  /// Which agreement is being funded. The controller is `keepAlive`, so without
  /// this a global flag would spin the button on an unrelated agreement's
  /// screen once the user navigates away mid-fund.
  final String? fundingAgreementId;
  final String? fundError;

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
    this.isCancelling = false,
    this.fundingStage = EscrowFundingStage.idle,
    this.fundingAgreementId,
    this.fundError,
  });

  /// Whether [agreementId] specifically is mid-fund.
  bool isFundingAgreement(String agreementId) =>
      fundingAgreementId == agreementId &&
      fundingStage != EscrowFundingStage.idle;

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
    bool? isCancelling,
    EscrowFundingStage? fundingStage,
    // Function wrap allows passing explicit null
    String? Function()? fundingAgreementId,
    String? Function()? fundError,
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
      isCancelling: isCancelling ?? this.isCancelling,
      fundingStage: fundingStage ?? this.fundingStage,
      fundingAgreementId: fundingAgreementId != null
          ? fundingAgreementId()
          : this.fundingAgreementId,
      fundError: fundError != null ? fundError() : this.fundError,
    );
  }
}
