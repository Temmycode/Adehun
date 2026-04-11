import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class ConditionState {
  final List<ConditionResponse> conditions;
  final ConditionResponse? selectedCondition;
  final bool isAdding;
  final bool isApproving;
  final bool isRejecting;

  const ConditionState({
    this.conditions = const [],
    this.selectedCondition,
    this.isAdding = false,
    this.isApproving = false,
    this.isRejecting = false,
  });

  ConditionState copyWith({
    List<ConditionResponse>? conditions,
    ConditionResponse? selectedCondition,
    bool? isAdding,
    bool? isApproving,
    bool? isRejecting,
  }) {
    return ConditionState(
      conditions: conditions ?? this.conditions,
      selectedCondition: selectedCondition ?? this.selectedCondition,
      isAdding: isAdding ?? this.isAdding,
      isApproving: isApproving ?? this.isApproving,
      isRejecting: isRejecting ?? this.isRejecting,
    );
  }
}
