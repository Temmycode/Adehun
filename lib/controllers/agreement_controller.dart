import 'dart:developer';

import 'package:adehun_mvp/controllers/condition_controller.dart';
import 'package:adehun_mvp/domain/models/agreement_create_response.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/models/invitation_response.dart';
import 'package:adehun_mvp/domain/states/agreement_state.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
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
        final conditionController = ref.read(
          conditionControllerProvider.notifier,
        );
        for (final condition in created.conditions ?? []) {
          conditionController.addNewCondition(created.id!, condition);
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
    final initial = state.value ?? AgreementState();
    state = AsyncData(initial.copyWith(isAccepting: true));

    try {
      final dataState = await ref
          .read(agreementRepositoryProvider)
          .acceptAgreement(agreementId);

      if (dataState is DataSuccess && dataState.data != null) {
        final accepted = dataState.data!;

        final latest = state.value ?? initial;

        final updatedAgreements = [
          accepted,
          ...latest.agreements.where((agt) => agt.id != accepted.id),
        ];

        state = AsyncData(latest.copyWith(agreements: updatedAgreements));
      }
    } catch (err, stk) {
      log('Error accepting agreement: $err\n$stk');
    } finally {
      final latest = state.value ?? initial;
      state = AsyncData(latest.copyWith(isAccepting: false));
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

  Future<void> getAgreementInvitation(String agreementId) async {
    final initial = state.value ?? AgreementState();
    state = AsyncData(initial.copyWith(invitationLoading: true));

    try {
      final dataState = await ref
          .read(agreementRepositoryProvider)
          .getAgreementInvitation(agreementId);

      if (dataState is DataSuccess && dataState.data != null) {
        final latest = state.value ?? initial;

        state = AsyncData(
          latest.copyWith(
            invitations: Map<String, InvitationResponse>.from(
              latest.invitations,
            )..[agreementId] = dataState.data!,
          ),
        );
      }
    } catch (err, stk) {
      log('Error fetching invitation: $err\n$stk');
    } finally {
      final latest = state.value ?? initial;
      state = AsyncData(latest.copyWith(invitationLoading: false));
    }
  }
}
