import 'package:adehun_mvp/constants/asset_types.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mime/mime.dart';

part 'assets_response.g.dart';

@JsonSerializable(explicitToJson: true)
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

@JsonSerializable(explicitToJson: true)
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

@JsonSerializable(explicitToJson: true)
class FileResponse {
  final String id;
  final String url;
  @JsonKey(unknownEnumValue: AssetType.unknown)
  final AssetType type;
  final String name;
  @JsonKey(defaultValue: 0.0)
  final double size;
  final String? path;

  FileResponse({
    required this.id,
    required this.url,
    required this.type,
    required this.name,
    required this.size,
    this.path,
  });

  FileResponse copyWith({
    String? id,
    String? url,
    AssetType? type,
    String? name,
    double? size,
    String? path,
  }) {
    return FileResponse(
      id: id ?? this.id,
      url: url ?? this.url,
      type: type ?? this.type,
      name: name ?? this.name,
      size: size ?? this.size,
      path: path ?? this.path,
    );
  }

  factory FileResponse.fromJson(Map<String, dynamic> json) =>
      _$FileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FileResponseToJson(this);

  Map<String, dynamic> toUpload() => {
    "url": url,
    "type": type.name,
    "name": name,
    "size": size,
  };
  factory FileResponse.fromFile(PlatformFile file) {
    // Safely check if path is non-null before running lookupMimeType
    final String? mimeType = file.path != null
        ? lookupMimeType(file.path!)
        : null;

    return FileResponse(
      id: '',
      url: '',
      type: AssetTypeIdentifier.fromFile(
        extension: file.extension,
        mimeType: mimeType,
      ),
      name: file.name,
      size: file.size.toDouble(),
      path: file.path,
    );
  }
}
