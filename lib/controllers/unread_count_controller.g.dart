// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_count_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UnreadCountController)
final unreadCountControllerProvider = UnreadCountControllerProvider._();

final class UnreadCountControllerProvider
    extends $AsyncNotifierProvider<UnreadCountController, int> {
  UnreadCountControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadCountControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadCountControllerHash();

  @$internal
  @override
  UnreadCountController create() => UnreadCountController();
}

String _$unreadCountControllerHash() =>
    r'175e40653070e33b9d0fb1ad12e741e73fd504fa';

abstract class _$UnreadCountController extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
