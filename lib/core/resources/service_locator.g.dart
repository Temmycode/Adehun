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

String _$authInterceptorHash() => r'2d07d74c3e4f4be4ecb6388aebd9613c836025a3';

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

String _$dioHash() => r'f833d811aa70b91a760afcee952f90edcaf7e4b2';

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

@ProviderFor(disputeService)
final disputeServiceProvider = DisputeServiceProvider._();

final class DisputeServiceProvider
    extends
        $FunctionalProvider<
          DisputeApiService,
          DisputeApiService,
          DisputeApiService
        >
    with $Provider<DisputeApiService> {
  DisputeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'disputeServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$disputeServiceHash();

  @$internal
  @override
  $ProviderElement<DisputeApiService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DisputeApiService create(Ref ref) {
    return disputeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DisputeApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DisputeApiService>(value),
    );
  }
}

String _$disputeServiceHash() => r'68aa54fdf07f63b351887c4884f1a9728b7ceb33';

/// Deliberately NOT given [dioProvider] — that Dio carries our auth and
/// logging interceptors, which have no business on a Cloudinary upload.

@ProviderFor(cloudinaryUploadService)
final cloudinaryUploadServiceProvider = CloudinaryUploadServiceProvider._();

/// Deliberately NOT given [dioProvider] — that Dio carries our auth and
/// logging interceptors, which have no business on a Cloudinary upload.

final class CloudinaryUploadServiceProvider
    extends
        $FunctionalProvider<
          CloudinaryUploadService,
          CloudinaryUploadService,
          CloudinaryUploadService
        >
    with $Provider<CloudinaryUploadService> {
  /// Deliberately NOT given [dioProvider] — that Dio carries our auth and
  /// logging interceptors, which have no business on a Cloudinary upload.
  CloudinaryUploadServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cloudinaryUploadServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cloudinaryUploadServiceHash();

  @$internal
  @override
  $ProviderElement<CloudinaryUploadService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CloudinaryUploadService create(Ref ref) {
    return cloudinaryUploadService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CloudinaryUploadService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CloudinaryUploadService>(value),
    );
  }
}

String _$cloudinaryUploadServiceHash() =>
    r'b517b7bc75c6b28351e1e75b1e162a311d475cf5';

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

@ProviderFor(notificationService)
final notificationServiceProvider = NotificationServiceProvider._();

final class NotificationServiceProvider
    extends
        $FunctionalProvider<
          NotificationApiService,
          NotificationApiService,
          NotificationApiService
        >
    with $Provider<NotificationApiService> {
  NotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationServiceHash();

  @$internal
  @override
  $ProviderElement<NotificationApiService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationApiService create(Ref ref) {
    return notificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationApiService>(value),
    );
  }
}

String _$notificationServiceHash() =>
    r'804c61637771e2ea192f49b6bd9a4ba59613ff17';

@ProviderFor(walletService)
final walletServiceProvider = WalletServiceProvider._();

final class WalletServiceProvider
    extends
        $FunctionalProvider<
          WalletApiService,
          WalletApiService,
          WalletApiService
        >
    with $Provider<WalletApiService> {
  WalletServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletServiceHash();

  @$internal
  @override
  $ProviderElement<WalletApiService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WalletApiService create(Ref ref) {
    return walletService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WalletApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WalletApiService>(value),
    );
  }
}

String _$walletServiceHash() => r'90a0f19a4d3181a883fdbee3d742dd5d90587a57';

@ProviderFor(transactionService)
final transactionServiceProvider = TransactionServiceProvider._();

final class TransactionServiceProvider
    extends
        $FunctionalProvider<
          TransactionApiService,
          TransactionApiService,
          TransactionApiService
        >
    with $Provider<TransactionApiService> {
  TransactionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionServiceHash();

  @$internal
  @override
  $ProviderElement<TransactionApiService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransactionApiService create(Ref ref) {
    return transactionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionApiService>(value),
    );
  }
}

String _$transactionServiceHash() =>
    r'3964539ad1fda6aea369a2cc0d607e5069c4da08';

@ProviderFor(walletSocketService)
final walletSocketServiceProvider = WalletSocketServiceProvider._();

final class WalletSocketServiceProvider
    extends
        $FunctionalProvider<
          WalletWebsocketService,
          WalletWebsocketService,
          WalletWebsocketService
        >
    with $Provider<WalletWebsocketService> {
  WalletSocketServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletSocketServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletSocketServiceHash();

  @$internal
  @override
  $ProviderElement<WalletWebsocketService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WalletWebsocketService create(Ref ref) {
    return walletSocketService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WalletWebsocketService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WalletWebsocketService>(value),
    );
  }
}

String _$walletSocketServiceHash() =>
    r'970bf6546ec4a7a6d5d78a6811abcbe53bb83500';

@ProviderFor(agreementWebsocketService)
final agreementWebsocketServiceProvider = AgreementWebsocketServiceProvider._();

final class AgreementWebsocketServiceProvider
    extends
        $FunctionalProvider<
          AgreementWebsocketService,
          AgreementWebsocketService,
          AgreementWebsocketService
        >
    with $Provider<AgreementWebsocketService> {
  AgreementWebsocketServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'agreementWebsocketServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$agreementWebsocketServiceHash();

  @$internal
  @override
  $ProviderElement<AgreementWebsocketService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AgreementWebsocketService create(Ref ref) {
    return agreementWebsocketService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AgreementWebsocketService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AgreementWebsocketService>(value),
    );
  }
}

String _$agreementWebsocketServiceHash() =>
    r'89a4391a7201a4f4758ac2e2897bf06df0b4b1fb';

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

@ProviderFor(disputeRepository)
final disputeRepositoryProvider = DisputeRepositoryProvider._();

final class DisputeRepositoryProvider
    extends
        $FunctionalProvider<
          DisputeRepository,
          DisputeRepository,
          DisputeRepository
        >
    with $Provider<DisputeRepository> {
  DisputeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'disputeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$disputeRepositoryHash();

  @$internal
  @override
  $ProviderElement<DisputeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DisputeRepository create(Ref ref) {
    return disputeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DisputeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DisputeRepository>(value),
    );
  }
}

String _$disputeRepositoryHash() => r'360135bcbbafdf258a3139d23851d5d6d90df5c2';

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

@ProviderFor(notificationRepository)
final notificationRepositoryProvider = NotificationRepositoryProvider._();

final class NotificationRepositoryProvider
    extends
        $FunctionalProvider<
          NotificationRepository,
          NotificationRepository,
          NotificationRepository
        >
    with $Provider<NotificationRepository> {
  NotificationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationRepository create(Ref ref) {
    return notificationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationRepository>(value),
    );
  }
}

String _$notificationRepositoryHash() =>
    r'6573555fae7170f80d341bcfbfe9b558f30d9a88';

@ProviderFor(walletRepository)
final walletRepositoryProvider = WalletRepositoryProvider._();

final class WalletRepositoryProvider
    extends
        $FunctionalProvider<
          WalletRepository,
          WalletRepository,
          WalletRepository
        >
    with $Provider<WalletRepository> {
  WalletRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletRepositoryHash();

  @$internal
  @override
  $ProviderElement<WalletRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WalletRepository create(Ref ref) {
    return walletRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WalletRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WalletRepository>(value),
    );
  }
}

String _$walletRepositoryHash() => r'6b7599b3ff29fa06dea689c8494415105db2660d';

@ProviderFor(transactionRepository)
final transactionRepositoryProvider = TransactionRepositoryProvider._();

final class TransactionRepositoryProvider
    extends
        $FunctionalProvider<
          TransactionRepository,
          TransactionRepository,
          TransactionRepository
        >
    with $Provider<TransactionRepository> {
  TransactionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionRepositoryHash();

  @$internal
  @override
  $ProviderElement<TransactionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransactionRepository create(Ref ref) {
    return transactionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionRepository>(value),
    );
  }
}

String _$transactionRepositoryHash() =>
    r'7b2b592c6edfc129e5e77bc81dba8e888617757f';

@ProviderFor(localDataCacheManager)
final localDataCacheManagerProvider = LocalDataCacheManagerProvider._();

final class LocalDataCacheManagerProvider
    extends
        $FunctionalProvider<
          LocalDataCacheManager,
          LocalDataCacheManager,
          LocalDataCacheManager
        >
    with $Provider<LocalDataCacheManager> {
  LocalDataCacheManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDataCacheManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDataCacheManagerHash();

  @$internal
  @override
  $ProviderElement<LocalDataCacheManager> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalDataCacheManager create(Ref ref) {
    return localDataCacheManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalDataCacheManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalDataCacheManager>(value),
    );
  }
}

String _$localDataCacheManagerHash() =>
    r'714fdbc18042bd99d314f047c684d5b97293695d';

@ProviderFor(getNotificationsUseCase)
final getNotificationsUseCaseProvider = GetNotificationsUseCaseProvider._();

final class GetNotificationsUseCaseProvider
    extends
        $FunctionalProvider<
          GetNotificationsUseCase,
          GetNotificationsUseCase,
          GetNotificationsUseCase
        >
    with $Provider<GetNotificationsUseCase> {
  GetNotificationsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getNotificationsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getNotificationsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetNotificationsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetNotificationsUseCase create(Ref ref) {
    return getNotificationsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetNotificationsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetNotificationsUseCase>(value),
    );
  }
}

String _$getNotificationsUseCaseHash() =>
    r'2256527e6c7950865902d2e3b7cd72855a49ec10';

@ProviderFor(getUnreadCountUseCase)
final getUnreadCountUseCaseProvider = GetUnreadCountUseCaseProvider._();

final class GetUnreadCountUseCaseProvider
    extends
        $FunctionalProvider<
          GetUnreadCountUseCase,
          GetUnreadCountUseCase,
          GetUnreadCountUseCase
        >
    with $Provider<GetUnreadCountUseCase> {
  GetUnreadCountUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getUnreadCountUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getUnreadCountUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetUnreadCountUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetUnreadCountUseCase create(Ref ref) {
    return getUnreadCountUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetUnreadCountUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetUnreadCountUseCase>(value),
    );
  }
}

String _$getUnreadCountUseCaseHash() =>
    r'37a8fd87e8aeff4dee85a935dd842850be30469d';

@ProviderFor(getConditionAssetsUseCase)
final getConditionAssetsUseCaseProvider = GetConditionAssetsUseCaseProvider._();

final class GetConditionAssetsUseCaseProvider
    extends
        $FunctionalProvider<
          GetConditionAssetsUseCase,
          GetConditionAssetsUseCase,
          GetConditionAssetsUseCase
        >
    with $Provider<GetConditionAssetsUseCase> {
  GetConditionAssetsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getConditionAssetsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getConditionAssetsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetConditionAssetsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetConditionAssetsUseCase create(Ref ref) {
    return getConditionAssetsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetConditionAssetsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetConditionAssetsUseCase>(value),
    );
  }
}

String _$getConditionAssetsUseCaseHash() =>
    r'2710a70846b1f826afd83c720a0427e0f16603d3';

@ProviderFor(addConditionAssetsUseCase)
final addConditionAssetsUseCaseProvider = AddConditionAssetsUseCaseProvider._();

final class AddConditionAssetsUseCaseProvider
    extends
        $FunctionalProvider<
          AddConditionAssetsUseCase,
          AddConditionAssetsUseCase,
          AddConditionAssetsUseCase
        >
    with $Provider<AddConditionAssetsUseCase> {
  AddConditionAssetsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addConditionAssetsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addConditionAssetsUseCaseHash();

  @$internal
  @override
  $ProviderElement<AddConditionAssetsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AddConditionAssetsUseCase create(Ref ref) {
    return addConditionAssetsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddConditionAssetsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddConditionAssetsUseCase>(value),
    );
  }
}

String _$addConditionAssetsUseCaseHash() =>
    r'1803716736b28f5f5b61eb6aa2978e13bd1b0e19';

@ProviderFor(getConditionAssetUploadSignatureUseCase)
final getConditionAssetUploadSignatureUseCaseProvider =
    GetConditionAssetUploadSignatureUseCaseProvider._();

final class GetConditionAssetUploadSignatureUseCaseProvider
    extends
        $FunctionalProvider<
          GetConditionAssetUploadSignatureUseCase,
          GetConditionAssetUploadSignatureUseCase,
          GetConditionAssetUploadSignatureUseCase
        >
    with $Provider<GetConditionAssetUploadSignatureUseCase> {
  GetConditionAssetUploadSignatureUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getConditionAssetUploadSignatureUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$getConditionAssetUploadSignatureUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetConditionAssetUploadSignatureUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetConditionAssetUploadSignatureUseCase create(Ref ref) {
    return getConditionAssetUploadSignatureUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetConditionAssetUploadSignatureUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<GetConditionAssetUploadSignatureUseCase>(value),
    );
  }
}

String _$getConditionAssetUploadSignatureUseCaseHash() =>
    r'cf44d2110396082f3f2692ee060f445f00729eb2';

@ProviderFor(approveConditionAssetUseCase)
final approveConditionAssetUseCaseProvider =
    ApproveConditionAssetUseCaseProvider._();

final class ApproveConditionAssetUseCaseProvider
    extends
        $FunctionalProvider<
          ApproveConditionAssetUseCase,
          ApproveConditionAssetUseCase,
          ApproveConditionAssetUseCase
        >
    with $Provider<ApproveConditionAssetUseCase> {
  ApproveConditionAssetUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'approveConditionAssetUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$approveConditionAssetUseCaseHash();

  @$internal
  @override
  $ProviderElement<ApproveConditionAssetUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApproveConditionAssetUseCase create(Ref ref) {
    return approveConditionAssetUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApproveConditionAssetUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApproveConditionAssetUseCase>(value),
    );
  }
}

String _$approveConditionAssetUseCaseHash() =>
    r'ddf53def544bb28ed908d54a97c4f4b8d1492a97';

@ProviderFor(rejectConditionAssetUseCase)
final rejectConditionAssetUseCaseProvider =
    RejectConditionAssetUseCaseProvider._();

final class RejectConditionAssetUseCaseProvider
    extends
        $FunctionalProvider<
          RejectConditionAssetUseCase,
          RejectConditionAssetUseCase,
          RejectConditionAssetUseCase
        >
    with $Provider<RejectConditionAssetUseCase> {
  RejectConditionAssetUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rejectConditionAssetUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rejectConditionAssetUseCaseHash();

  @$internal
  @override
  $ProviderElement<RejectConditionAssetUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RejectConditionAssetUseCase create(Ref ref) {
    return rejectConditionAssetUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RejectConditionAssetUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RejectConditionAssetUseCase>(value),
    );
  }
}

String _$rejectConditionAssetUseCaseHash() =>
    r'ce6d9538ade2b9a66e00882256248942db8eaa8e';

@ProviderFor(markNotificationsAsReadUseCase)
final markNotificationsAsReadUseCaseProvider =
    MarkNotificationsAsReadUseCaseProvider._();

final class MarkNotificationsAsReadUseCaseProvider
    extends
        $FunctionalProvider<
          MarkNotificationsAsReadUseCase,
          MarkNotificationsAsReadUseCase,
          MarkNotificationsAsReadUseCase
        >
    with $Provider<MarkNotificationsAsReadUseCase> {
  MarkNotificationsAsReadUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'markNotificationsAsReadUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$markNotificationsAsReadUseCaseHash();

  @$internal
  @override
  $ProviderElement<MarkNotificationsAsReadUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MarkNotificationsAsReadUseCase create(Ref ref) {
    return markNotificationsAsReadUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarkNotificationsAsReadUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarkNotificationsAsReadUseCase>(
        value,
      ),
    );
  }
}

String _$markNotificationsAsReadUseCaseHash() =>
    r'82d183af960e48158ae4a8f5ff64ffc8b600fb36';

@ProviderFor(markAllNotificationsAsReadUseCase)
final markAllNotificationsAsReadUseCaseProvider =
    MarkAllNotificationsAsReadUseCaseProvider._();

final class MarkAllNotificationsAsReadUseCaseProvider
    extends
        $FunctionalProvider<
          MarkAllNotificationsAsReadUseCase,
          MarkAllNotificationsAsReadUseCase,
          MarkAllNotificationsAsReadUseCase
        >
    with $Provider<MarkAllNotificationsAsReadUseCase> {
  MarkAllNotificationsAsReadUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'markAllNotificationsAsReadUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$markAllNotificationsAsReadUseCaseHash();

  @$internal
  @override
  $ProviderElement<MarkAllNotificationsAsReadUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MarkAllNotificationsAsReadUseCase create(Ref ref) {
    return markAllNotificationsAsReadUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarkAllNotificationsAsReadUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarkAllNotificationsAsReadUseCase>(
        value,
      ),
    );
  }
}

String _$markAllNotificationsAsReadUseCaseHash() =>
    r'43a3df3c2f5d6bc752615d7a9fddc601adac205a';
