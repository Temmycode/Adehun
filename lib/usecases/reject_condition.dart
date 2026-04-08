import 'package:adehun_mvp/domain/condition_repository.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/resources/usecase.dart';
import 'package:adehun_mvp/usecases/params/reject_condition_params.dart';

class RejectConditionUseCase
    implements
        UseCase<DataState<ConditionResponse>, RejectConditionParams> {
  final ConditionRepository conditionRepository;

  RejectConditionUseCase(this.conditionRepository);

  @override
  Future<DataState<ConditionResponse>> call({
    RejectConditionParams? params,
  }) async {
    return await conditionRepository.rejectCondition(
      conditionId: params!.conditionId,
      rejectedReason: params.rejectedReason,
    );
  }
}
