import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class ConditionState {
  final Map<String, List<ConditionResponse>>
  conditions; // {"id": [...] // list of conditions}
  final ConditionResponse? selectedCondition;
  final bool isLoading;
  final bool isAdding;
  final bool isApproving;
  final bool isRejecting;
  final String? errorMessage;

  const ConditionState({
    this.conditions = const {},
    this.selectedCondition,
    this.isLoading = false,
    this.isAdding = false,
    this.isApproving = false,
    this.isRejecting = false,
    this.errorMessage,
  });

  List<ConditionResponse> conditionsFor(String agreementId) =>
      conditions[agreementId] ?? const [];

  ConditionState copyWith({
    Map<String, List<ConditionResponse>>? conditions,
    ConditionResponse? Function()?
    selectedCondition, // Function wrap allows passing explicit null
    bool? isLoading,
    bool? isAdding,
    bool? isApproving,
    bool? isRejecting,
    String? Function()? errorMessage,
  }) {
    return ConditionState(
      conditions: conditions ?? this.conditions,
      selectedCondition: selectedCondition != null
          ? selectedCondition()
          : this.selectedCondition,
      isLoading: isLoading ?? this.isLoading,
      isAdding: isAdding ?? this.isAdding,
      isApproving: isApproving ?? this.isApproving,
      isRejecting: isRejecting ?? this.isRejecting,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
