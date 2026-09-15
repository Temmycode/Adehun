import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/domain/models/bank.dart';

abstract class BankAccountRepository {
  Future<DataState<List<Bank>>> listBanks();

  Future<DataState<ResolvedAccount>> resolveAccount({
    required String accountNumber,
    required String bankCode,
  });

  Future<DataState<List<BankAccount>>> listAccounts();

  Future<DataState<BankAccount>> addAccount({
    required String accountNumber,
    required String bankCode,
    bool makeDefault = false,
  });

  Future<DataState<BankAccount>> setDefault(String accountId);

  Future<DataState<void>> deleteAccount(String accountId);
}
