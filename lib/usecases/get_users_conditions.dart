import 'dart:async';

import 'package:adehun_mvp/domain/condition_repository.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/usecase.dart';

class GetAgreementConditionsUseCase
    implements UseCase<DataState<List<ConditionResponse>>, String> {
  final ConditionRepository conditionRepository;

  GetAgreementConditionsUseCase(this.conditionRepository);

  @override
  Future<DataState<List<ConditionResponse>>> call({String? params}) async {
    return await conditionRepository.getAgreementConditions(params!);
  }
}
