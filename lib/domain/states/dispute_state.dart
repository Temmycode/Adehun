import 'package:adehun_mvp/domain/models/dispute_response.dart';
import 'package:flutter/foundation.dart' show immutable;

/// Keyed by agreement id so the deferred surfaces (My Disputes, dispute detail,
/// add evidence) can be added as extra fields without reshaping what's here.
@immutable
class DisputeState {
  final Map<String, List<DisputeResponse>>
  disputes; // {"agreement_id": [...] // list of disputes}
  final bool isLoading;
  final bool isRaising;
  final String? errorMessage;

  const DisputeState({
    this.disputes = const {},
    this.isLoading = false,
    this.isRaising = false,
    this.errorMessage,
  });

  List<DisputeResponse> disputesFor(String agreementId) =>
      disputes[agreementId] ?? const [];

  /// Whether the agreement already has a dispute being worked, which is what
  /// makes the server reject a second one with a 409.
  bool hasLiveDispute(String agreementId) =>
      disputesFor(agreementId).any((dispute) => dispute.isLive);

  DisputeState copyWith({
    Map<String, List<DisputeResponse>>? disputes,
    bool? isLoading,
    bool? isRaising,
    String? Function()?
    errorMessage, // Function wrap allows passing explicit null
  }) {
    return DisputeState(
      disputes: disputes ?? this.disputes,
      isLoading: isLoading ?? this.isLoading,
      isRaising: isRaising ?? this.isRaising,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
