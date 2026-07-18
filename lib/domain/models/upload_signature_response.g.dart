// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_signature_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadSignatureResponse _$UploadSignatureResponseFromJson(
  Map<String, dynamic> json,
) => UploadSignatureResponse(
  timestamp: (json['timestamp'] as num).toInt(),
  signature: json['signature'] as String,
  apiKey: json['api_key'] as String,
  cloudName: json['cloud_name'] as String,
  folder: json['folder'] as String,
);

Map<String, dynamic> _$UploadSignatureResponseToJson(
  UploadSignatureResponse instance,
) => <String, dynamic>{
  'timestamp': instance.timestamp,
  'signature': instance.signature,
  'api_key': instance.apiKey,
  'cloud_name': instance.cloudName,
  'folder': instance.folder,
};
