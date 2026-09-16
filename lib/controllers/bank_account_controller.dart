import 'dart:developer';

import 'package:adehun_mvp/core/network/api_error_handler.dart';
import 'package:adehun_mvp/core/network/api_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/models/bank.dart';
import 'package:adehun_mvp/domain/states/bank_account_state.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bank_account_controller.g.dart';

@Riverpod(keepAlive: true)
class BankAccountController extends _$BankAccountController {
  @override
  BankAccountState build() => const BankAccountState();

  Future<void> loadBanks() async {
    if (state.banks.isNotEmpty || state.isLoadingBanks) return;
    state = state.copyWith(isLoadingBanks: true, errorMessage: () => null);
    final result = await ref.read(bankAccountRepositoryProvider).listBanks();
    if (!ref.mounted) return;
    final data = result.data;
    if (result is DataSuccess && data != null) {
      final banks = [...data]..sort((a, b) => a.name.compareTo(b.name));
      state = state.copyWith(banks: banks, isLoadingBanks: false);
    } else {
      state = state.copyWith(
        isLoadingBanks: false,
        errorMessage: () => result.exception?.toString(),
      );
    }
  }

  Future<void> loadAccounts({bool force = false}) async {
    if (state.isLoadingAccounts) return;
    if (state.hasLoadedAccounts && !force) return;
    state = state.copyWith(isLoadingAccounts: true, errorMessage: () => null);
    final result = await ref.read(bankAccountRepositoryProvider).listAccounts();
    if (!ref.mounted) return;
    if (result is DataSuccess && result.data != null) {
      state = state.copyWith(
        accounts: result.data,
        isLoadingAccounts: false,
        hasLoadedAccounts: true,
      );
    } else {
      state = state.copyWith(
        isLoadingAccounts: false,
        errorMessage: () => result.exception?.toString(),
      );
    }
  }

  Future<ResolvedAccount?> resolve({
    required String accountNumber,
    required String bankCode,
  }) async {
    state = state.copyWith(
      isResolving: true,
      resolved: () => null,
      errorMessage: () => null,
    );
    final result = await ref
        .read(bankAccountRepositoryProvider)
        .resolveAccount(accountNumber: accountNumber, bankCode: bankCode);
    if (!ref.mounted) return null;
    if (result is DataSuccess && result.data != null) {
      state = state.copyWith(isResolving: false, resolved: () => result.data);
      return result.data;
    }
    state = state.copyWith(
      isResolving: false,
      errorMessage: () => result.exception?.toString(),
    );
    return null;
  }

  Future<bool> add({
    required String accountNumber,
    required String bankCode,
    bool makeDefault = false,
  }) async {
    if (state.isSaving) return false;
    state = state.copyWith(isSaving: true, errorMessage: () => null);
    try {
      final result = await ref
          .read(bankAccountRepositoryProvider)
          .addAccount(
            accountNumber: accountNumber,
            bankCode: bankCode,
            makeDefault: makeDefault,
          );
      if (!ref.mounted) return false;
      if (result is DataSuccess && result.data != null) {
        final added = result.data!;
        final others = state.accounts
            .map(
              (a) => added.isDefault
                  ? BankAccount(
                      id: a.id,
                      accountNumber: a.accountNumber,
                      accountName: a.accountName,
                      bankCode: a.bankCode,
                      bankName: a.bankName,
                      currency: a.currency,
                      isDefault: false,
                      createdAt: a.createdAt,
                    )
                  : a,
            )
            .toList();
        state = state.copyWith(
          accounts: [added, ...others],
          isSaving: false,
          resolved: () => null,
        );
        return true;
      }
      state = state.copyWith(
        isSaving: false,
        errorMessage: () => result.exception?.toString(),
      );
      return false;
    } on DioException catch (err) {
      final apiError = err.error;
      state = state.copyWith(
        isSaving: false,
        errorMessage: () => apiError is ApiError
            ? handleApiError(apiError)
            : "Couldn't save that bank account.",
      );
      return false;
    } catch (err) {
      log('add bank account failed: $err');
      state = state.copyWith(
        isSaving: false,
        errorMessage: () => "Couldn't save that bank account.",
      );
      return false;
    }
  }

  Future<void> setDefault(String accountId) async {
    final result = await ref
        .read(bankAccountRepositoryProvider)
        .setDefault(accountId);
    if (!ref.mounted) return;
    if (result is DataSuccess) {
      await loadAccounts(force: true);
    } else {
      state = state.copyWith(errorMessage: () => result.exception?.toString());
    }
  }

  Future<void> remove(String accountId) async {
    final result = await ref
        .read(bankAccountRepositoryProvider)
        .deleteAccount(accountId);
    if (!ref.mounted) return;
    if (result is DataSuccess) {
      state = state.copyWith(
        accounts: state.accounts.where((a) => a.id != accountId).toList(),
      );
    } else {
      state = state.copyWith(errorMessage: () => result.exception?.toString());
    }
  }

  void clearError() => state = state.copyWith(errorMessage: () => null);
  void clearResolved() => state = state.copyWith(resolved: () => null);
}
