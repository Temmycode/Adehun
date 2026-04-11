// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AgreementState {
  final List<AgreementResponse> agreements;
  final AgreementResponse? selectedAgreement;
  final bool isAccepting;
  final bool isCreating;

  const AgreementState({
    this.agreements = const [],
    this.selectedAgreement,
    this.isAccepting = false,
    this.isCreating = false,
  });

  AgreementState copyWith({
    List<AgreementResponse>? agreements,
    AgreementResponse? selectedAgreement,
    bool? isAccepting,
    bool? isCreating,
  }) {
    return AgreementState(
      agreements: agreements ?? this.agreements,
      selectedAgreement: selectedAgreement ?? this.selectedAgreement,
      isAccepting: isAccepting ?? this.isAccepting,
      isCreating: isCreating ?? this.isCreating,
    );
  }
}
