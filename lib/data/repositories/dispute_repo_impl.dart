import 'dart:developer';
import 'dart:io';

import 'package:adehun_mvp/constants/dispute_enums.dart';
import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/data/services/dispute_api_service.dart';
import 'package:adehun_mvp/domain/dispute_repository.dart';
import 'package:adehun_mvp/domain/models/dispute_response.dart';
import 'package:adehun_mvp/domain/models/upload_signature_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:flutter/foundation.dart';

class DisputeRepoImpl implements DisputeRepository {
  final DisputeApiService _disputeApiService;
  const DisputeRepoImpl(DisputeApiService apiService)
    : _disputeApiService = apiService;

  @override
  Future<DataState<UploadSignatureResponse>> getDisputeUploadSignature(
    String agreementId,
  ) async {
    try {
      final apiResponse = await _disputeApiService.getDisputeUploadSignature(
        agreementId,
      );

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(GetDisputeUploadSignatureError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<DisputeResponse>> raiseDispute({
    required String agreementId,
    required DisputeCategory category,
    required String description,
    required List<Map<String, dynamic>> files,
  }) async {
    try {
      final apiResponse = await _disputeApiService.raiseDispute(agreementId, {
        // `.wire`, not `.name` — the enum's Dart name is camelCase and the API
        // only accepts the snake_case value.
        "category": category.wire,
        "description": description,
        "files": files,
      });

      if (apiResponse.response.statusCode == HttpStatus.ok ||
          apiResponse.response.statusCode == HttpStatus.created) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(RaiseDisputeError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<List<DisputeResponse>>> getAgreementDisputes(
    String agreementId,
  ) async {
    try {
      final apiResponse = await _disputeApiService.getAgreementDisputes(
        agreementId,
      );

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(GetDisputesError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }
}
