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

String _$authInterceptorHash() => r'334eab288d7941c352c93746f337ffb972fba9bb';

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
