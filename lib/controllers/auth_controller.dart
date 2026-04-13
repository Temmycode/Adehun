import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:adehun_mvp/domain/states/auth_state.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/resources/service_locator.dart';
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
    if (user != null) return AuthState(userData: user, status: .authenticated);
    return AuthState();
  }

  Future<void> setUser(UserData? value, {AuthStatus? status}) async {
    state = state.copyWith(userData: value, status: status);
    await ref.read(preferencesServiceProvider).setUser(value);
  }

  Future<void> googleSignIn() async {
    try {
      state = state.copyWith(isLoading: true);

      final dataState = await ref.read(authRepositoryProvider).googleSignIn();
      final data = dataState.data!;

      if (dataState is DataSuccess &&
          dataState.data != null &&
          dataState.data!.accessToken != null &&
          dataState.data!.refreshToken != null) {
        await ref
            .read(tokenStorageProvider)
            .saveTokens(
              accessToken: data.accessToken!,
              refreshToken: data.refreshToken!,
            );

        final preferencesService = ref.read(preferencesServiceProvider);
        await preferencesService.setLoggedIn(true);
        await preferencesService.setUser(data.user);
        state = state.copyWith(
          userData: data.user,
          status: (data.isSignedUp ?? false) ? .authenticated : .noAccount,
        );
      } else {
        print("An error occurred while signing in with Google.");
        return;
      }
    } catch (e) {
      print("An error occurred while signing in with Google: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> registerUser(RegisterUserParams params) async {
    try {
      state = state.copyWith(isLoading: true);

      final dataState = await ref
          .read(authRepositoryProvider)
          .registerUser(
            userId: params.userId,
            phoneNumber: params.phoneNumber,
            fullName: params.fullName,
          );

      if (dataState is DataFailed) {
        // Handle failure
        return;
      }

      if (dataState is DataSuccess && dataState.data == null) {
        // Handle failure
      }

      // Handle Success
      await setUser(
        dataState.data,
        status: dataState.data != null ? .authenticated : .error,
      );

      if (dataState is DataFailed) {
        // Show error
      }
    } catch (e) {
      // Handle error
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> registerFromInvite(RegisterFromInviteParams params) async {
    try {
      state = state.copyWith(isLoading: true);

      final dataState = await ref
          .read(authRepositoryProvider)
          .registerFromInvite(params.idToken, params.invitationToken);

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
    state = AuthState();
  }
}
