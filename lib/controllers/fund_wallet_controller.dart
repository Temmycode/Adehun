import 'dart:developer';

import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/data/services/paystack_service.dart';
import 'package:adehun_mvp/domain/states/fund_wallet_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fund_wallet_controller.g.dart';

/// Deliberately `keepAlive` — a payment in flight must not be disposed
/// mid-checkout. Callers that only `ref.read` this (rather than watching it)
/// register no listener, so under autoDispose the provider died on the first
/// await and the Paystack sheet never opened.
@Riverpod(keepAlive: true)
class FundWalletController extends _$FundWalletController {
  @override
  FundWalletState build() => const FundWalletState();

  /// Runs the top-up flow. Returns true only when Paystack hands back a payment
  /// reference — false covers a failed request, a dismissed sheet, and a
  /// non-initialised SDK. Failures are also written to [FundWalletState.error]
  /// so the UI can surface them.
  ///
  /// Does no navigation: this is driven from both the fund-wallet screen and the
  /// create-agreement flow, and they need different destinations on success.
  Future<bool> fundWallet(double amount, String channel) async {
    if (state.isLoading) return false;
    state = state.copyWith(isLoading: true, error: () => null);

    try {
      final dataState = await ref
          .read(walletRepositoryProvider)
          .fundWallet(amount, channel);

      final accessCode = dataState.data?.accessCode;

      if (dataState is DataFailed || accessCode == null) {
        _update(
          error: () =>
              dataState.exception?.toString() ??
              "Couldn't start the payment. Please try again.",
        );
        return false;
      }

      final reference = await PaystackService.instance.launch(accessCode);

      // Null means the user dismissed the checkout sheet, or the SDK wasn't
      // initialised — neither is an error worth a snackbar.
      if (reference == null) return false;

      debugPrint('Paystack reference: $reference');
      return true;
    } catch (err, stk) {
      log('$err, $stk');
      _update(error: () => _friendlyError(err));
      return false;
    } finally {
      _update(isLoading: false);
    }
  }

  void clearError() => _update(error: () => null);

  /// The repository rethrows raw exceptions, and those are not fit to show a
  /// user — `DioException.toString()` in particular dumps the entire request.
  /// [AppException]s already carry readable copy.
  String _friendlyError(Object err) {
    if (err is AppException) return err.toString();

    if (err is DioException) {
      return switch (err.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.connectionError =>
          'Network problem. Check your connection and try again.',
        _ => "Couldn't complete the payment. Please try again.",
      };
    }

    return "Couldn't complete the payment. Please try again.";
  }

  /// Writes state only while the provider is alive.
  ///
  /// Every write in [fundWallet] happens after an await, and the provider can
  /// legitimately be gone by then — the scope torn down, or the user signed out
  /// mid-checkout. Reading `state` on a disposed provider throws, so the guard
  /// has to come before touching it at all, which rules out doing this inline.
  void _update({bool? isLoading, String? Function()? error}) {
    if (!ref.mounted) return;
    state = state.copyWith(isLoading: isLoading, error: error);
  }
}
