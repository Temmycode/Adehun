// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionSummary _$TransactionSummaryFromJson(Map<String, dynamic> json) =>
    TransactionSummary(
      totalCredit: json['total_credit'] as String,
      totalDebit: json['total_debit'] as String,
      creditCount: (json['credit_count'] as num).toInt(),
      debitCount: (json['debit_count'] as num).toInt(),
    );

Map<String, dynamic> _$TransactionSummaryToJson(TransactionSummary instance) =>
    <String, dynamic>{
      'total_credit': instance.totalCredit,
      'total_debit': instance.totalDebit,
      'credit_count': instance.creditCount,
      'debit_count': instance.debitCount,
    };
