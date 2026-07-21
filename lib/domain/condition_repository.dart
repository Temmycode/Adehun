import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/domain/models/upload_signature_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';

abstract class ConditionRepository {
  Future<DataState<ConditionResponse>> addConditionToAgreement({
    required String agreementId,
    required String title,
    required String description,
    required String requiredFromEmail,
  });

  Future<DataState<List<ConditionResponse>>> getAgreementConditions(
    String agreementId,
  );

  Future<DataState<ConditionResponse>> getConditionDetails(String conditionId);

  Future<DataState<ConditionResponse>> approveCondition(String conditionId);

  Future<DataState<ConditionResponse>> rejectCondition({
    required String conditionId,
    required String rejectedReason,
  });

  Future<DataState<List<AssetsResponse>>> getConditionAssets(
    String conditionId,
  );

  Future<DataState<List<AssetsResponse>>> addConditionAssets({
    required String conditionId,
    required List<Map<String, dynamic>> files,
  });

  Future<DataState<AssetsResponse>> approveConditionAsset({
    required String conditionId,
    required String assetId,
  });

  Future<DataState<AssetsResponse>> rejectConditionAsset({
    required String conditionId,
    required String assetId,
  });

  Future<DataState<UploadSignatureResponse>> getConditionAssetUploadSignature(
    String conditionId,
  );
}
