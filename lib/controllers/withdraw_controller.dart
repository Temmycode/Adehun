import 'dart:async';
import 'dart:developer';

import 'package:adehun_mvp/core/network/api_error_handler.dart';
import 'package:adehun_mvp/core/network/api_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/states/withdraw_state.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'withdraw_controller.g.dart';

/// Drives one withdrawal: submit, then wait for settlement.
///
/// Settlement arrives over the wallet socket (`WITHDRAWAL_COMPLETED` /
/// `WITHDRAWAL_FAILED`) and, as a fallback, by polling the status endpoint,
/// because a dropped socket must not leave the screen stuck on "pending".
@Riverpod(keepAlive: true)
class WithdrawController extends _$WithdrawController {
  Timer? _poll;
  StreamSubscription<Map<String, dynamic>>? _events;
  DateTime? _pollDeadline;

  @override
  WithdrawState build() {
    ref.onDispose(_stopWatching);
    return const WithdrawState();
  }

  void reset() {
    _stopWatching();
    state = const WithdrawState();
  }

  /// [amount] is a 2dp decimal string.
  Future<bool> submit({required String amount, String? bankAccountId}) async {
    if (state.isBusy) return false;
    state = state.copyWith(
      stage: WithdrawStage.submitting,
      errorMessage: () => null,
      withdrawal: () => null,
    );

    try {
      final result = await ref
          .read(walletRepositoryProvider)
          .withdraw(amount: amount, bankAccountId: bankAccountId);
      if (!ref.mounted) return false;

      if (result is DataSuccess && result.data != null) {
        final wd = result.data!;
        state = state.copyWith(
          stage: wd.isSuccess
              ? WithdrawStage.completed
              : wd.isFailed
              ? WithdrawStage.failed
              : WithdrawStage.pending,
          withdrawal: () => wd,
        );
        // Reflect the debit immediately.
        unawaited(ref.read(walletRepositoryProvider).refresh());
        if (wd.isPending) _watch(wd.reference);
        return true;
      }
      state = state.copyWith(
        stage: WithdrawStage.idle,
        errorMessage: () => result.exception?.toString(),
      );
      return false;
    } on DioException catch (err) {
      final apiError = err.error;
      final disabled =
          apiError is ApiError && apiError.code == 'WITHDRAWALS_DISABLED';
      state = state.copyWith(
        stage: WithdrawStage.idle,
        disabled: disabled,
        errorMessage: () => apiError is ApiError
            ? handleApiError(apiError)
            : "Couldn't start the withdrawal. Please try again.",
      );
      return false;
    } catch (err) {
      log('withdraw failed: $err');
      state = state.copyWith(
        stage: WithdrawStage.idle,
        errorMessage: () => "Couldn't start the withdrawal. Please try again.",
      );
      return false;
    }
  }

  void _watch(String reference) {
    _stopWatching();
    final repo = ref.read(walletRepositoryProvider);

    _events = repo.withdrawalEvents.listen((frame) {
      if (frame['reference'] != reference) return;
      _applyTerminal(
        frame['type'] == 'WITHDRAWAL_COMPLETED'
            ? WithdrawStage.completed
            : WithdrawStage.failed,
        reason: frame['reason'] as String?,
      );
    });

    _pollDeadline = DateTime.now().add(const Duration(minutes: 2));
    _poll = Timer.periodic(const Duration(seconds: 4), (_) async {
      if (_pollDeadline != null && DateTime.now().isAfter(_pollDeadline!)) {
        _stopWatching();
        return;
      }
      final result = await repo.getWithdrawal(reference);
      if (!ref.mounted) return;
      if (result is DataSuccess && result.data != null) {
        final wd = result.data!;
        if (wd.isSuccess) {
          _applyTerminal(WithdrawStage.completed);
        } else if (wd.isFailed) {
          _applyTerminal(WithdrawStage.failed, reason: wd.failureReason);
        }
      }
    });
  }

  void _applyTerminal(WithdrawStage stage, {String? reason}) {
    _stopWatching();
    if (!ref.mounted) return;
    state = state.copyWith(
      stage: stage,
      errorMessage: () => stage == WithdrawStage.failed
          ? (reason ?? 'The bank could not accept the transfer.')
          : null,
    );
    unawaited(ref.read(walletRepositoryProvider).refresh());
  }

  void _stopWatching() {
    _poll?.cancel();
    _poll = null;
    _events?.cancel();
    _events = null;
    _pollDeadline = null;
  }

  void clearError() => state = state.copyWith(errorMessage: () => null);
}
