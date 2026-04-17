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
    return await _getUsersConditions();
  }

  List<ConditionResponse> getAgreementConditions(String agreementId) {
    final allConditions = state.value?.conditions ?? [];
    return allConditions
        .where((condition) => condition.agreementId == agreementId)
        .toList();
  }

  Future<ConditionState> _getUsersConditions() async {
    const initialState = ConditionState();

    try {
      final dataState = await ref
          .read(conditionRepositoryProvider)
          .getUsersConditions();

      if (dataState is DataSuccess && dataState.data != null) {
        return initialState.copyWith(conditions: dataState.data!);
      }

      return initialState;
    } catch (e) {
      log('Error fetching conditions: $e');
      return initialState;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final currentState = state.value ?? const ConditionState();
      final dataState = await ref
          .read(conditionRepositoryProvider)
          .getUsersConditions();

      if (dataState is DataSuccess && dataState.data != null) {
        return currentState.copyWith(conditions: dataState.data!);
      }

      return currentState;
    });
  }

  void addNewCondition(ConditionResponse condition) {
    final currentState = state.value ?? const ConditionState();
    state = AsyncData(
      currentState.copyWith(
        conditions: [condition, ...currentState.conditions],
      ),
    );
  }

  Future<void> addConditionToAgreement(AddConditionParams params) async {
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
        addNewCondition(dataState.data!);
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
        final updated = latestState.conditions.map((c) {
          return c.id == conditionId ? dataState.data! : c;
        }).toList();

        state = AsyncData(
          latestState.copyWith(
            isApproving: false,
            conditions: updated,
            selectedCondition: dataState.data!,
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
        final updated = latestState.conditions.map((c) {
          return c.id == params.conditionId ? dataState.data! : c;
        }).toList();

        state = AsyncData(
          latestState.copyWith(
            isRejecting: false,
            conditions: updated,
            selectedCondition: dataState.data!,
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
}
