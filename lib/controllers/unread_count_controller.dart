import 'dart:async';

import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unread_count_controller.g.dart';

@Riverpod(keepAlive: true)
class UnreadCountController extends _$UnreadCountController {
  Timer? _poll;

  @override
  FutureOr<int> build() async {
    ref.onDispose(() {
      _poll?.cancel();
      _poll = null;
    });
    _poll ??= Timer.periodic(
      const Duration(seconds: 60),
      (_) => refresh(),
    );
    return _fetch();
  }

  Future<int> _fetch() async {
    final useCase = ref.read(getUnreadCountUseCaseProvider);
    final result = await useCase();

    if (result is DataSuccess<int> && result.data != null) {
      return result.data!;
    }

    if (result.exception != null) throw result.exception!;
    return 0;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  void decrementBy(int n) {
    if (n <= 0) return;
    state.whenData((current) {
      final next = (current - n).clamp(0, 1 << 31);
      state = AsyncData(next);
    });
  }

  void markAllRead() {
    state = const AsyncData(0);
  }
}
