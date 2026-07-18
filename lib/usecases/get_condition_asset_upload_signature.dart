import 'dart:async';

import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/usecase.dart';
import 'package:adehun_mvp/domain/condition_repository.dart';
import 'package:adehun_mvp/domain/models/upload_signature_response.dart';

class GetConditionAssetUploadSignatureUseCase
    implements UseCase<DataState<UploadSignatureResponse>, String> {
  final ConditionRepository conditionRepository;

  GetConditionAssetUploadSignatureUseCase(this.conditionRepository);

  @override
  Future<DataState<UploadSignatureResponse>> call({String? params}) async {
    return await conditionRepository.getConditionAssetUploadSignature(params!);
  }
}
