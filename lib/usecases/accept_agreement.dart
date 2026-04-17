import 'package:adehun_mvp/domain/agreement_repository.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/usecase.dart';

class AcceptAgreementUseCase
    implements UseCase<DataState<AgreementResponse>, String> {
  final AgreementRepository agreementRepository;

  AcceptAgreementUseCase(this.agreementRepository);

  @override
  Future<DataState<AgreementResponse>> call({String? params}) async {
    return await agreementRepository.acceptAgreement(params!);
  }
}
