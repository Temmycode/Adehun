import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserData {
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? profilePictureUrl;

  /// Platform staff. Lets the client surface admin-only entry points.
  @JsonKey(defaultValue: false)
  final bool isAdmin;

  const UserData({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.profilePictureUrl,
    this.isAdmin = false,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  UserData copyWith({
    String? name,
    String? phoneNumber,
    String? profilePictureUrl,
  }) {
    return UserData(
      id: id,
      name: name ?? this.name,
      email: email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      isAdmin: isAdmin,
    );
  }

  String get initials {
    if (name == null || name!.isEmpty) return '';
    final parts = name!.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }
}
