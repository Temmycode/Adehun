import 'package:json_annotation/json_annotation.dart';

part 'bank.g.dart';

/// One entry from `GET /bank-accounts/banks`.
@JsonSerializable(fieldRename: FieldRename.snake)
class Bank {
  final String name;
  final String code;
  final String? currency;
  final String? type;

  const Bank({required this.name, required this.code, this.currency, this.type});

  factory Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);

  Map<String, dynamic> toJson() => _$BankToJson(this);
}

/// `POST /bank-accounts/resolve` result: who owns an account number.
@JsonSerializable(fieldRename: FieldRename.snake)
class ResolvedAccount {
  final String accountNumber;
  final String accountName;
  final String bankCode;
  final String bankName;

  const ResolvedAccount({
    required this.accountNumber,
    required this.accountName,
    required this.bankCode,
    required this.bankName,
  });

  factory ResolvedAccount.fromJson(Map<String, dynamic> json) =>
      _$ResolvedAccountFromJson(json);

  Map<String, dynamic> toJson() => _$ResolvedAccountToJson(this);
}

/// A saved payout destination.
@JsonSerializable(fieldRename: FieldRename.snake)
class BankAccount {
  final String id;
  final String accountNumber;
  final String accountName;
  final String bankCode;
  final String bankName;
  @JsonKey(defaultValue: 'NGN')
  final String currency;
  @JsonKey(defaultValue: false)
  final bool isDefault;
  final DateTime? createdAt;

  const BankAccount({
    required this.id,
    required this.accountNumber,
    required this.accountName,
    required this.bankCode,
    required this.bankName,
    required this.currency,
    required this.isDefault,
    this.createdAt,
  });

  String get maskedNumber => accountNumber.length > 4
      ? '****${accountNumber.substring(accountNumber.length - 4)}'
      : accountNumber;

  factory BankAccount.fromJson(Map<String, dynamic> json) =>
      _$BankAccountFromJson(json);

  Map<String, dynamic> toJson() => _$BankAccountToJson(this);
}
