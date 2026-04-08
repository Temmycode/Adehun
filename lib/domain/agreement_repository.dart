import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/resources/data_state.dart';

abstract class AgreementRepository {
  Future<DataState<List<AgreementResponse>>> getAllUserAgreements();

  Future<DataState<AgreementResponse>> createAgreement({
    required String participantEmail,
    required String role,
    required String title,
    required String description,
    required int amount,
  });

  Future<DataState<AgreementResponse>> acceptAgreement(String agreementId);

  Future<DataState<AgreementResponse>> getAgreement(String agreementId);
}
