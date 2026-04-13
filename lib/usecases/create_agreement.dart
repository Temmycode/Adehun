import 'package:adehun_mvp/domain/agreement_repository.dart';
import 'package:adehun_mvp/domain/models/agreement_create_response.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/resources/usecase.dart';
import 'package:adehun_mvp/usecases/params/create_agreement_params.dart';

class CreateAgreementUseCase
    implements
        UseCase<DataState<AgreementCreateResponse>, CreateAgreementParams> {
  final AgreementRepository agreementRepository;

  CreateAgreementUseCase(this.agreementRepository);

  @override
  Future<DataState<AgreementCreateResponse>> call({
    CreateAgreementParams? params,
  }) async {
    return await agreementRepository.createAgreement(
      otherParticipantEmailOrPhone: params!.otherParticipantEmailOrPhone,
      role: params.role,
      title: params.title,
      description: params.description,
      amount: params.amount,
      conditions: params.conditions.map((c) => c.toJson()).toList(),
    );
  }
}
