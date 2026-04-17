import 'package:adehun_mvp/domain/condition_repository.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/usecase.dart';
import 'package:adehun_mvp/usecases/params/add_condition_params.dart';

class AddConditionToAgreementUseCase
    implements UseCase<DataState<ConditionResponse>, AddConditionParams> {
  final ConditionRepository conditionRepository;

  AddConditionToAgreementUseCase(this.conditionRepository);

  @override
  Future<DataState<ConditionResponse>> call({
    AddConditionParams? params,
  }) async {
    return await conditionRepository.addConditionToAgreement(
      agreementId: params!.agreementId,
      title: params.title,
      description: params.description,
      requiredFromEmail: params.requiredFromEmail,
    );
  }
}
