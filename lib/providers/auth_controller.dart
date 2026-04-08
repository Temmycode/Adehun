import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/data/local/preferences_service.dart';
import 'package:adehun_mvp/data/local/token_storage.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/router/app_router.dart';
import 'package:adehun_mvp/usecases/google_sign_in.dart';
import 'package:adehun_mvp/usecases/params/register_from_invite_params.dart';
import 'package:adehun_mvp/usecases/params/register_user_params.dart';
import 'package:adehun_mvp/usecases/register_from_invite.dart';
import 'package:adehun_mvp/usecases/register_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends ChangeNotifier {
  final RegisterUserUseCase registerUserUseCase;
  final RegisterFromInviteUseCase registerFromInviteUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final TokenStorage tokenStorage;
  final PreferencesService preferencesService;

  AuthController({
    required this.registerUserUseCase,
    required this.registerFromInviteUseCase,
    required this.googleSignInUseCase,
    required this.tokenStorage,
    required this.preferencesService,
  }) {
    getUser();
  }

  bool _isLoading = false;
  bool _isSignedUp = true;
  UserData? _user;
  // GETTERS
  bool get isLoading => _isLoading;
  bool get isSignedUp => _isSignedUp;
  UserData? get user => _user;

  // SETTERS
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set isSignedUp(bool value) {
    _isSignedUp = value;
    notifyListeners();
  }

  Future<void> setUser(UserData? value) async {
    _user = value;
    await preferencesService.setUser(value);
    notifyListeners();
  }

  void getUser() {
    _user = preferencesService.user;
  }

  Future<void> googleSignIn() async {
    try {
      isLoading = true;

      final dataState = await googleSignInUseCase();

      if (dataState is DataFailed) {
        if (dataState.exception is LoginFailedError) {
          // Handle login failure
        }
        return;
      }

      if (dataState is DataSuccess && dataState.data == null) {
        // Handle failuer
        print("An error occurred while signing in with Google.");
        return;
      }
      final data = dataState.data!;

      // Save Tokens
      if (data.accessToken == null || data.refreshToken == null) {
        print("An error occurred while signing in with Google.");
        return;
      }

      await tokenStorage.saveTokens(
        accessToken: data.accessToken!,
        refreshToken: data.refreshToken!,
      );

      await preferencesService.setLoggedIn(true);
      await preferencesService.setUser(data.user);
      isSignedUp = data.isSignedUp ?? false;
      await setUser(data.user);
    } catch (e) {
      print("An error occurred while signing in with Google: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> registerUser(RegisterUserParams params) async {
    try {
      isLoading = true;

      final dataState = await registerUserUseCase(params: params);

      if (dataState is DataFailed) {
        // Handle failure
        return;
      }

      if (dataState is DataSuccess && dataState.data == null) {
        // Handle failuer
      }

      // Handle Success
      await setUser(dataState.data);

      appRouter.go('/home');
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerFromInvite(RegisterFromInviteParams params) async {
    try {
      isLoading = true;

      final dataState = await registerFromInviteUseCase(params: params);

      if (dataState is DataFailed) {
        // Handle failure
        return;
      }

      if (dataState is DataSuccess && dataState.data == null) {
        // Handle failuer
      }

      // Handle Success
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await tokenStorage.clearTokens();
    await preferencesService.setLoggedIn(false);
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.instance.signOut();
    _user = null;
    _isSignedUp = true;
    notifyListeners();
  }
}
