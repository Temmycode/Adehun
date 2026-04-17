import 'dart:async';

import 'package:adehun_mvp/domain/agreement_repository.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/usecase.dart';

class GetAllAgreementsUseCase
    implements UseCase<DataState<List<AgreementResponse>>, void> {
  final AgreementRepository agreementRepository;

  GetAllAgreementsUseCase(this.agreementRepository);

  @override
  Future<DataState<List<AgreementResponse>>> call({void params}) async {
    return await agreementRepository.getAllUserAgreements();
  }
}
