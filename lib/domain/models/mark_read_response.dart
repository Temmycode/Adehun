import 'package:json_annotation/json_annotation.dart';

part 'mark_read_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MarkReadResponse {
  final int updatedCount;

  const MarkReadResponse({required this.updatedCount});

  factory MarkReadResponse.fromJson(Map<String, dynamic> json) =>
      _$MarkReadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MarkReadResponseToJson(this);
}
