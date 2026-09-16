import 'package:adehun_mvp/controllers/wallet_data_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Waits until the wallet's available balance covers [target].
///
/// Paystack handing back a reference does not mean the wallet has been
/// credited — that happens server-side by webhook. Calling an endpoint that
/// debits the wallet immediately after the checkout sheet closes can therefore
/// hit a stale balance and be rejected. This bridges that gap.
///
/// Returns false on timeout, in which case the caller must NOT proceed with the
/// debit; the money is still in flight and the user needs a manual retry.
///
/// Polls rather than awaiting the provider's future: [walletDataControllerProvider]
/// is a keepAlive stream notifier that already holds an `AsyncData` carrying the
/// *pre*-top-up balance, so awaiting its future returns that stale value
/// immediately and would busy-spin. The value it reads is updated over a socket
/// and held in memory, so polling it is free.
Future<bool> awaitWalletBalance(
  Ref ref, {
  required double target,
  Duration timeout = const Duration(seconds: 30),
  Duration pollInterval = const Duration(milliseconds: 500),
}) async {
  final deadline = DateTime.now().add(timeout);

  while (true) {
    final balance = ref
        .read(walletDataControllerProvider)
        .maybeWhen(data: (data) => data.availableBalance, orElse: () => null);

    // Epsilon: `amount` arrives as a decimal string and the balance is a
    // double, so an exact >= intermittently fails on representable-value drift.
    if (balance != null && balance + 0.01 >= target) return true;

    if (DateTime.now().isAfter(deadline)) return false;

    await Future.delayed(pollInterval);

    // The scope can be torn down while we wait — a sign-out, or the provider
    // being disposed. Reading state after that throws.
    if (!ref.mounted) return false;
  }
}
