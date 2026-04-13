import 'package:adehun_mvp/domain/models/agreement_create_response.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/resources/data_state.dart';

abstract class AgreementRepository {
  Future<DataState<List<AgreementResponse>>> getAllUserAgreements();

  Future<DataState<AgreementCreateResponse>> createAgreement({
    required String otherParticipantEmailOrPhone,
    required String role,
    required String title,
    required String description,
    required int amount,
    required List<Map<String, dynamic>> conditions,
  });

  Future<DataState<AgreementResponse>> acceptAgreement(String agreementId);

  Future<DataState<AgreementResponse>> getAgreement(String agreementId);
}
