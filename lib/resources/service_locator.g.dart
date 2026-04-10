// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_locator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(secureStorage)
final secureStorageProvider = SecureStorageProvider._();

final class SecureStorageProvider
    extends
        $FunctionalProvider<
          FlutterSecureStorage,
          FlutterSecureStorage,
          FlutterSecureStorage
        >
    with $Provider<FlutterSecureStorage> {
  SecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<FlutterSecureStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FlutterSecureStorage create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlutterSecureStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlutterSecureStorage>(value),
    );
  }
}

String _$secureStorageHash() => r'273dc403a965c1f24962aaf4d40776611a26f8b8';

@ProviderFor(tokenStorage)
final tokenStorageProvider = TokenStorageProvider._();

final class TokenStorageProvider
    extends $FunctionalProvider<TokenStorage, TokenStorage, TokenStorage>
    with $Provider<TokenStorage> {
  TokenStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStorageHash();

  @$internal
  @override
  $ProviderElement<TokenStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TokenStorage create(Ref ref) {
    return tokenStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenStorage>(value),
    );
  }
}

String _$tokenStorageHash() => r'd21f5514194593262ad3dfd3844316c09f675fdf';

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'9ce5d3a1d8e34e1852c77b7a602fe3158dd8f0ca';

@ProviderFor(preferencesService)
final preferencesServiceProvider = PreferencesServiceProvider._();

final class PreferencesServiceProvider
    extends
        $FunctionalProvider<
          PreferencesService,
          PreferencesService,
          PreferencesService
        >
    with $Provider<PreferencesService> {
  PreferencesServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesServiceHash();

  @$internal
  @override
  $ProviderElement<PreferencesService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PreferencesService create(Ref ref) {
    return preferencesService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PreferencesService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PreferencesService>(value),
    );
  }
}

String _$preferencesServiceHash() =>
    r'938b384b0d6abe8d8da1aa29f04bc9cd9f8c1b3d';

@ProviderFor(authInterceptor)
final authInterceptorProvider = AuthInterceptorProvider._();

final class AuthInterceptorProvider
    extends
        $FunctionalProvider<AuthInterceptor, AuthInterceptor, AuthInterceptor>
    with $Provider<AuthInterceptor> {
  AuthInterceptorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authInterceptorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authInterceptorHash();

  @$internal
  @override
  $ProviderElement<AuthInterceptor> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthInterceptor create(Ref ref) {
    return authInterceptor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthInterceptor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthInterceptor>(value),
    );
  }
}

String _$authInterceptorHash() => r'9290e6840718d71642f31c46304448ee50ff74ac';

@ProviderFor(dio)
final dioProvider = DioProvider._();

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'9c838e876878a74451d3386fac72a5dc947e4532';

@ProviderFor(authService)
final authServiceProvider = AuthServiceProvider._();

final class AuthServiceProvider
    extends $FunctionalProvider<AuthApiService, AuthApiService, AuthApiService>
    with $Provider<AuthApiService> {
  AuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authServiceHash();

  @$internal
  @override
  $ProviderElement<AuthApiService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthApiService create(Ref ref) {
    return authService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthApiService>(value),
    );
  }
}

String _$authServiceHash() => r'3c74b3e077a45234fed80e95b1b44e1ac7c3b756';

@ProviderFor(agreementService)
final agreementServiceProvider = AgreementServiceProvider._();

final class AgreementServiceProvider
    extends
        $FunctionalProvider<
          AgreementApiService,
          AgreementApiService,
          AgreementApiService
        >
    with $Provider<AgreementApiService> {
  AgreementServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'agreementServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$agreementServiceHash();

  @$internal
  @override
  $ProviderElement<AgreementApiService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AgreementApiService create(Ref ref) {
    return agreementService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AgreementApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AgreementApiService>(value),
    );
  }
}

String _$agreementServiceHash() => r'2dec718ca2bf060b955535f04e6ee5b57152a7d3';

@ProviderFor(conditionService)
final conditionServiceProvider = ConditionServiceProvider._();

final class ConditionServiceProvider
    extends
        $FunctionalProvider<
          ConditionApiService,
          ConditionApiService,
          ConditionApiService
        >
    with $Provider<ConditionApiService> {
  ConditionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conditionServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conditionServiceHash();

  @$internal
  @override
  $ProviderElement<ConditionApiService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConditionApiService create(Ref ref) {
    return conditionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConditionApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConditionApiService>(value),
    );
  }
}

String _$conditionServiceHash() => r'20b08b81aa0e22e06c2ad79ba56bc7cd0848ccf0';

@ProviderFor(statsService)
final statsServiceProvider = StatsServiceProvider._();

final class StatsServiceProvider
    extends
        $FunctionalProvider<StatsApiService, StatsApiService, StatsApiService>
    with $Provider<StatsApiService> {
  StatsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statsServiceHash();

  @$internal
  @override
  $ProviderElement<StatsApiService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StatsApiService create(Ref ref) {
    return statsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatsApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatsApiService>(value),
    );
  }
}

String _$statsServiceHash() => r'c952f9944f81a1ea4bbe1b1ba756a58469a224aa';

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'f062d37442ec011cb9622dfca03758b4103869ef';

@ProviderFor(agreementRepository)
final agreementRepositoryProvider = AgreementRepositoryProvider._();

final class AgreementRepositoryProvider
    extends
        $FunctionalProvider<
          AgreementRepository,
          AgreementRepository,
          AgreementRepository
        >
    with $Provider<AgreementRepository> {
  AgreementRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'agreementRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$agreementRepositoryHash();

  @$internal
  @override
  $ProviderElement<AgreementRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AgreementRepository create(Ref ref) {
    return agreementRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AgreementRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AgreementRepository>(value),
    );
  }
}

String _$agreementRepositoryHash() =>
    r'5d99b16f1dc2e7a85c00cf368d2c97257288e038';

@ProviderFor(conditionRepository)
final conditionRepositoryProvider = ConditionRepositoryProvider._();

final class ConditionRepositoryProvider
    extends
        $FunctionalProvider<
          ConditionRepository,
          ConditionRepository,
          ConditionRepository
        >
    with $Provider<ConditionRepository> {
  ConditionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conditionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conditionRepositoryHash();

  @$internal
  @override
  $ProviderElement<ConditionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConditionRepository create(Ref ref) {
    return conditionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConditionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConditionRepository>(value),
    );
  }
}

String _$conditionRepositoryHash() =>
    r'23c2526c0b5063d619d7b9904e2615163b65f849';

@ProviderFor(statsRepository)
final statsRepositoryProvider = StatsRepositoryProvider._();

final class StatsRepositoryProvider
    extends
        $FunctionalProvider<StatsRepository, StatsRepository, StatsRepository>
    with $Provider<StatsRepository> {
  StatsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statsRepositoryHash();

  @$internal
  @override
  $ProviderElement<StatsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StatsRepository create(Ref ref) {
    return statsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatsRepository>(value),
    );
  }
}

String _$statsRepositoryHash() => r'ead819b5dd7750ea79241a3fe0038b2313528ed8';

@ProviderFor(googleSignInUseCase)
final googleSignInUseCaseProvider = GoogleSignInUseCaseProvider._();

final class GoogleSignInUseCaseProvider
    extends
        $FunctionalProvider<
          GoogleSignInUseCase,
          GoogleSignInUseCase,
          GoogleSignInUseCase
        >
    with $Provider<GoogleSignInUseCase> {
  GoogleSignInUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleSignInUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleSignInUseCaseHash();

  @$internal
  @override
  $ProviderElement<GoogleSignInUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GoogleSignInUseCase create(Ref ref) {
    return googleSignInUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleSignInUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleSignInUseCase>(value),
    );
  }
}

String _$googleSignInUseCaseHash() =>
    r'f0cfc8f7860687107b702423f2f9cd4986bdea20';

@ProviderFor(registerUserUseCase)
final registerUserUseCaseProvider = RegisterUserUseCaseProvider._();

final class RegisterUserUseCaseProvider
    extends
        $FunctionalProvider<
          RegisterUserUseCase,
          RegisterUserUseCase,
          RegisterUserUseCase
        >
    with $Provider<RegisterUserUseCase> {
  RegisterUserUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerUserUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerUserUseCaseHash();

  @$internal
  @override
  $ProviderElement<RegisterUserUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RegisterUserUseCase create(Ref ref) {
    return registerUserUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterUserUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterUserUseCase>(value),
    );
  }
}

String _$registerUserUseCaseHash() =>
    r'98e044af3c848b46176ae5ed028351f5a07b6828';

@ProviderFor(registerFromInviteUseCase)
final registerFromInviteUseCaseProvider = RegisterFromInviteUseCaseProvider._();

final class RegisterFromInviteUseCaseProvider
    extends
        $FunctionalProvider<
          RegisterFromInviteUseCase,
          RegisterFromInviteUseCase,
          RegisterFromInviteUseCase
        >
    with $Provider<RegisterFromInviteUseCase> {
  RegisterFromInviteUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerFromInviteUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerFromInviteUseCaseHash();

  @$internal
  @override
  $ProviderElement<RegisterFromInviteUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RegisterFromInviteUseCase create(Ref ref) {
    return registerFromInviteUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterFromInviteUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterFromInviteUseCase>(value),
    );
  }
}

String _$registerFromInviteUseCaseHash() =>
    r'ca4f877c5ce569233ef9a3577e9bce7a34cc33b2';

@ProviderFor(getAllAgreementsUseCase)
final getAllAgreementsUseCaseProvider = GetAllAgreementsUseCaseProvider._();

final class GetAllAgreementsUseCaseProvider
    extends
        $FunctionalProvider<
          GetAllAgreementsUseCase,
          GetAllAgreementsUseCase,
          GetAllAgreementsUseCase
        >
    with $Provider<GetAllAgreementsUseCase> {
  GetAllAgreementsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllAgreementsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllAgreementsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetAllAgreementsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetAllAgreementsUseCase create(Ref ref) {
    return getAllAgreementsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetAllAgreementsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetAllAgreementsUseCase>(value),
    );
  }
}

String _$getAllAgreementsUseCaseHash() =>
    r'527cf4cc0435581c25a2f4252f2c5dd97554e591';

@ProviderFor(acceptAgreementUseCase)
final acceptAgreementUseCaseProvider = AcceptAgreementUseCaseProvider._();

final class AcceptAgreementUseCaseProvider
    extends
        $FunctionalProvider<
          AcceptAgreementUseCase,
          AcceptAgreementUseCase,
          AcceptAgreementUseCase
        >
    with $Provider<AcceptAgreementUseCase> {
  AcceptAgreementUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'acceptAgreementUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$acceptAgreementUseCaseHash();

  @$internal
  @override
  $ProviderElement<AcceptAgreementUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AcceptAgreementUseCase create(Ref ref) {
    return acceptAgreementUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AcceptAgreementUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AcceptAgreementUseCase>(value),
    );
  }
}

String _$acceptAgreementUseCaseHash() =>
    r'09ffb0e59ad4a8cf4a5615dd490fa83ca0fb991b';

@ProviderFor(createAgreementUseCase)
final createAgreementUseCaseProvider = CreateAgreementUseCaseProvider._();

final class CreateAgreementUseCaseProvider
    extends
        $FunctionalProvider<
          CreateAgreementUseCase,
          CreateAgreementUseCase,
          CreateAgreementUseCase
        >
    with $Provider<CreateAgreementUseCase> {
  CreateAgreementUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createAgreementUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createAgreementUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateAgreementUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateAgreementUseCase create(Ref ref) {
    return createAgreementUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateAgreementUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateAgreementUseCase>(value),
    );
  }
}

String _$createAgreementUseCaseHash() =>
    r'1ead8b0490d870c56237d213f7f40418b9bfaf2c';

@ProviderFor(getAgreementUseCase)
final getAgreementUseCaseProvider = GetAgreementUseCaseProvider._();

final class GetAgreementUseCaseProvider
    extends
        $FunctionalProvider<
          GetAgreementUseCase,
          GetAgreementUseCase,
          GetAgreementUseCase
        >
    with $Provider<GetAgreementUseCase> {
  GetAgreementUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAgreementUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAgreementUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetAgreementUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetAgreementUseCase create(Ref ref) {
    return getAgreementUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetAgreementUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetAgreementUseCase>(value),
    );
  }
}

String _$getAgreementUseCaseHash() =>
    r'2c3bd60483efa84c225b16ecb015e1224ecedd94';

@ProviderFor(addConditionToAgreementUseCase)
final addConditionToAgreementUseCaseProvider =
    AddConditionToAgreementUseCaseProvider._();

final class AddConditionToAgreementUseCaseProvider
    extends
        $FunctionalProvider<
          AddConditionToAgreementUseCase,
          AddConditionToAgreementUseCase,
          AddConditionToAgreementUseCase
        >
    with $Provider<AddConditionToAgreementUseCase> {
  AddConditionToAgreementUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addConditionToAgreementUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addConditionToAgreementUseCaseHash();

  @$internal
  @override
  $ProviderElement<AddConditionToAgreementUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AddConditionToAgreementUseCase create(Ref ref) {
    return addConditionToAgreementUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddConditionToAgreementUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddConditionToAgreementUseCase>(
        value,
      ),
    );
  }
}

String _$addConditionToAgreementUseCaseHash() =>
    r'20d946ff5f75a68e2748561249e82b11d0f5aea6';

@ProviderFor(getUsersConditionsUseCase)
final getUsersConditionsUseCaseProvider = GetUsersConditionsUseCaseProvider._();

final class GetUsersConditionsUseCaseProvider
    extends
        $FunctionalProvider<
          GetUsersConditionsUseCase,
          GetUsersConditionsUseCase,
          GetUsersConditionsUseCase
        >
    with $Provider<GetUsersConditionsUseCase> {
  GetUsersConditionsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getUsersConditionsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getUsersConditionsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetUsersConditionsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetUsersConditionsUseCase create(Ref ref) {
    return getUsersConditionsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetUsersConditionsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetUsersConditionsUseCase>(value),
    );
  }
}

String _$getUsersConditionsUseCaseHash() =>
    r'ea111ab43e5d6d5351315ac9e7ec071716855bc9';

@ProviderFor(getConditionDetailsUseCase)
final getConditionDetailsUseCaseProvider =
    GetConditionDetailsUseCaseProvider._();

final class GetConditionDetailsUseCaseProvider
    extends
        $FunctionalProvider<
          GetConditionDetailsUseCase,
          GetConditionDetailsUseCase,
          GetConditionDetailsUseCase
        >
    with $Provider<GetConditionDetailsUseCase> {
  GetConditionDetailsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getConditionDetailsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getConditionDetailsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetConditionDetailsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetConditionDetailsUseCase create(Ref ref) {
    return getConditionDetailsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetConditionDetailsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetConditionDetailsUseCase>(value),
    );
  }
}

String _$getConditionDetailsUseCaseHash() =>
    r'64e61a677541c5d82c048b0de51497a2fc7d097e';

@ProviderFor(approveConditionUseCase)
final approveConditionUseCaseProvider = ApproveConditionUseCaseProvider._();

final class ApproveConditionUseCaseProvider
    extends
        $FunctionalProvider<
          ApproveConditionUseCase,
          ApproveConditionUseCase,
          ApproveConditionUseCase
        >
    with $Provider<ApproveConditionUseCase> {
  ApproveConditionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'approveConditionUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$approveConditionUseCaseHash();

  @$internal
  @override
  $ProviderElement<ApproveConditionUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApproveConditionUseCase create(Ref ref) {
    return approveConditionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApproveConditionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApproveConditionUseCase>(value),
    );
  }
}

String _$approveConditionUseCaseHash() =>
    r'153eef9c54155c67f2a3aa33fe5b712cce31cd9b';

@ProviderFor(rejectConditionUseCase)
final rejectConditionUseCaseProvider = RejectConditionUseCaseProvider._();

final class RejectConditionUseCaseProvider
    extends
        $FunctionalProvider<
          RejectConditionUseCase,
          RejectConditionUseCase,
          RejectConditionUseCase
        >
    with $Provider<RejectConditionUseCase> {
  RejectConditionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rejectConditionUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rejectConditionUseCaseHash();

  @$internal
  @override
  $ProviderElement<RejectConditionUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RejectConditionUseCase create(Ref ref) {
    return rejectConditionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RejectConditionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RejectConditionUseCase>(value),
    );
  }
}

String _$rejectConditionUseCaseHash() =>
    r'2b5d084fa7b19886ea18f2c3192646f0b15c4aee';

@ProviderFor(getUserAgreementStatsUseCase)
final getUserAgreementStatsUseCaseProvider =
    GetUserAgreementStatsUseCaseProvider._();

final class GetUserAgreementStatsUseCaseProvider
    extends
        $FunctionalProvider<
          GetUserAgreementStatsUseCase,
          GetUserAgreementStatsUseCase,
          GetUserAgreementStatsUseCase
        >
    with $Provider<GetUserAgreementStatsUseCase> {
  GetUserAgreementStatsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getUserAgreementStatsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getUserAgreementStatsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetUserAgreementStatsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetUserAgreementStatsUseCase create(Ref ref) {
    return getUserAgreementStatsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetUserAgreementStatsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetUserAgreementStatsUseCase>(value),
    );
  }
}

String _$getUserAgreementStatsUseCaseHash() =>
    r'b441b58cec94869bb20eecf69a693df9cfaf2428';
