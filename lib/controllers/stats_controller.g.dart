// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StatsController)
final statsControllerProvider = StatsControllerProvider._();

final class StatsControllerProvider
    extends $AsyncNotifierProvider<StatsController, AgreementStatsResponse> {
  StatsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statsControllerHash();

  @$internal
  @override
  StatsController create() => StatsController();
}

String _$statsControllerHash() => r'bee11281e77a622fff9185b7cbfee85494dfc6b0';

abstract class _$StatsController
    extends $AsyncNotifier<AgreementStatsResponse> {
  FutureOr<AgreementStatsResponse> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<AgreementStatsResponse>, AgreementStatsResponse>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<AgreementStatsResponse>,
                AgreementStatsResponse
              >,
              AsyncValue<AgreementStatsResponse>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
