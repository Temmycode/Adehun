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
  FutureOr<ConditionState> build() async {
    return ConditionState();
  }

  Future<void> getAgreementConditions(String agreementId) async {
    final currentState = state.value ?? const ConditionState();
    final cache = ref.read(localDataCacheManagerProvider);
    final cachedConditions = cache.getCachedConditions(agreementId);

    if (cachedConditions != null) {
      final updatedConditions = Map<String, List<ConditionResponse>>.from(
        currentState.conditions,
      )..[agreementId] = cachedConditions;

      state = AsyncData(currentState.copyWith(conditions: updatedConditions));
    } else {
      state = const AsyncLoading();
    }

    try {
      final dataState = await ref
          .read(conditionRepositoryProvider)
          .getAgreementConditions(agreementId);

      if (dataState is DataSuccess && dataState.data != null) {
        await cache.cacheConditions(agreementId, dataState.data!);

        final updatedConditions = Map<String, List<ConditionResponse>>.from(
          currentState.conditions,
        )..[agreementId] = dataState.data!;

        state = AsyncData(currentState.copyWith(conditions: updatedConditions));
      } else if (cachedConditions == null) {
        state = AsyncData(currentState);
      }
    } catch (err, stk) {
      log('Failed to load conditions: $err');
      if (cachedConditions == null) {
        state = AsyncValue.error(err, stk);
      }
    }
  }

  Future<void> refresh(String agreementId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final currentState = state.value ?? const ConditionState();
      final dataState = await ref
          .read(conditionRepositoryProvider)
          .getAgreementConditions(agreementId);

      if (dataState is DataSuccess && dataState.data != null) {
        return currentState.copyWith(
          conditions: {agreementId: dataState.data!},
        );
      }

      return currentState;
    });
  }

  void addNewCondition(String agreementId, ConditionResponse condition) {
    final currentState = state.value ?? const ConditionState();
    final currentConditions =
        state.value?.conditions ?? <String, List<ConditionResponse>>{};

    state = AsyncData(
      currentState.copyWith(
        conditions: Map<String, List<ConditionResponse>>.from(
          currentConditions,
        )..[agreementId] = [...currentConditions[agreementId] ?? [], condition],
      ),
    );
  }

  Future<void> addConditionToAgreement(
    String agreementId,
    AddConditionParams params,
  ) async {
    final currentState = state.value ?? const ConditionState();
    state = AsyncData(currentState.copyWith(isAdding: true));

    try {
      final dataState = await ref
          .read(conditionRepositoryProvider)
          .addConditionToAgreement(
            agreementId: params.agreementId,
            title: params.title,
            description: params.description,
            requiredFromEmail: params.requiredFromEmail,
          );

      final latestState = state.value ?? currentState;

      if (dataState is DataSuccess && dataState.data != null) {
        addNewCondition(agreementId, dataState.data!);
      } else {
        state = AsyncData(latestState.copyWith(isAdding: false));
      }
    } catch (e) {
      log('Error adding condition: $e');
      state = AsyncData(
        (state.value ?? currentState).copyWith(isAdding: false),
      );
    }
  }

  Future<void> getConditionDetails(String conditionId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final currentState = state.value ?? const ConditionState();
      final dataState = await ref
          .read(conditionRepositoryProvider)
          .getConditionDetails(conditionId);

      if (dataState is DataSuccess && dataState.data != null) {
        return currentState.copyWith(selectedCondition: dataState.data!);
      }

      return currentState;
    });
  }

  Future<void> approveCondition(String conditionId) async {
    final currentState = state.value ?? const ConditionState();
    state = AsyncData(currentState.copyWith(isApproving: true));

    try {
      final dataState = await ref
          .read(conditionRepositoryProvider)
          .approveCondition(conditionId);

      final latestState = state.value ?? currentState;

      if (dataState is DataSuccess && dataState.data != null) {
        final approvedCondition = dataState.data!;

        state = AsyncData(
          latestState.copyWith(
            isApproving: false,
            conditions: _replaceCondition(
              latestState.conditions,
              approvedCondition,
            ),
            selectedCondition: approvedCondition,
          ),
        );
      } else {
        state = AsyncData(latestState.copyWith(isApproving: false));
      }
    } catch (e) {
      log('Error approving condition: $e');
      state = AsyncData(
        (state.value ?? currentState).copyWith(isApproving: false),
      );
    }
  }

  Future<void> rejectCondition(RejectConditionParams params) async {
    final currentState = state.value ?? const ConditionState();
    state = AsyncData(currentState.copyWith(isRejecting: true));

    try {
      final dataState = await ref
          .read(conditionRepositoryProvider)
          .rejectCondition(
            conditionId: params.conditionId,
            rejectedReason: params.rejectedReason,
          );

      final latestState = state.value ?? currentState;

      if (dataState is DataSuccess && dataState.data != null) {
        final rejectedCondition = dataState.data!;

        state = AsyncData(
          latestState.copyWith(
            isRejecting: false,
            conditions: _replaceCondition(
              latestState.conditions,
              rejectedCondition,
            ),
            selectedCondition: rejectedCondition,
          ),
        );
      } else {
        state = AsyncData(latestState.copyWith(isRejecting: false));
      }
    } catch (e) {
      log('Error rejecting condition: $e');
      state = AsyncData(
        (state.value ?? currentState).copyWith(isRejecting: false),
      );
    }
  }

  Map<String, List<ConditionResponse>> _replaceCondition(
    Map<String, List<ConditionResponse>> conditions,
    ConditionResponse updated,
  ) {
    final updatedConditions = Map<String, List<ConditionResponse>>.from(
      conditions,
    );
    final agreementId = updated.agreementId!;
    final agreementConditions =
        updatedConditions[agreementId] ?? const <ConditionResponse>[];

    updatedConditions[agreementId] = agreementConditions
        .map((c) => c.id == updated.id ? updated : c)
        .toList();

    return updatedConditions;
  }
}
