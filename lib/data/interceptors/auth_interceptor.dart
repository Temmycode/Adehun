import 'dart:developer';

import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/core/network/api_response.dart';
import 'package:adehun_mvp/data/interceptors/api_response_interceptor.dart';
import 'package:adehun_mvp/data/local/token_storage.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends QueuedInterceptor {
  final TokenStorage _tokenStorage;
  final Dio _refreshDio;
  final void Function()? onSessionExpired;

  static const _authPaths = [
    '/auth/login',
    '/auth/register',
    '/auth/register-from-invite',
    '/auth/refresh',
  ];

  AuthInterceptor(
    TokenStorage tokenStorage, {
    this.onSessionExpired,
  })  : _tokenStorage = tokenStorage,
        _refreshDio = Dio() {
    // Unwrap the envelope on the refresh response too, so we can read
    // `access_token` / `refresh_token` directly from the data payload.
    _refreshDio.interceptors.add(ApiResponseInterceptor());
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isAuthEndpoint =
        _authPaths.any((path) => options.path.contains(path));

    if (!isAuthEndpoint) {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Branch on the envelope's error code first, fall back to HTTP 401
    // for legacy endpoints or network errors that never hit the envelope.
    final apiError = err.error;
    final isUnauthorized = apiError is ApiError
        ? apiError.code == 'UNAUTHORIZED'
        : err.response?.statusCode == 401;

    if (!isUnauthorized) {
      return handler.next(err);
    }

    final isAuthEndpoint =
        _authPaths.any((path) => err.requestOptions.path.contains(path));
    if (isAuthEndpoint) {
      return handler.next(err);
    }

    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) {
      log('[AuthInterceptor] No refresh token found, skipping refresh');
      onSessionExpired?.call();
      return handler.next(err);
    }

    try {
      log('[AuthInterceptor] Attempting token refresh...');
      final response = await _refreshDio.post(
        '$baseUrl$refreshUrl',
        data: {'refresh_token': refreshToken},
      );

      log('[AuthInterceptor] Refresh response: ${response.statusCode}');

      final newAccessToken = response.data['access_token'] as String?;
      final newRefreshToken = response.data['refresh_token'] as String?;

      if (newAccessToken == null || newRefreshToken == null) {
        log('[AuthInterceptor] Refresh returned null tokens');
        await _tokenStorage.clearTokens();
        onSessionExpired?.call();
        return handler.next(err);
      }

      await _tokenStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      log('[AuthInterceptor] Tokens refreshed, retrying request');

      // Retry the original request with the new token
      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer $newAccessToken';

      final retryResponse = await _refreshDio.fetch(options);
      return handler.resolve(retryResponse);
    } on DioException catch (e) {
      final refreshApiError = e.error;
      if (refreshApiError is ApiError) {
        log('[AuthInterceptor] Refresh failed: ${refreshApiError.code} - ${refreshApiError.message}');
      } else {
        log('[AuthInterceptor] Refresh failed: ${e.response?.statusCode} - ${e.response?.data}');
      }
      await _tokenStorage.clearTokens();
      onSessionExpired?.call();
      return handler.next(err);
    }
  }
}
