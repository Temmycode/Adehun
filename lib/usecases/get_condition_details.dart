import 'package:adehun_mvp/domain/condition_repository.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/usecase.dart';

class GetConditionDetailsUseCase
    implements UseCase<DataState<ConditionResponse>, String> {
  final ConditionRepository conditionRepository;

  GetConditionDetailsUseCase(this.conditionRepository);

  @override
  Future<DataState<ConditionResponse>> call({String? params}) async {
    return await conditionRepository.getConditionDetails(params!);
  }
}
