import 'package:adehun_mvp/domain/agreement_repository.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/resources/usecase.dart';
import 'package:adehun_mvp/usecases/params/create_agreement_params.dart';

class CreateAgreementUseCase
    implements UseCase<DataState<AgreementResponse>, CreateAgreementParams> {
  final AgreementRepository agreementRepository;

  CreateAgreementUseCase(this.agreementRepository);

  @override
  Future<DataState<AgreementResponse>> call({
    CreateAgreementParams? params,
  }) async {
    return await agreementRepository.createAgreement(
      participantEmail: params!.participantEmail,
      role: params.role,
      title: params.title,
      description: params.description,
      amount: params.amount,
    );
  }
}
