import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/domain/states/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthNavigationState {
  loading,
  unauthenticated,
  needsProfile,
  authenticated,
  error,
}

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authControllerProvider).isLoading;
});

final authNavigationStateProvider = Provider<AuthNavigationState>((ref) {
  final auth = ref.watch(authControllerProvider);

  if (auth.isLoading) return AuthNavigationState.loading;

  return switch (auth.status) {
    AuthStatus.initial => AuthNavigationState.unauthenticated,
    AuthStatus.noAccount => AuthNavigationState.needsProfile,
    AuthStatus.authenticated => AuthNavigationState.authenticated,
    AuthStatus.error => AuthNavigationState.error,
  };
});
