// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionListResponse _$TransactionListResponseFromJson(
  Map<String, dynamic> json,
) => TransactionListResponse(
  transactions: (json['transactions'] as List<dynamic>)
      .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  skip: (json['skip'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  summary: TransactionSummary.fromJson(json['summary'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TransactionListResponseToJson(
  TransactionListResponse instance,
) => <String, dynamic>{
  'transactions': instance.transactions,
  'total': instance.total,
  'skip': instance.skip,
  'limit': instance.limit,
  'summary': instance.summary,
};
