import 'package:adehun_mvp/domain/models/agreement_create_response.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/domain/models/agreement_invitation_response.dart';
import 'package:adehun_mvp/domain/models/escrow_movement_response.dart';
import 'package:adehun_mvp/domain/models/invitation_response.dart';

abstract class AgreementRepository {
  Future<DataState<List<AgreementResponse>>> getAllUserAgreements();

  Future<DataState<AgreementCreateResponse>> createAgreement({
    required String otherParticipantEmailOrPhone,
    required String role,
    required String title,
    required String description,
    required int amount,
    required List<Map<String, dynamic>> conditions,
  });

  Future<DataState<AgreementResponse>> acceptAgreement(String agreementId);

  /// Moves the agreement amount from the depositor's wallet into escrow.
  ///
  /// The idempotency key is generated in the implementation — it's a transport
  /// detail, matching how [WalletRepository.fundWallet] handles it.
  Future<DataState<EscrowMovementResponse>> fundAgreement(String agreementId);

  /// Cancels an agreement. Only valid while it is pending or active AND the
  /// escrow is unfunded — a funded deal has to go through a dispute instead.
  Future<DataState<AgreementResponse>> cancelAgreement(String agreementId);

  Future<DataState<AgreementResponse>> rejectAgreement(String agreementId);

  Future<DataState<AgreementResponse>> getAgreement(String agreementId);

  Future<DataState<AgreementInvitationResponse>> getAgreementInvitation(
    String agreementId,
  );

  Future<DataState<List<InvitationResponse>>> getInvitedAgreements();
}
