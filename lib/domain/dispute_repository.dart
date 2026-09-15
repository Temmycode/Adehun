import 'package:adehun_mvp/constants/dispute_enums.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/domain/models/dispute_response.dart';
import 'package:adehun_mvp/domain/models/upload_signature_response.dart';

abstract class DisputeRepository {
  Future<DataState<UploadSignatureResponse>> getDisputeUploadSignature(
    String agreementId,
  );

  Future<DataState<DisputeResponse>> raiseDispute({
    required String agreementId,
    required DisputeCategory category,
    required String description,
    required List<Map<String, dynamic>> files,
  });

  Future<DataState<List<DisputeResponse>>> getAgreementDisputes(
    String agreementId,
  );
}
