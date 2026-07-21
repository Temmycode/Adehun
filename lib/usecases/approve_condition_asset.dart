import 'package:adehun_mvp/domain/condition_repository.dart';
import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/usecase.dart';
import 'package:adehun_mvp/usecases/params/approve_condition_asset_params.dart';

class ApproveConditionAssetUseCase
    implements UseCase<DataState<AssetsResponse>, ApproveConditionAssetParams> {
  final ConditionRepository conditionRepository;

  ApproveConditionAssetUseCase(this.conditionRepository);

  @override
  Future<DataState<AssetsResponse>> call({
    ApproveConditionAssetParams? params,
  }) async {
    return await conditionRepository.approveConditionAsset(
      conditionId: params!.conditionId,
      assetId: params.assetId,
    );
  }
}
