import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';

abstract class ConditionRepository {
  Future<DataState<ConditionResponse>> addConditionToAgreement({
    required String agreementId,
    required String title,
    required String description,
    required String requiredFromEmail,
  });

  Future<DataState<List<ConditionResponse>>> getUsersConditions();

  Future<DataState<ConditionResponse>> getConditionDetails(String conditionId);

  Future<DataState<ConditionResponse>> approveCondition(String conditionId);

  Future<DataState<ConditionResponse>> rejectCondition({
    required String conditionId,
    required String rejectedReason,
  });
}
