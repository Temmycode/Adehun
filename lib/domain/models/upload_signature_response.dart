import 'package:json_annotation/json_annotation.dart';

part 'upload_signature_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UploadSignatureResponse {
  final int timestamp;
  final String signature;
  final String apiKey;
  final String cloudName;
  final String folder;

  UploadSignatureResponse({
    required this.timestamp,
    required this.signature,
    required this.apiKey,
    required this.cloudName,
    required this.folder,
  });

  factory UploadSignatureResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadSignatureResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadSignatureResponseToJson(this);
}
