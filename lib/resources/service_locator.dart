import 'package:adehun_mvp/data/interceptors/auth_interceptor.dart';
import 'package:adehun_mvp/data/local/preferences_service.dart';
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
import 'package:adehun_mvp/usecases/accept_agreement.dart';
import 'package:adehun_mvp/usecases/add_condition_to_agreement.dart';
import 'package:adehun_mvp/usecases/approve_condition.dart';
import 'package:adehun_mvp/usecases/create_agreement.dart';
import 'package:adehun_mvp/usecases/get_agreement.dart';
import 'package:adehun_mvp/usecases/get_all_agreements.dart';
import 'package:adehun_mvp/usecases/get_condition_details.dart';
import 'package:adehun_mvp/usecases/get_users_conditions.dart';
import 'package:adehun_mvp/usecases/google_sign_in.dart';
import 'package:adehun_mvp/usecases/register_from_invite.dart';
import 'package:adehun_mvp/usecases/register_user.dart';
import 'package:adehun_mvp/usecases/get_user_agreement_stats.dart';
import 'package:adehun_mvp/usecases/reject_condition.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'service_locator.g.dart';

Future<void> initializeDependencies() async {
  await GoogleSignIn.instance.initialize(
    serverClientId: String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID'),
  );

  // // Services
  // sl.registerSingleton<AuthApiService>(AuthApiService(sl()));
  // sl.registerSingleton<AgreementApiService>(AgreementApiService(sl()));
  // sl.registerSingleton<ConditionApiService>(ConditionApiService(sl()));
  // sl.registerSingleton<StatsApiService>(StatsApiService(sl()));

  // // Repositories
  // sl.registerSingleton<AuthRepository>(AuthRepoImpl(sl()));
  // sl.registerSingleton<AgreementRepository>(AgreementRepoImpl(sl()));
  // sl.registerSingleton<ConditionRepository>(ConditionRepoImpl(sl()));
  // sl.registerSingleton<StatsRepository>(StatsRepoImpl(sl()));

  // Controllers
  // sl.registerFactory<StatsController>(
  //   () => StatsController(getUserAgreementStatsUseCase: sl()),
  // );
  // sl.registerFactory<AgreementController>(
  //   () => AgreementController(
  //     getAllAgreementsUseCase: sl(),
  //     createAgreementUseCase: sl(),
  //     acceptAgreementUseCase: sl(),
  //     getAgreementUseCase: sl(),
  //   ),
  // );
  // sl.registerFactory<ConditionController>(
  //   () => ConditionController(
  //     addConditionToAgreementUseCase: sl(),
  //     getUsersConditionsUseCase: sl(),
  //     getConditionDetailsUseCase: sl(),
  //     approveConditionUseCase: sl(),
  //     rejectConditionUseCase: sl(),
  //   ),
  // );
  // sl.registerFactory<AuthController>(
  //   () => AuthController(
  //     googleSignInUseCase: sl(),
  //     registerUserUseCase: sl(),
  //     registerFromInviteUseCase: sl(),
  //     tokenStorage: sl(),
  //     preferencesService: sl(),
  //   ),
  // );
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
  return AuthInterceptor(tokenStorage);
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

// UseCases
@riverpod
GoogleSignInUseCase googleSignInUseCase(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoogleSignInUseCase(authRepository);
}

@riverpod
RegisterUserUseCase registerUserUseCase(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return RegisterUserUseCase(authRepository);
}

@riverpod
RegisterFromInviteUseCase registerFromInviteUseCase(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return RegisterFromInviteUseCase(authRepository);
}

// Agreement UseCases
@riverpod
GetAllAgreementsUseCase getAllAgreementsUseCase(Ref ref) {
  final agreementRepository = ref.watch(agreementRepositoryProvider);
  return GetAllAgreementsUseCase(agreementRepository);
}

@riverpod
AcceptAgreementUseCase acceptAgreementUseCase(Ref ref) {
  final agreementRepository = ref.watch(agreementRepositoryProvider);
  return AcceptAgreementUseCase(agreementRepository);
}

@riverpod
CreateAgreementUseCase createAgreementUseCase(Ref ref) {
  final agreementRepository = ref.watch(agreementRepositoryProvider);
  return CreateAgreementUseCase(agreementRepository);
}

@riverpod
GetAgreementUseCase getAgreementUseCase(Ref ref) {
  final agreementRepository = ref.watch(agreementRepositoryProvider);
  return GetAgreementUseCase(agreementRepository);
}

// Condition UseCases
@riverpod
AddConditionToAgreementUseCase addConditionToAgreementUseCase(Ref ref) {
  final conditionRepository = ref.watch(conditionRepositoryProvider);
  return AddConditionToAgreementUseCase(conditionRepository);
}

@riverpod
GetUsersConditionsUseCase getUsersConditionsUseCase(Ref ref) {
  final conditionRepository = ref.watch(conditionRepositoryProvider);
  return GetUsersConditionsUseCase(conditionRepository);
}

@riverpod
GetConditionDetailsUseCase getConditionDetailsUseCase(Ref ref) {
  final conditionRepository = ref.watch(conditionRepositoryProvider);
  return GetConditionDetailsUseCase(conditionRepository);
}

@riverpod
ApproveConditionUseCase approveConditionUseCase(Ref ref) {
  final conditionRepository = ref.watch(conditionRepositoryProvider);
  return ApproveConditionUseCase(conditionRepository);
}

@riverpod
RejectConditionUseCase rejectConditionUseCase(Ref ref) {
  final conditionRepository = ref.watch(conditionRepositoryProvider);
  return RejectConditionUseCase(conditionRepository);
}

// Stats UseCases
@riverpod
GetUserAgreementStatsUseCase getUserAgreementStatsUseCase(Ref ref) {
  final statsRepository = ref.watch(statsRepositoryProvider);
  return GetUserAgreementStatsUseCase(statsRepository);
}
