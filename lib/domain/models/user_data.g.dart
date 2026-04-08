// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  id: json['id'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String?,
  phoneNumber: json['phone_number'] as String?,
  profilePictureUrl: json['profile_picture_url'] as String?,
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone_number': instance.phoneNumber,
  'profile_picture_url': instance.profilePictureUrl,
};
