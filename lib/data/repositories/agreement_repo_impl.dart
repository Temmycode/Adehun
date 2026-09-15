import 'dart:developer';
import 'dart:io';

import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/data/services/agreement_api_service.dart';
import 'package:adehun_mvp/domain/agreement_repository.dart';
import 'package:adehun_mvp/domain/models/agreement_create_response.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/domain/models/agreement_invitation_response.dart';
import 'package:adehun_mvp/domain/models/escrow_movement_response.dart';
import 'package:adehun_mvp/domain/models/invitation_response.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class AgreementRepoImpl implements AgreementRepository {
  final AgreementApiService _agreementApiService;
  const AgreementRepoImpl(AgreementApiService apiService)
    : _agreementApiService = apiService;

  @override
  Future<DataState<List<AgreementResponse>>> getAllUserAgreements() async {
    try {
      final apiResponse = await _agreementApiService.getAllUserAgreements();

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(GetAgreementsError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<AgreementCreateResponse>> createAgreement({
    required String otherParticipantEmailOrPhone,
    required String role,
    required String title,
    required String description,
    required String amount,
    required List<Map<String, dynamic>> conditions,
  }) async {
    try {
      final apiResponse = await _agreementApiService.createAgreement({
        "other_participant_email_or_phone": otherParticipantEmailOrPhone,
        "role": role,
        "title": title,
        "description": description,
        "amount": amount,
        "conditions": conditions,
      });

      if (apiResponse.response.statusCode == HttpStatus.created) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(CreateAgreementError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<AgreementResponse>> acceptAgreement(
    String agreementId,
  ) async {
    try {
      final apiResponse = await _agreementApiService.acceptAgreement(
        agreementId,
      );

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(AcceptAgreementError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<EscrowMovementResponse>> fundAgreement(
    String agreementId,
  ) async {
    try {
      // Generated here rather than passed in — the caller has no business
      // knowing about it, matching WalletRepoImpl.fundWallet.
      final String idempotencyKey = Uuid().v4();
      final apiResponse = await _agreementApiService.fundAgreement(
        agreementId,
        idempotencyKey,
      );

      if (apiResponse.response.statusCode == HttpStatus.ok ||
          apiResponse.response.statusCode == HttpStatus.created) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(FundAgreementError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      // Load-bearing: this is how a 400/403/409 reaches the controller with the
      // envelope's ApiError attached, so the server's own wording can surface.
      rethrow;
    }
  }

  @override
  Future<DataState<AgreementResponse>> cancelAgreement(
    String agreementId,
  ) async {
    try {
      final apiResponse = await _agreementApiService.cancelAgreement(
        agreementId,
      );

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(CancelAgreementError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<AgreementResponse>> rejectAgreement(
    String agreementId,
  ) async {
    try {
      final apiResponse = await _agreementApiService.rejectAgreement(
        agreementId,
      );

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(AcceptAgreementError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<AgreementResponse>> getAgreement(String agreementId) async {
    try {
      final apiResponse = await _agreementApiService.getAgreement(agreementId);

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(GetAgreementError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<AgreementInvitationResponse>> getAgreementInvitation(
    String agreementId,
  ) async {
    try {
      final apiResponse = await _agreementApiService.getAgreementInvitation(
        agreementId,
      );

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(GetAgreementInvitationError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<List<InvitationResponse>>> getInvitedAgreements() async {
    try {
      final apiResponse = await _agreementApiService.getInvitedAgreement();

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(GetAgreementInvitationError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }
}
