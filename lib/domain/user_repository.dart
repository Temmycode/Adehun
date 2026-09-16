import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/domain/models/upload_signature_response.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';

abstract class UserRepository {
  Future<DataState<UserData>> getCurrentUser();

  Future<DataState<UserData>> updateProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? profilePictureUrl,
  });

  Future<DataState<UploadSignatureResponse>> getProfileUploadSignature();
}
