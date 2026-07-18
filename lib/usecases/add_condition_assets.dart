import 'dart:async';

import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/usecase.dart';
import 'package:adehun_mvp/domain/condition_repository.dart';
import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/usecases/params/add_condition_assets_params.dart';

class AddConditionAssetsUseCase
    implements
        UseCase<DataState<List<AssetsResponse>>, AddConditionAssetsParams> {
  final ConditionRepository conditionRepository;

  AddConditionAssetsUseCase(this.conditionRepository);

  @override
  Future<DataState<List<AssetsResponse>>> call({
    AddConditionAssetsParams? params,
  }) async {
    return await conditionRepository.addConditionAssets(
      conditionId: params!.conditionId,
      files: params.files,
    );
  }
}
