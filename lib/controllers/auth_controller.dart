import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:adehun_mvp/domain/states/auth_state.dart';
import 'package:adehun_mvp/router/app_router.dart';
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
    if (user != null) {
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
  }

  Future<void> googleSignIn() async {
    if (_isBusy) return;

    state = state.copyWith(isLoading: true, errorMessage: () => null);

    try {
      final dataState = await ref.read(authRepositoryProvider).googleSignIn();
      final data = dataState.data;

      if (dataState is DataSuccess && data != null) {
        if (data.accessToken != null && data.refreshToken != null) {
          await ref
              .read(tokenStorageProvider)
              .saveTokens(
                accessToken: data.accessToken!,
                refreshToken: data.refreshToken!,
              );

          final prefs = ref.read(preferencesServiceProvider);
          await prefs.setLoggedIn(true);
          await prefs.setUser(data.user);

          final isSignedUp = data.isSignedUp ?? false;
          state = state.copyWith(
            userData: () => data.user,
            status: isSignedUp
                ? AuthStatus.authenticated
                : AuthStatus.noAccount,
          );
          return;
        }
      }

      _setError(dataState.exception.toString());
    } catch (e) {
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
        await setUser(dataState.data, status: AuthStatus.authenticated);
        appRouter.go('shell');
      } else {
        _setError(dataState.exception.toString());
      }
    } catch (e) {
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
        await setUser(dataState.data?.user, status: AuthStatus.authenticated);
      } else {
        _setError(dataState.exception.toString());
      }
    } catch (e) {
      _setError('An error occurred while accepting the invitation.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(tokenStorageProvider).clearTokens();
      await ref.read(preferencesServiceProvider).setLoggedIn(false);
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn.instance.signOut();
      state = const AuthState(status: AuthStatus.initial);
    } catch (e) {
      _setError('Failed to sign out clean.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void _setError(String message) {
    state = state.copyWith(
      status: AuthStatus.error,
      errorMessage: () => message,
    );
  }
}
