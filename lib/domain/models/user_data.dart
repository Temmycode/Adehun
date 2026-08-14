import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable(fieldRename: .snake)
class UserData {
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? profilePictureUrl;

  const UserData({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.profilePictureUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  String get initials {
    if (name == null || name!.isEmpty) return '';
    final parts = name!.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }
}
