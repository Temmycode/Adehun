import 'dart:async';

import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/usecase.dart';
import 'package:adehun_mvp/domain/condition_repository.dart';
import 'package:adehun_mvp/domain/models/assets_response.dart';

class GetConditionAssetsUseCase
    implements UseCase<DataState<List<AssetsResponse>>, String> {
  final ConditionRepository conditionRepository;

  GetConditionAssetsUseCase(this.conditionRepository);

  @override
  Future<DataState<List<AssetsResponse>>> call({String? params}) async {
    return await conditionRepository.getConditionAssets(params!);
  }
}
