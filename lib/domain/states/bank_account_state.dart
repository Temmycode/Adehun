import 'package:adehun_mvp/domain/models/bank.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class BankAccountState {
  final List<Bank> banks;
  final List<BankAccount> accounts;
  final ResolvedAccount? resolved;
  final bool isLoadingBanks;
  final bool isLoadingAccounts;
  final bool isResolving;
  final bool isSaving;
  final bool hasLoadedAccounts;
  final String? errorMessage;

  const BankAccountState({
    this.banks = const [],
    this.accounts = const [],
    this.resolved,
    this.isLoadingBanks = false,
    this.isLoadingAccounts = false,
    this.isResolving = false,
    this.isSaving = false,
    this.hasLoadedAccounts = false,
    this.errorMessage,
  });

  BankAccount? get defaultAccount =>
      accounts.where((a) => a.isDefault).firstOrNull ?? accounts.firstOrNull;

  BankAccountState copyWith({
    List<Bank>? banks,
    List<BankAccount>? accounts,
    ResolvedAccount? Function()? resolved,
    bool? isLoadingBanks,
    bool? isLoadingAccounts,
    bool? isResolving,
    bool? isSaving,
    bool? hasLoadedAccounts,
    String? Function()? errorMessage,
  }) {
    return BankAccountState(
      banks: banks ?? this.banks,
      accounts: accounts ?? this.accounts,
      resolved: resolved != null ? resolved() : this.resolved,
      isLoadingBanks: isLoadingBanks ?? this.isLoadingBanks,
      isLoadingAccounts: isLoadingAccounts ?? this.isLoadingAccounts,
      isResolving: isResolving ?? this.isResolving,
      isSaving: isSaving ?? this.isSaving,
      hasLoadedAccounts: hasLoadedAccounts ?? this.hasLoadedAccounts,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
