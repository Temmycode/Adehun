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
import 'package:adehun_mvp/providers/agreement_controller.dart';
import 'package:adehun_mvp/providers/auth_controller.dart';
import 'package:adehun_mvp/providers/condition_controller.dart';
import 'package:adehun_mvp/theme/theme_provider.dart';
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
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
    ),
  );
  sl.registerSingleton<Dio>(dio);

  // Services
  sl.registerSingleton<AuthApiService>(AuthApiService(sl()));
  sl.registerSingleton<AgreementApiService>(AgreementApiService(sl()));
  sl.registerSingleton<ConditionApiService>(ConditionApiService(sl()));
  sl.registerSingleton<StatsApiService>(StatsApiService(sl()));

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepoImpl(sl()));
  sl.registerSingleton<AgreementRepository>(AgreementRepoImpl(sl()));
  sl.registerSingleton<ConditionRepository>(ConditionRepoImpl(sl()));
  sl.registerSingleton<StatsRepository>(StatsRepoImpl(sl()));

  // UseCases
  sl.registerSingleton<GoogleSignInUseCase>(GoogleSignInUseCase(sl()));
  sl.registerSingleton<RegisterUserUseCase>(RegisterUserUseCase(sl()));
  sl.registerSingleton<RegisterFromInviteUseCase>(
    RegisterFromInviteUseCase(sl()),
  );

  // Agreement UseCases
  sl.registerSingleton<GetAllAgreementsUseCase>(GetAllAgreementsUseCase(sl()));
  sl.registerSingleton<CreateAgreementUseCase>(CreateAgreementUseCase(sl()));
  sl.registerSingleton<AcceptAgreementUseCase>(AcceptAgreementUseCase(sl()));
  sl.registerSingleton<GetAgreementUseCase>(GetAgreementUseCase(sl()));

  // Condition UseCases
  sl.registerSingleton<AddConditionToAgreementUseCase>(
    AddConditionToAgreementUseCase(sl()),
  );
  sl.registerSingleton<GetUsersConditionsUseCase>(
    GetUsersConditionsUseCase(sl()),
  );
  sl.registerSingleton<GetConditionDetailsUseCase>(
    GetConditionDetailsUseCase(sl()),
  );
  sl.registerSingleton<ApproveConditionUseCase>(ApproveConditionUseCase(sl()));
  sl.registerSingleton<RejectConditionUseCase>(RejectConditionUseCase(sl()));

  // Stats UseCases
  sl.registerSingleton<GetUserAgreementStatsUseCase>(
    GetUserAgreementStatsUseCase(sl()),
  );

  // Controllers
  sl.registerFactory<AgreementController>(
    () => AgreementController(
      getAllAgreementsUseCase: sl(),
      createAgreementUseCase: sl(),
      acceptAgreementUseCase: sl(),
      getAgreementUseCase: sl(),
    ),
  );
  sl.registerFactory<ConditionController>(
    () => ConditionController(
      addConditionToAgreementUseCase: sl(),
      getUsersConditionsUseCase: sl(),
      getConditionDetailsUseCase: sl(),
      approveConditionUseCase: sl(),
      rejectConditionUseCase: sl(),
    ),
  );
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
