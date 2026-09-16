import 'dart:developer';

import 'package:adehun_mvp/controllers/agreement_list_controller.dart';
import 'package:adehun_mvp/controllers/notification_controller.dart';
import 'package:adehun_mvp/controllers/unread_count_controller.dart';
import 'package:adehun_mvp/controllers/wallet_data_controller.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/models/login_response.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:adehun_mvp/domain/states/auth_state.dart';
import 'package:adehun_mvp/router/auth_route_notifier.dart';
import 'package:adehun_mvp/usecases/params/register_from_invite_params.dart';
import 'package:adehun_mvp/usecases/params/register_user_params.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    final user = ref.read(preferencesServiceProvider).user;
    if (user != null && authRouteNotifier.hasSession) {
      return AuthState(userData: user, status: AuthStatus.authenticated);
    }
    return const AuthState(status: AuthStatus.initial);
  }

  bool get _isBusy => state.isLoading;

  Future<void> setUser(UserData? value, {AuthStatus? status}) async {
    state = state.copyWith(
      userData: () => value,
      status: status ?? state.status,
    );
    await ref.read(preferencesServiceProvider).setUser(value);
    _syncRouteGuard();
  }

  /// Mirrors auth state into the router guard so redirects stay correct.
  void _syncRouteGuard() {
    switch (state.status) {
      case AuthStatus.authenticated:
        authRouteNotifier.setSession(hasSession: true);
      case AuthStatus.noAccount:
        authRouteNotifier.setSession(hasSession: true, needsProfile: true);
      case AuthStatus.initial:
        authRouteNotifier.setSession(hasSession: false);
      case AuthStatus.error:
        break;
    }
  }

  Future<void> _storeSession(LoginResponse data) async {
    await ref
        .read(tokenStorageProvider)
        .saveTokens(
          accessToken: data.accessToken!,
          refreshToken: data.refreshToken!,
        );
    final prefs = ref.read(preferencesServiceProvider);
    await prefs.setLoggedIn(true);
    await prefs.setUser(data.user);
  }

  Future<void> googleSignIn() async {
    if (_isBusy) return;

    state = state.copyWith(isLoading: true, errorMessage: () => null);

    try {
      // An invitation link opened before sign-in is honoured here: the
      // invite-aware endpoint signs the user in AND validates the token.
      final pendingInvite = authRouteNotifier.pendingInviteToken;
      final dataState = pendingInvite == null
          ? await ref.read(authRepositoryProvider).googleSignIn()
          : await ref
                .read(authRepositoryProvider)
                .googleSignInWithInvite(pendingInvite);
      final data = dataState.data;

      if (dataState is DataSuccess && data != null) {
        if (data.accessToken != null && data.refreshToken != null) {
          await _storeSession(data);

          final isSignedUp = data.isSignedUp ?? false;
          state = state.copyWith(
            userData: () => data.user,
            status: isSignedUp
                ? AuthStatus.authenticated
                : AuthStatus.noAccount,
          );
          _syncRouteGuard();
          return;
        }
      }

      _setError(dataState.exception.toString());
    } catch (e) {
      log('google sign in failed: ${e.runtimeType}');
      _setError('An unexpected error occurred during Google sign in.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> registerUser(RegisterUserParams params) async {
    if (_isBusy) return;

    state = state.copyWith(isLoading: true, errorMessage: () => null);

    try {
      final dataState = await ref
          .read(authRepositoryProvider)
          .registerUser(
            userId: params.userId,
            phoneNumber: params.phoneNumber,
            fullName: params.fullName,
          );

      if (dataState is DataSuccess && dataState.data != null) {
        // The router redirects /profile-completion -> /home once the guard
        // sees an authenticated session with a complete profile.
        await setUser(dataState.data, status: AuthStatus.authenticated);
      } else {
        _setError(dataState.exception.toString());
      }
    } catch (e) {
      log('registration failed: ${e.runtimeType}');
      _setError('An error occurred during registration.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> registerFromInvite(RegisterFromInviteParams params) async {
    if (_isBusy) return;

    state = state.copyWith(isLoading: true, errorMessage: () => null);

    try {
      final dataState = await ref
          .read(authRepositoryProvider)
          .registerFromInvite(params.idToken, params.invitationToken);

      if (dataState is DataSuccess && dataState.data != null) {
        await _storeSession(dataState.data!);
        await setUser(dataState.data?.user, status: AuthStatus.authenticated);
      } else {
        _setError(dataState.exception.toString());
      }
    } catch (e) {
      log('invite registration failed: ${e.runtimeType}');
      _setError('An error occurred while accepting the invitation.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      // Revoke the refresh token server-side first (best effort), then drop
      // everything local.
      try {
        final refresh = await ref.read(tokenStorageProvider).getRefreshToken();
        if (refresh != null) {
          await ref.read(authRepositoryProvider).logout(refresh);
        }
      } catch (_) {}

      await ref.read(tokenStorageProvider).clearTokens();
      await ref.read(preferencesServiceProvider).setLoggedIn(false);

      try {
        ref.read(walletSocketServiceProvider).close();
      } catch (_) {}
      try {
        ref.read(agreementWebsocketServiceProvider).close();
      } catch (_) {}

      try {
        await ref.read(localDataCacheManagerProvider).clearAll();
      } catch (_) {}

      try {
        await ref.read(preferencesServiceProvider).setUser(null);
      } catch (_) {}

      try {
        ref.invalidate(agreementListControllerProvider);
        ref.invalidate(walletDataControllerProvider);
        ref.invalidate(unreadCountControllerProvider);
        ref.invalidate(notificationControllerProvider);
      } catch (_) {}

      await FirebaseAuth.instance.signOut();
      await GoogleSignIn.instance.signOut();

      state = const AuthState(status: AuthStatus.initial);
      authRouteNotifier.setSession(hasSession: false);
    } catch (e) {
      _setError('Failed to sign out clean.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Called by the auth interceptor when a refresh is rejected.
  Future<void> handleSessionExpired() async {
    await ref.read(preferencesServiceProvider).setLoggedIn(false);
    await ref.read(preferencesServiceProvider).setUser(null);
    state = const AuthState(status: AuthStatus.initial);
    authRouteNotifier.setSession(hasSession: false);
  }

  void _setError(String message) {
    state = state.copyWith(
      status: AuthStatus.error,
      errorMessage: () => message,
    );
  }
}
