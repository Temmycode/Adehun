// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:flutter/foundation.dart' show immutable;

enum AuthStatus { initial, authenticated, noAccount, error }

@immutable
class AuthState {
  final UserData? userData;
  final AuthStatus status;
  final bool isLoading;

  const AuthState({
    this.userData,
    this.isLoading = false,
    this.status = .initial,
  });

  AuthState copyWith({
    UserData? userData,
    bool? isLoading,
    AuthStatus? status,
  }) {
    return AuthState(
      userData: userData ?? this.userData,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
