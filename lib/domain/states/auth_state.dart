import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:flutter/foundation.dart' show immutable;

enum AuthStatus { initial, authenticated, noAccount, error }

@immutable
class AuthState {
  final UserData? userData;
  final AuthStatus status;
  final bool isLoading;
  final String? errorMessage; // Optional: handy for UI error handling

  const AuthState({
    this.userData,
    this.isLoading = false,
    this.status = AuthStatus.initial,
    this.errorMessage,
  });

  AuthState copyWith({
    UserData? Function()?
    userData, // Function wrap allows passing explicit null
    bool? isLoading,
    AuthStatus? status,
    String? Function()? errorMessage,
  }) {
    return AuthState(
      userData: userData != null ? userData() : this.userData,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
