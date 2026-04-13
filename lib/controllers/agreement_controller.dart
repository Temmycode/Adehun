import 'dart:developer';

import 'package:adehun_mvp/controllers/condition_controller.dart';
import 'package:adehun_mvp/domain/models/agreement_create_response.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/states/agreement_state.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/resources/service_locator.dart';
import 'package:adehun_mvp/router/app_router.dart';
import 'package:adehun_mvp/usecases/params/create_agreement_params.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'agreement_controller.g.dart';

@Riverpod(keepAlive: true)
class AgreementController extends _$AgreementController {
  @override
  FutureOr<AgreementState> build() async {
    return await _getAllAgreements();
  }

  Future<AgreementState> _getAllAgreements() async {
    const initialState = AgreementState();

    try {
      final dataState = await ref
          .read(agreementRepositoryProvider)
          .getAllUserAgreements();

      if (dataState is DataSuccess && dataState.data != null) {
        return initialState.copyWith(agreements: dataState.data!);
      }

      return initialState;
    } catch (e) {
      return initialState;
    }
  }

  Future<void> refresh() async {
    final currentState = state.value ?? const AgreementState();

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final dataState = await ref
          .read(agreementRepositoryProvider)
          .getAllUserAgreements();

      if (dataState is DataSuccess && dataState.data != null) {
        return currentState.copyWith(agreements: dataState.data!);
      }

      return state.value!;
    });
  }

  void addAgreementToList(AgreementResponse agreement) {
    final currentState = state.value ?? const AgreementState();
    state = AsyncData(
      currentState.copyWith(
        agreements: [agreement, ...currentState.agreements],
      ),
    );
  }

  void updateTempAgreement(AgreementCreateResponse agreement, String tempId) {
    final currentState = state.value ?? const AgreementState();
    final filtered = currentState.agreements.where((agt) => agt.id != tempId);
    state = AsyncData(
      currentState.copyWith(
        isCreating: false,
        agreements: [agreement.toAgreementResponse(), ...filtered],
      ),
    );
  }

  void rollback(String tempId) {
    final currentState = state.value ?? const AgreementState();
    final rolledBack = currentState.agreements
        .where((a) => a.id != tempId)
        .toList();

    state = AsyncData(
      currentState.copyWith(isCreating: false, agreements: rolledBack),
    );
  }

  Future<void> createAgreement(CreateAgreementParams params) async {
    final currentState = state.value ?? const AgreementState();
    state = AsyncData(currentState.copyWith(isCreating: true));

    final tempId = Uuid().v4();
    final newAgreement = AgreementResponse.fromCreateParams(params, tempId);

    addAgreementToList(newAgreement);

    try {
      final dataState = await ref
          .read(agreementRepositoryProvider)
          .createAgreement(
            otherParticipantEmailOrPhone: params.otherParticipantEmailOrPhone,
            role: params.role,
            title: params.title,
            description: params.description,
            amount: params.amount,
            conditions: params.conditions.map((c) => c.toJson()).toList(),
          );
      if (dataState is DataSuccess && dataState.data != null) {
        final created = dataState.data!;
        updateTempAgreement(created, tempId);
        final conditionController =
            ref.read(conditionControllerProvider.notifier);
        for (final condition in created.conditions ?? []) {
          conditionController.addNewCondition(condition);
        }
        appRouter.push('/success/agreement-created');
      } else {
        rollback(tempId);
        state = AsyncData(currentState.copyWith(isCreating: false));
      }
    } catch (err) {
      rollback(tempId);
    }
  }

  Future<void> acceptAgreement(String agreementId) async {
    final currentState = state.value ?? AgreementState();

    state = AsyncData(currentState.copyWith(isAccepting: true));

    try {
      final dataState = await ref
          .read(agreementRepositoryProvider)
          .acceptAgreement(agreementId);

      if (dataState is DataSuccess && dataState.data != null) {
        final latestState = state.value ?? currentState;
        final currentAgreements = latestState.agreements;
        final updatedAgreements = [
          dataState.data!,
          ...currentAgreements.where((agt) => agt.id != dataState.data!.id),
        ];

        state = AsyncData(
          latestState.copyWith(
            isAccepting: false,
            agreements: updatedAgreements,
          ),
        );
      } else {
        state = AsyncData(currentState.copyWith(isAccepting: false));
      }
    } catch (err) {
      log(err.toString());
      state = AsyncData(currentState.copyWith(isAccepting: false));
    }
  }

  Future<void> getAgreement(String agreementId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final dataState = await ref
          .read(agreementRepositoryProvider)
          .getAgreement(agreementId);

      if (dataState is DataSuccess && dataState.data != null) {
        return state.value!.copyWith(selectedAgreement: dataState.data!);
      }

      return state.value!;
    });
  }
}
