import 'dart:developer';

import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/states/agreement_state.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/resources/service_locator.dart';
import 'package:adehun_mvp/router/app_router.dart';
import 'package:adehun_mvp/usecases/params/create_agreement_params.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'agreement_controller.g.dart';

@riverpod
class AgreementController extends _$AgreementController {
  @override
  FutureOr<AgreementState> build() async {
    return await _getAllAgreements();
  }

  Future<AgreementState> _getAllAgreements() async {
    const initialState = AgreementState();

    try {
      final dataState =
          await ref.read(agreementRepositoryProvider).getAllUserAgreements();

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
      final dataState =
          await ref.read(agreementRepositoryProvider).getAllUserAgreements();

      if (dataState is DataSuccess && dataState.data != null) {
        return currentState.copyWith(agreements: dataState.data!);
      }

      return state.value!;
    });
  }

  Future<void> createAgreement(CreateAgreementParams params) async {
    final currentState = state.value ?? const AgreementState();
    state = AsyncData(currentState.copyWith(isCreating: true));

    final tempId = Uuid().v4();
    final newAgreement = AgreementResponse.fromCreateParams(params, tempId);

    // Optimistic Update
    state = AsyncData(
      currentState.copyWith(
        isCreating: true,
        agreements: [newAgreement, ...currentState.agreements],
      ),
    );

    // Navigate back
    appRouter.pop();

    try {
      final dataState =
          await ref.read(agreementRepositoryProvider).createAgreement(
        participantEmail: params.participantEmail,
        role: params.role,
        title: params.title,
        description: params.description,
        amount: params.amount,
      );
      final latestState = state.value ?? currentState;

      if (dataState is DataSuccess && dataState.data != null) {
        final filtered = latestState.agreements.where(
          (agt) => agt.id != tempId,
        );
        state = AsyncData(
          latestState.copyWith(
            isCreating: false,
            agreements: [dataState.data!, ...filtered],
          ),
        );
      } else {
        final rolledBack = latestState.agreements
            .where((a) => a.id != tempId)
            .toList();

        state = AsyncData(
          latestState.copyWith(isCreating: false, agreements: rolledBack),
        );
        state = AsyncData(currentState.copyWith(isCreating: false));
      }
    } catch (err) {
      final latestState = state.value ?? currentState;
      final rolledBack = latestState.agreements
          .where((a) => a.id != tempId)
          .toList();

      state = AsyncData(
        latestState.copyWith(isCreating: false, agreements: rolledBack),
      );
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
