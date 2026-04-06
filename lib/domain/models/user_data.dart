import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable(fieldRename: .snake)
class UserData {
  final String? userId;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? profilePictureUrl;

  const UserData({
    this.userId,
    this.name,
    this.email,
    this.phoneNumber,
    this.profilePictureUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
