import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable(fieldRename: .snake)
class LoginResponse {
  final String? accessToken;
  final String? refreshToken;
  final bool? isSignedUp;
  final UserData? user;

  const LoginResponse({
    this.accessToken,
    this.refreshToken,
    this.isSignedUp,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
