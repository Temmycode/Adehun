import 'package:adehun_mvp/domain/condition_repository.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/resources/usecase.dart';

class ApproveConditionUseCase
    implements UseCase<DataState<ConditionResponse>, String> {
  final ConditionRepository conditionRepository;

  ApproveConditionUseCase(this.conditionRepository);

  @override
  Future<DataState<ConditionResponse>> call({String? params}) async {
    return await conditionRepository.approveCondition(params!);
  }
}
