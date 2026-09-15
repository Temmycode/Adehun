import 'dart:developer';
import 'dart:io';

import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/data/services/bank_account_api_service.dart';
import 'package:adehun_mvp/domain/bank_account_repository.dart';
import 'package:adehun_mvp/domain/models/bank.dart';
import 'package:flutter/foundation.dart';

class BankAccountRepoImpl implements BankAccountRepository {
  final BankAccountApiService _api;

  const BankAccountRepoImpl(BankAccountApiService api) : _api = api;

  @override
  Future<DataState<List<Bank>>> listBanks() async {
    try {
      final response = await _api.listBanks();
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(const GetBanksError());
    } catch (err) {
      if (kDebugMode) log('listBanks failed: ${err.runtimeType}');
      return DataFailed(const GetBanksError());
    }
  }

  @override
  Future<DataState<ResolvedAccount>> resolveAccount({
    required String accountNumber,
    required String bankCode,
  }) async {
    try {
      final response = await _api.resolveAccount({
        'account_number': accountNumber,
        'bank_code': bankCode,
      });
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(const ResolveBankAccountError());
    } catch (err) {
      if (kDebugMode) log('resolveAccount failed: ${err.runtimeType}');
      return DataFailed(const ResolveBankAccountError());
    }
  }

  @override
  Future<DataState<List<BankAccount>>> listAccounts() async {
    try {
      final response = await _api.listAccounts();
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(const GetBankAccountsError());
    } catch (err) {
      if (kDebugMode) log('listAccounts failed: ${err.runtimeType}');
      return DataFailed(const GetBankAccountsError());
    }
  }

  @override
  Future<DataState<BankAccount>> addAccount({
    required String accountNumber,
    required String bankCode,
    bool makeDefault = false,
  }) async {
    try {
      final response = await _api.addAccount({
        'account_number': accountNumber,
        'bank_code': bankCode,
        'make_default': makeDefault,
      });
      final status = response.response.statusCode;
      if (status == HttpStatus.created || status == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(const AddBankAccountError());
    } catch (err) {
      if (kDebugMode) log('addAccount failed: ${err.runtimeType}');
      // Rethrown so the controller can surface CONFLICT / validation copy.
      rethrow;
    }
  }

  @override
  Future<DataState<BankAccount>> setDefault(String accountId) async {
    try {
      final response = await _api.setDefault(accountId);
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(const UpdateBankAccountError());
    } catch (err) {
      if (kDebugMode) log('setDefault failed: ${err.runtimeType}');
      return DataFailed(const UpdateBankAccountError());
    }
  }

  @override
  Future<DataState<void>> deleteAccount(String accountId) async {
    try {
      final response = await _api.deleteAccount(accountId);
      final status = response.response.statusCode;
      if (status == HttpStatus.ok || status == HttpStatus.noContent) {
        return const DataSuccess(null);
      }
      return DataFailed(const UpdateBankAccountError());
    } catch (err) {
      if (kDebugMode) log('deleteAccount failed: ${err.runtimeType}');
      return DataFailed(const UpdateBankAccountError());
    }
  }
}
