import 'dart:developer';

import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/domain/states/condition_state.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/usecases/params/add_condition_params.dart';
import 'package:adehun_mvp/usecases/params/reject_condition_params.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'condition_controller.g.dart';

@Riverpod(keepAlive: true)
class ConditionController extends _$ConditionController {
  @override
  ConditionState build() => const ConditionState();

  Future<void> getAgreementConditions(String agreementId) async {
    final cache = ref.read(localDataCacheManagerProvider);
    final cachedConditions = cache.getCachedConditions(agreementId);

    // Show cached conditions immediately; only spin when there is nothing yet.
    state = state.copyWith(
      conditions: cachedConditions != null
          ? _withConditions(agreementId, cachedConditions)
          : null,
      isLoading: cachedConditions == null,
      errorMessage: () => null,
    );

    try {
      final dataState = await ref
          .read(conditionRepositoryProvider)
          .getAgreementConditions(agreementId);

      if (dataState is DataSuccess && dataState.data != null) {
        await cache.cacheConditions(agreementId, dataState.data!);

        state = state.copyWith(
          conditions: _withConditions(agreementId, dataState.data!),
          isLoading: false,
        );
      } else {
        _finishLoad(
          hasFallback: cachedConditions != null,
          message: _errorText(dataState, 'Failed to load conditions'),
        );
      }
    } catch (err) {
      log('Failed to load conditions: $err');
      _finishLoad(
        hasFallback: cachedConditions != null,
        message: 'Failed to load conditions',
      );
    }
  }

  Future<void> refresh(String agreementId) async {
    state = state.copyWith(
      isLoading: state.conditionsFor(agreementId).isEmpty,
      errorMessage: () => null,
    );

    try {
      final dataState = await ref
          .read(conditionRepositoryProvider)
          .getAgreementConditions(agreementId);

      if (dataState is DataSuccess && dataState.data != null) {
        await ref
            .read(localDataCacheManagerProvider)
            .cacheConditions(agreementId, dataState.data!);

        state = state.copyWith(
          conditions: _withConditions(agreementId, dataState.data!),
          isLoading: false,
        );
      } else {
        _finishLoad(
          hasFallback: state.conditionsFor(agreementId).isNotEmpty,
          message: _errorText(dataState, 'Failed to refresh conditions'),
        );
      }
    } catch (err) {
      log('Failed to refresh conditions: $err');
      _finishLoad(
        hasFallback: state.conditionsFor(agreementId).isNotEmpty,
        message: 'Failed to refresh conditions',
      );
    }
  }

  void addNewCondition(String agreementId, ConditionResponse condition) {
    state = state.copyWith(
      conditions: _withConditions(agreementId, [
        ...state.conditionsFor(agreementId),
        condition,
      ]),
    );
  }

  Future<void> addConditionToAgreement(
    String agreementId,
    AddConditionParams params,
  ) async {
    if (state.isAdding) return;
    state = state.copyWith(isAdding: true, errorMessage: () => null);

    try {
      final dataState = await ref
          .read(conditionRepositoryProvider)
          .addConditionToAgreement(
            agreementId: params.agreementId,
            title: params.title,
            description: params.description,
            requiredFromEmail: params.requiredFromEmail,
          );

      if (dataState is DataSuccess && dataState.data != null) {
        addNewCondition(agreementId, dataState.data!);
        state = state.copyWith(isAdding: false);
      } else {
        state = state.copyWith(
          isAdding: false,
          errorMessage: () => _errorText(dataState, 'Failed to add condition'),
        );
      }
    } catch (err) {
      log('Error adding condition: $err');
      state = state.copyWith(
        isAdding: false,
        errorMessage: () => 'Failed to add condition',
      );
    }
  }

  Future<void> getConditionDetails(String conditionId) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    try {
      final dataState = await ref
          .read(conditionRepositoryProvider)
          .getConditionDetails(conditionId);

      if (dataState is DataSuccess && dataState.data != null) {
        state = state.copyWith(
          selectedCondition: () => dataState.data!,
          conditions: _replaceCondition(dataState.data!),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () =>
              _errorText(dataState, 'Failed to load condition details'),
        );
      }
    } catch (err) {
      log('Error loading condition details: $err');
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Failed to load condition details',
      );
    }
  }

  Future<void> approveCondition(String conditionId) async {
    if (state.isApproving) return;
    state = state.copyWith(isApproving: true, errorMessage: () => null);

    try {
      final dataState = await ref
          .read(conditionRepositoryProvider)
          .approveCondition(conditionId);

      if (dataState is DataSuccess && dataState.data != null) {
        final approved = dataState.data!;

        state = state.copyWith(
          isApproving: false,
          conditions: _replaceCondition(approved),
          selectedCondition: () => approved,
        );
      } else {
        state = state.copyWith(
          isApproving: false,
          errorMessage: () =>
              _errorText(dataState, 'Failed to approve condition'),
        );
      }
    } catch (err) {
      log('Error approving condition: $err');
      state = state.copyWith(
        isApproving: false,
        errorMessage: () => 'Failed to approve condition',
      );
    }
  }

  Future<void> rejectCondition(RejectConditionParams params) async {
    if (state.isRejecting) return;
    state = state.copyWith(isRejecting: true, errorMessage: () => null);

    try {
      final dataState = await ref
          .read(conditionRepositoryProvider)
          .rejectCondition(
            conditionId: params.conditionId,
            rejectedReason: params.rejectedReason,
          );

      if (dataState is DataSuccess && dataState.data != null) {
        final rejected = dataState.data!;

        state = state.copyWith(
          isRejecting: false,
          conditions: _replaceCondition(rejected),
          selectedCondition: () => rejected,
        );
      } else {
        state = state.copyWith(
          isRejecting: false,
          errorMessage: () =>
              _errorText(dataState, 'Failed to reject condition'),
        );
      }
    } catch (err) {
      log('Error rejecting condition: $err');
      state = state.copyWith(
        isRejecting: false,
        errorMessage: () => 'Failed to reject condition',
      );
    }
  }

  void clearError() => state = state.copyWith(errorMessage: () => null);

  /// Current map with [agreementId] swapped for [conditions]. Other agreements
  /// keep whatever is already loaded.
  Map<String, List<ConditionResponse>> _withConditions(
    String agreementId,
    List<ConditionResponse> conditions,
  ) {
    return {...state.conditions, agreementId: conditions};
  }

  /// Swaps [updated] into whichever agreement's list already holds it. Matching
  /// by id rather than trusting `updated.agreementId`, which the API may omit.
  Map<String, List<ConditionResponse>> _replaceCondition(
    ConditionResponse updated,
  ) {
    return {
      for (final entry in state.conditions.entries)
        entry.key: entry.value
            .map((c) => c.id == updated.id ? updated : c)
            .toList(),
    };
  }

  void _finishLoad({required bool hasFallback, required String message}) {
    state = state.copyWith(
      isLoading: false,
      errorMessage: hasFallback ? null : () => message,
    );
  }

  String _errorText(DataState dataState, String fallback) =>
      dataState.exception?.toString() ?? fallback;
}
