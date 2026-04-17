import 'package:adehun_mvp/core/network/api_response.dart';
import 'package:dio/dio.dart';

/// Unwraps the standardized API envelope for every response.
///
/// Success: `{ success: true, data: <payload>, message?: String }`
///   → replaces `response.data` with just `<payload>`
///
/// Error: `{ success: false, error: { code, message } }`
///   → rejects with a [DioException] whose `error` field is an [ApiError]
///
/// For HTTP error statuses (4xx/5xx), the envelope is parsed in [onError]
/// and attached to the existing [DioException] so downstream interceptors
/// (auth refresh, repositories, controllers) can branch on `error.code`.
///
/// Bodies that don't look like the envelope (e.g. 204 No Content, legacy
/// endpoints) are passed through untouched.
class ApiResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;

    if (data is Map<String, dynamic> && data.containsKey('success')) {
      if (data['success'] == true) {
        response.data = data['data'];
        handler.next(response);
      } else {
        final errorJson = data['error'] as Map<String, dynamic>;
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: ApiError.fromJson(errorJson),
            type: DioExceptionType.badResponse,
          ),
        );
      }
    } else {
      handler.next(response);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final data = err.response?.data;

    if (data is Map<String, dynamic> &&
        data['success'] == false &&
        data['error'] is Map<String, dynamic>) {
      final apiError = ApiError.fromJson(data['error'] as Map<String, dynamic>);
      handler.next(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: apiError,
          type: err.type,
          stackTrace: err.stackTrace,
          message: err.message,
        ),
      );
    } else {
      handler.next(err);
    }
  }
}
