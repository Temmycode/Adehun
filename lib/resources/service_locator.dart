import 'package:adehun_mvp/data/interceptors/auth_interceptor.dart';
import 'package:adehun_mvp/data/local/preferences_service.dart';
import 'package:adehun_mvp/data/local/token_storage.dart';
import 'package:adehun_mvp/data/repositories/auth_repo_impl.dart';
import 'package:adehun_mvp/data/services/auth_api_service.dart';
import 'package:adehun_mvp/domain/auth_repository.dart';
import 'package:adehun_mvp/providers/auth_controller.dart';
import 'package:adehun_mvp/theme/theme_provider.dart';
import 'package:adehun_mvp/usecases/google_sign_in.dart';
import 'package:adehun_mvp/usecases/register_from_invite.dart';
import 'package:adehun_mvp/usecases/register_user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Google Sign In
  await GoogleSignIn.instance.initialize(
    serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
  );

  // Local Storage
  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  sl.registerSingleton<TokenStorage>(TokenStorage(sl()));

  // Preferences
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerSingleton<PreferencesService>(PreferencesService(sharedPrefs));
  sl.registerSingleton<ThemeProvider>(ThemeProvider(sl()));

  // Dio
  final dio = Dio();
  dio.interceptors.add(AuthInterceptor(sl()));
  sl.registerSingleton<Dio>(dio);

  // Services
  sl.registerSingleton<AuthApiService>(AuthApiService(sl()));

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepoImpl(sl()));

  // UseCases
  sl.registerSingleton<GoogleSignInUseCase>(GoogleSignInUseCase(sl()));
  sl.registerSingleton<RegisterUserUseCase>(RegisterUserUseCase(sl()));
  sl.registerSingleton<RegisterFromInviteUseCase>(
    RegisterFromInviteUseCase(sl()),
  );

  // Controllers
  sl.registerFactory<AuthController>(
    () => AuthController(
      googleSignInUseCase: sl(),
      registerUserUseCase: sl(),
      registerFromInviteUseCase: sl(),
      tokenStorage: sl(),
      preferencesService: sl(),
    ),
  );
}
