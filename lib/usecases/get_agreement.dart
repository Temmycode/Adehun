import 'package:adehun_mvp/domain/agreement_repository.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/resources/usecase.dart';

class GetAgreementUseCase
    implements UseCase<DataState<AgreementResponse>, String> {
  final AgreementRepository agreementRepository;

  GetAgreementUseCase(this.agreementRepository);

  @override
  Future<DataState<AgreementResponse>> call({String? params}) async {
    return await agreementRepository.getAgreement(params!);
  }
}
