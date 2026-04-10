import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:adehun_mvp/domain/states/auth_state.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/resources/service_locator.dart';
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
    final preferenceService = ref.read(preferencesServiceProvider);
    final user = preferenceService.user;
    if (user != null) return AuthState(userData: user, isSignedUp: true);
    return AuthState.unknown();
  }

  Future<void> setUser(UserData? value) async {
    state = state.copyWith(userData: value);
    await ref.read(preferencesServiceProvider).setUser(value);
  }

  Future<void> googleSignIn() async {
    try {
      state = state.copyWith(isLoading: true);

      final dataState = await ref.read(googleSignInUseCaseProvider)();

      if (dataState is DataFailed) {
        if (dataState.exception is LoginFailedError) {
          // Handle login failure
        }
        return;
      }

      if (dataState is DataSuccess && dataState.data == null) {
        print("An error occurred while signing in with Google.");
        return;
      }
      final data = dataState.data!;

      // Save Tokens
      if (data.accessToken == null || data.refreshToken == null) {
        print("An error occurred while signing in with Google.");
        return;
      }

      await ref.read(tokenStorageProvider).saveTokens(
        accessToken: data.accessToken!,
        refreshToken: data.refreshToken!,
      );

      final preferencesService = ref.read(preferencesServiceProvider);
      await preferencesService.setLoggedIn(true);
      await preferencesService.setUser(data.user);
      state = state.copyWith(
        isSignedUp: data.isSignedUp ?? false,
        userData: data.user,
      );
    } catch (e) {
      print("An error occurred while signing in with Google: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> registerUser(RegisterUserParams params) async {
    try {
      state = state.copyWith(isLoading: true);

      final dataState = await ref.read(registerUserUseCaseProvider)(
        params: params,
      );

      if (dataState is DataFailed) {
        // Handle failure
        return;
      }

      if (dataState is DataSuccess && dataState.data == null) {
        // Handle failure
      }

      // Handle Success
      await setUser(dataState.data);

      appRouter.go('/home');
    } catch (e) {
      // Handle error
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> registerFromInvite(RegisterFromInviteParams params) async {
    try {
      state = state.copyWith(isLoading: true);

      final dataState = await ref.read(registerFromInviteUseCaseProvider)(
        params: params,
      );

      if (dataState is DataFailed) {
        // Handle failure
        return;
      }

      if (dataState is DataSuccess && dataState.data == null) {
        // Handle failure
      }

      // Handle Success
    } catch (e) {
      // Handle error
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signOut() async {
    await ref.read(tokenStorageProvider).clearTokens();
    await ref.read(preferencesServiceProvider).setLoggedIn(false);
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.instance.signOut();
    state = AuthState.unknown();
  }
}
