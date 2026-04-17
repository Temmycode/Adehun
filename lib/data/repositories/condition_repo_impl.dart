import 'dart:developer';
import 'dart:io';

import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/data/services/condition_api_service.dart';
import 'package:adehun_mvp/domain/condition_repository.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:flutter/foundation.dart';

class ConditionRepoImpl implements ConditionRepository {
  final ConditionApiService _conditionApiService;
  const ConditionRepoImpl(ConditionApiService apiService)
      : _conditionApiService = apiService;

  @override
  Future<DataState<ConditionResponse>> addConditionToAgreement({
    required String agreementId,
    required String title,
    required String description,
    required String requiredFromEmail,
  }) async {
    try {
      final apiResponse =
          await _conditionApiService.addConditionToAgreement(agreementId, {
        "title": title,
        "description": description,
        "required_from_email": requiredFromEmail,
      });

      if (apiResponse.response.statusCode == HttpStatus.created) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(AddConditionError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<List<ConditionResponse>>> getUsersConditions() async {
    try {
      final apiResponse = await _conditionApiService.getUsersConditions();

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(GetConditionsError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<ConditionResponse>> getConditionDetails(
    String conditionId,
  ) async {
    try {
      final apiResponse =
          await _conditionApiService.getConditionDetails(conditionId);

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(GetConditionDetailsError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<ConditionResponse>> approveCondition(
    String conditionId,
  ) async {
    try {
      final apiResponse =
          await _conditionApiService.approveCondition(conditionId);

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(ApproveConditionError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<ConditionResponse>> rejectCondition({
    required String conditionId,
    required String rejectedReason,
  }) async {
    try {
      final apiResponse =
          await _conditionApiService.rejectCondition(conditionId, {
        "rejected_reason": rejectedReason,
      });

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(RejectConditionError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }
}
