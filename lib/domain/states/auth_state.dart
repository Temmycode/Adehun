// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AuthState {
  final UserData? userData;
  final bool isSignedUp;
  final bool isLoading;

  const AuthState({
    required this.userData,
    required this.isSignedUp,
    this.isLoading = false,
  });

  const AuthState.unknown()
      : userData = null,
        isSignedUp = false,
        isLoading = false;

  AuthState copyWith({UserData? userData, bool? isSignedUp, bool? isLoading}) {
    return AuthState(
      userData: userData ?? this.userData,
      isSignedUp: isSignedUp ?? this.isSignedUp,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
