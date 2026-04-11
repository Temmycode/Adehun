import 'package:adehun_mvp/data/interceptors/auth_interceptor.dart';
import 'package:adehun_mvp/data/local/preferences_service.dart';
import 'package:adehun_mvp/router/app_router.dart';
import 'package:adehun_mvp/data/local/token_storage.dart';
import 'package:adehun_mvp/data/repositories/agreement_repo_impl.dart';
import 'package:adehun_mvp/data/repositories/auth_repo_impl.dart';
import 'package:adehun_mvp/data/repositories/condition_repo_impl.dart';
import 'package:adehun_mvp/data/repositories/stats_repo_impl.dart';
import 'package:adehun_mvp/data/services/agreement_api_service.dart';
import 'package:adehun_mvp/data/services/auth_api_service.dart';
import 'package:adehun_mvp/data/services/condition_api_service.dart';
import 'package:adehun_mvp/data/services/stats_api_service.dart';
import 'package:adehun_mvp/domain/agreement_repository.dart';
import 'package:adehun_mvp/domain/auth_repository.dart';
import 'package:adehun_mvp/domain/condition_repository.dart';
import 'package:adehun_mvp/domain/stats_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'service_locator.g.dart';

Future<void> initializeDependencies() async {
  const clientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
  await GoogleSignIn.instance.initialize(serverClientId: clientId);
}

@riverpod
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

@riverpod
TokenStorage tokenStorage(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  return TokenStorage(storage);
}

@riverpod
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError();
}

@riverpod
PreferencesService preferencesService(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PreferencesService(prefs);
}

@riverpod
AuthInterceptor authInterceptor(Ref ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthInterceptor(
    tokenStorage,
    onSessionExpired: () {
      appRouter.go('/auth');
    },
  );
}

@riverpod
Dio dio(Ref ref) {
  final dio = Dio();
  final authInterceptor = ref.watch(authInterceptorProvider);
  dio.interceptors.add(authInterceptor);
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
    ),
  );
  return dio;
}

// Services
@riverpod
AuthApiService authService(Ref ref) {
  final dio = ref.watch(dioProvider);
  return AuthApiService(dio);
}

@riverpod
AgreementApiService agreementService(Ref ref) {
  final dio = ref.watch(dioProvider);
  return AgreementApiService(dio);
}

@riverpod
ConditionApiService conditionService(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ConditionApiService(dio);
}

@riverpod
StatsApiService statsService(Ref ref) {
  final dio = ref.watch(dioProvider);
  return StatsApiService(dio);
}

// Repositories
@riverpod
AuthRepository authRepository(Ref ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthRepoImpl(authService);
}

@riverpod
AgreementRepository agreementRepository(Ref ref) {
  final agreementService = ref.watch(agreementServiceProvider);
  return AgreementRepoImpl(agreementService);
}

@riverpod
ConditionRepository conditionRepository(Ref ref) {
  final conditionService = ref.watch(conditionServiceProvider);
  return ConditionRepoImpl(conditionService);
}

@riverpod
StatsRepository statsRepository(Ref ref) {
  final statsService = ref.watch(statsServiceProvider);
  return StatsRepoImpl(statsService);
}
