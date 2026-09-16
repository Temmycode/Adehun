// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AssetsController)
final assetsControllerProvider = AssetsControllerProvider._();

final class AssetsControllerProvider
    extends $NotifierProvider<AssetsController, AssetState> {
  AssetsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetsControllerHash();

  @$internal
  @override
  AssetsController create() => AssetsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetState>(value),
    );
  }
}

String _$assetsControllerHash() => r'07f6d3d81725f5560adead1a6c07f35f5969e177';

abstract class _$AssetsController extends $Notifier<AssetState> {
  AssetState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AssetState, AssetState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AssetState, AssetState>,
              AssetState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
