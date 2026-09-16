import 'package:adehun_mvp/domain/models/withdrawal_response.dart';
import 'package:flutter/foundation.dart' show immutable;

enum WithdrawStage { idle, submitting, pending, completed, failed }

@immutable
class WithdrawState {
  final WithdrawStage stage;
  final WithdrawalResponse? withdrawal;
  final String? errorMessage;

  /// Set when the API says payouts are switched off (`WITHDRAWALS_DISABLED`).
  final bool disabled;

  const WithdrawState({
    this.stage = WithdrawStage.idle,
    this.withdrawal,
    this.errorMessage,
    this.disabled = false,
  });

  bool get isBusy => stage == WithdrawStage.submitting;

  WithdrawState copyWith({
    WithdrawStage? stage,
    WithdrawalResponse? Function()? withdrawal,
    String? Function()? errorMessage,
    bool? disabled,
  }) {
    return WithdrawState(
      stage: stage ?? this.stage,
      withdrawal: withdrawal != null ? withdrawal() : this.withdrawal,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      disabled: disabled ?? this.disabled,
    );
  }
}
