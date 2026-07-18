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
    extends $AsyncNotifierProvider<AssetsController, AssetState> {
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
}

String _$assetsControllerHash() => r'865927e3e5306ca9a8fa6d6dc6a3a2e564fa0b7b';

abstract class _$AssetsController extends $AsyncNotifier<AssetState> {
  FutureOr<AssetState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AssetState>, AssetState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AssetState>, AssetState>,
              AsyncValue<AssetState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
