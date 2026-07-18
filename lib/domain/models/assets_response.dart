import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'assets_response.g.dart';

@JsonSerializable()
class AssetsResponse {
  final String id;
  final UploaderResponse uploader;
  @JsonKey(name: 'is_approved')
  final bool isApproved;
  final FileResponse file;

  AssetsResponse({
    required this.id,
    required this.uploader,
    required this.isApproved,
    required this.file,
  });

  factory AssetsResponse.fromJson(Map<String, dynamic> json) =>
      _$AssetsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AssetsResponseToJson(this);
}

@JsonSerializable()
class UploaderResponse {
  final String id;
  @JsonKey(name: 'agreement_id')
  final String agreementId;
  final String role;
  final String status;
  final UserData user;

  UploaderResponse({
    required this.id,
    required this.agreementId,
    required this.role,
    required this.status,
    required this.user,
  });

  factory UploaderResponse.fromJson(Map<String, dynamic> json) =>
      _$UploaderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploaderResponseToJson(this);
}

@JsonSerializable()
class FileResponse {
  final String id;
  final String url;
  final String type;

  FileResponse({required this.id, required this.url, required this.type});

  factory FileResponse.fromJson(Map<String, dynamic> json) =>
      _$FileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FileResponseToJson(this);
}
