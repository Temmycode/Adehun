import 'package:adehun_mvp/domain/condition_repository.dart';
import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/usecase.dart';
import 'package:adehun_mvp/usecases/params/reject_condition_asset_params.dart';

class RejectConditionAssetUseCase
    implements UseCase<DataState<AssetsResponse>, RejectConditionAssetParams> {
  final ConditionRepository conditionRepository;

  RejectConditionAssetUseCase(this.conditionRepository);

  @override
  Future<DataState<AssetsResponse>> call({
    RejectConditionAssetParams? params,
  }) async {
    return await conditionRepository.rejectConditionAsset(
      conditionId: params!.conditionId,
      assetId: params.assetId,
    );
  }
}
