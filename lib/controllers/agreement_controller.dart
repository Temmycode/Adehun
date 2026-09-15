import 'dart:developer';

import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/controllers/condition_controller.dart';
import 'package:adehun_mvp/controllers/fund_wallet_controller.dart';
import 'package:adehun_mvp/controllers/wallet_data_controller.dart';
import 'package:adehun_mvp/core/network/api_error_handler.dart';
import 'package:adehun_mvp/core/network/api_response.dart';
import 'package:adehun_mvp/core/utils/await_wallet_balance.dart';
import 'package:adehun_mvp/domain/models/agreement_create_response.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/models/agreement_invitation_response.dart';
import 'package:adehun_mvp/domain/states/agreement_state.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/router/app_router.dart';
import 'package:adehun_mvp/usecases/params/create_agreement_params.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
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

  /// Returns whether the agreement was accepted, so the caller can decide
  /// whether to go on to fund the escrow.
  Future<bool> acceptAgreement(String agreementId) async {
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
        return true;
      }

      return false;
    } catch (err, stk) {
      log('Error accepting agreement: $err\n$stk');
      return false;
    } finally {
      final latest = state.value ?? initial;
      state = AsyncData(latest.copyWith(isAccepting: false));
    }
  }

  /// Moves the agreement amount from the depositor's wallet into escrow,
  /// topping the wallet up first if it doesn't cover the amount.
  ///
  /// Shared by the auto-fund path after accepting and the manual Fund Escrow
  /// button, so every partial failure has the same way back.
  ///
  /// Unlike [acceptAgreement], failures are written to [AgreementState.fundError]
  /// rather than only logged — money is involved and the user needs the reason.
  Future<bool> fundAgreement(String agreementId) async {
    final initial = state.value ?? const AgreementState();

    // Re-entrancy: a second POST would carry a different idempotency key, and
    // only the server-side ledger reference would save us.
    if (initial.fundingAgreementId != null) return false;

    final agreement = initial.agreements
        .where((agt) => agt.id == agreementId)
        .firstOrNull;

    if (agreement == null) {
      _setFundError("Couldn't find that agreement. Please try again.");
      return false;
    }

    // Already settled — a repeat call would only be a no-op replay anyway.
    if (agreement.isFunded) return true;

    // Safety net behind the screen-level gate: only the depositor may fund, and
    // a beneficiary reaching here would just eat a 403.
    //
    // Returns false WITHOUT setting fundError — funding simply doesn't apply to
    // this user, which is not a failure to report. Callers distinguish the two
    // cases by whether fundError was set.
    final currentEmail = ref.read(authControllerProvider).userData?.email;
    if (currentEmail == null || agreement.depositor?.email != currentEmail) {
      return false;
    }

    final amount = double.tryParse(agreement.amount ?? '') ?? 0;
    if (amount <= 0) {
      _setFundError("Couldn't read the escrow amount.");
      return false;
    }

    // Null means the socket hasn't delivered a balance yet. Treating that as
    // zero would charge the user the full amount they may already hold.
    final balance = ref
        .read(walletDataControllerProvider)
        .maybeWhen(data: (data) => data.availableBalance, orElse: () => null);

    if (balance == null) {
      _setFundError("Couldn't read your wallet balance. Please try again.");
      return false;
    }

    // Decided before the first state write so the overlay opens on the stage it
    // will actually spend time in, rather than flashing the wrong label.
    final needsTopUp = balance + 0.01 < amount;

    state = AsyncData(
      initial.copyWith(
        fundingAgreementId: () => agreementId,
        fundingStage: needsTopUp
            ? EscrowFundingStage.toppingUp
            : EscrowFundingStage.movingToEscrow,
        fundError: () => null,
      ),
    );

    try {
      if (needsTopUp) {
        final toppedUp = await ref
            .read(fundWalletControllerProvider.notifier)
            .fundWallet(amount - balance, 'card');

        if (!toppedUp) {
          // A dismissed sheet leaves error null — not every failure is one.
          _setFundError(
            ref.read(fundWalletControllerProvider).error ??
                'Payment was not completed.',
          );
          return false;
        }

        _setStage(EscrowFundingStage.awaitingSettlement);

        final settled = await awaitWalletBalance(ref, target: amount);
        if (!settled) {
          _setFundError(
            'Payment received. Your wallet is still updating — tap Fund Escrow '
            'in a moment to finish.',
          );
          return false;
        }
      }

      _setStage(EscrowFundingStage.movingToEscrow);

      final dataState = await ref
          .read(agreementRepositoryProvider)
          .fundAgreement(agreementId);

      if (dataState is DataSuccess && dataState.data != null) {
        if (kDebugMode && dataState.data!.replayed) {
          log('fundAgreement: replayed, escrow was already funded');
        }

        // Optimistic first so the button goes away immediately...
        _replaceAgreement(agreement.copyWith(isFunded: true));

        // ...then reconcile with the server, since /fund returns an escrow
        // movement rather than the agreement. Best effort: if it fails the
        // optimistic value stands.
        try {
          final refreshed = await ref
              .read(agreementRepositoryProvider)
              .getAgreement(agreementId);

          if (refreshed is DataSuccess && refreshed.data != null) {
            _replaceAgreement(refreshed.data!);
          }
        } catch (err) {
          log('Could not reconcile funded agreement: $err');
        }

        return true;
      }

      _setFundError(
        dataState.exception?.toString() ??
            "Couldn't move the funds into escrow.",
      );
      return false;
    } on DioException catch (err) {
      // The repo rethrows, so a 400 (insufficient balance), 403 or 409 arrives
      // here with the envelope's ApiError already attached by
      // ApiResponseInterceptor. Surface the server's own wording.
      final apiError = err.error;
      _setFundError(
        apiError is ApiError
            ? handleApiError(apiError)
            : "Couldn't move the funds into escrow.",
      );
      return false;
    } catch (err, stk) {
      log('Error funding agreement: $err\n$stk');
      _setFundError("Couldn't move the funds into escrow. Please try again.");
      return false;
    } finally {
      final latest = state.value ?? initial;
      state = AsyncData(
        latest.copyWith(
          fundingStage: EscrowFundingStage.idle,
          fundingAgreementId: () => null,
        ),
      );
    }
  }

  /// Cancels the agreement, reusing [fundError] to report why it failed.
  ///
  /// The server only allows this while the agreement is pending or active AND
  /// the escrow is unfunded — a funded deal has to go through a dispute so the
  /// depositor can't pull their money the moment work starts. It's idempotent,
  /// so a double tap on an already-cancelled agreement is harmless.
  Future<bool> cancelAgreement(String agreementId) async {
    final initial = state.value ?? const AgreementState();
    if (initial.isCancelling) return false;

    state = AsyncData(
      initial.copyWith(isCancelling: true, fundError: () => null),
    );

    try {
      final dataState = await ref
          .read(agreementRepositoryProvider)
          .cancelAgreement(agreementId);

      if (dataState is DataSuccess && dataState.data != null) {
        _replaceAgreement(dataState.data!);
        return true;
      }

      _setFundError(
        dataState.exception?.toString() ??
            "Couldn't cancel the agreement. Please try again.",
      );
      return false;
    } on DioException catch (err) {
      // A 400 here is the server explaining why — most likely the escrow is
      // already funded. Its wording beats anything generic we could write.
      final apiError = err.error;
      _setFundError(
        apiError is ApiError
            ? handleApiError(apiError)
            : "Couldn't cancel the agreement. Please try again.",
      );
      return false;
    } catch (err, stk) {
      log('Error cancelling agreement: $err\n$stk');
      _setFundError("Couldn't cancel the agreement. Please try again.");
      return false;
    } finally {
      final latest = state.value ?? initial;
      state = AsyncData(latest.copyWith(isCancelling: false));
    }
  }

  void clearFundError() {
    final latest = state.value ?? const AgreementState();
    state = AsyncData(latest.copyWith(fundError: () => null));
  }

  /// Swaps [updated] in for the agreement sharing its id, moving it to the
  /// front — the merge shape [acceptAgreement] already uses.
  void _replaceAgreement(AgreementResponse updated) {
    final latest = state.value ?? const AgreementState();
    state = AsyncData(
      latest.copyWith(
        agreements: [
          updated,
          ...latest.agreements.where((agt) => agt.id != updated.id),
        ],
      ),
    );
  }

  void _setStage(EscrowFundingStage stage) {
    final latest = state.value ?? const AgreementState();
    state = AsyncData(latest.copyWith(fundingStage: stage));
  }

  void _setFundError(String message) {
    final latest = state.value ?? const AgreementState();
    state = AsyncData(latest.copyWith(fundError: () => message));
  }

  Future<void> declineAgreement(String agreementId) async {
    final initial = state.value ?? AgreementState();
    state = AsyncData(initial.copyWith(isDeclining: true));

    try {
      final dataState = await ref
          .read(agreementRepositoryProvider)
          .rejectAgreement(agreementId);

      if (dataState is DataSuccess && dataState.data != null) {
        final declined = dataState.data!;

        final latest = state.value ?? initial;

        // Remove the declined agreement from list if present
        final updated = latest.agreements
            .where((agt) => agt.id != declined.id)
            .toList();

        state = AsyncData(latest.copyWith(agreements: updated));
      }
    } catch (err, stk) {
      log('Error declining agreement: $err\n$stk');
    } finally {
      final latest = state.value ?? initial;
      state = AsyncData(latest.copyWith(isDeclining: false));
    }
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
            invitations: Map<String, AgreementInvitationResponse>.from(
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
