import 'dart:async';

import 'package:adehun_mvp/domain/condition_repository.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/resources/usecase.dart';

class GetUsersConditionsUseCase
    implements UseCase<DataState<List<ConditionResponse>>, void> {
  final ConditionRepository conditionRepository;

  GetUsersConditionsUseCase(this.conditionRepository);

  @override
  Future<DataState<List<ConditionResponse>>> call({void params}) async {
    return await conditionRepository.getUsersConditions();
  }
}
