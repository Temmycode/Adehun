import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/domain/models/upload_signature_response.dart';
import 'package:dio/dio.dart';

/// Uploads picked files straight to Cloudinary using a server-issued signature.
///
/// Shared by condition assets and dispute evidence — both post the same
/// `{url, type, name, size}` metadata back to our API afterwards.
///
/// The [Dio] here is deliberately its own instance and must never be the app's
/// `dioProvider`: that one carries `AuthInterceptor` (which would send our
/// Bearer token to Cloudinary) and `LogInterceptor(requestBody: true)` (which
/// would dump every multipart byte to the console).
class CloudinaryUploadService {
  final Dio _dio;

  CloudinaryUploadService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              validateStatus: (status) => status != null && status < 500,
            ),
          );

  /// Uploads each file in turn and returns copies carrying the hosted URL.
  ///
  /// Sequential on purpose: a partial failure should stop at the offending
  /// file rather than leave a scattering of orphaned uploads behind.
  Future<List<FileResponse>> uploadFiles(
    UploadSignatureResponse signature,
    List<FileResponse> files,
  ) async {
    final cloudName = signature.cloudName;
    if (cloudName.isEmpty) {
      throw ArgumentError('cloudName is missing in SignedUpload');
    }

    final results = <FileResponse>[];

    for (final file in files) {
      if (file.path == null || file.path!.isEmpty) {
        throw ArgumentError('File path is required for upload');
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path!, filename: file.name),
        'folder': signature.folder,
        'timestamp': signature.timestamp,
        'signature': signature.signature,
        'api_key': signature.apiKey,
      });

      final uploadUrl = 'https://api.cloudinary.com/v1_1/$cloudName/auto/upload';
      final response = await _dio.post(uploadUrl, data: formData);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Cloudinary upload failed: ${response.statusCode} - ${response.data}',
          type: DioExceptionType.badResponse,
        );
      }

      final uploadedUrl =
          response.data['secure_url'] ?? response.data['secureUrl'];
      if (uploadedUrl == null || uploadedUrl is! String || uploadedUrl.isEmpty) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Cloudinary upload returned no secure URL',
          type: DioExceptionType.badResponse,
        );
      }

      results.add(file.copyWith(url: uploadedUrl));
    }

    return results;
  }
}
