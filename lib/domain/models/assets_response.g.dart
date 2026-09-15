// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetsResponse _$AssetsResponseFromJson(Map<String, dynamic> json) =>
    AssetsResponse(
      id: json['id'] as String,
      uploader: UploaderResponse.fromJson(
        json['uploader'] as Map<String, dynamic>,
      ),
      isApproved: json['is_approved'] as bool,
      file: FileResponse.fromJson(json['file'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AssetsResponseToJson(AssetsResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uploader': instance.uploader.toJson(),
      'is_approved': instance.isApproved,
      'file': instance.file.toJson(),
    };

UploaderResponse _$UploaderResponseFromJson(Map<String, dynamic> json) =>
    UploaderResponse(
      id: json['id'] as String,
      agreementId: json['agreement_id'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UploaderResponseToJson(UploaderResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'agreement_id': instance.agreementId,
      'role': instance.role,
      'status': instance.status,
      'user': instance.user.toJson(),
    };

FileResponse _$FileResponseFromJson(Map<String, dynamic> json) => FileResponse(
  id: json['id'] as String,
  url: json['url'] as String,
  type: $enumDecode(
    _$AssetTypeEnumMap,
    json['type'],
    unknownValue: AssetType.unknown,
  ),
  name: json['name'] as String,
  size: (json['size'] as num?)?.toDouble() ?? 0.0,
  path: json['path'] as String?,
);

Map<String, dynamic> _$FileResponseToJson(FileResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'type': _$AssetTypeEnumMap[instance.type]!,
      'name': instance.name,
      'size': instance.size,
      'path': instance.path,
    };

const _$AssetTypeEnumMap = {
  AssetType.image: 'image',
  AssetType.audio: 'audio',
  AssetType.video: 'video',
  AssetType.pdf: 'pdf',
  AssetType.document: 'document',
  AssetType.archive: 'archive',
  AssetType.unknown: 'unknown',
};
