import 'dart:developer';

import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/core/network/api_response.dart';
import 'package:adehun_mvp/data/interceptors/api_response_interceptor.dart';
import 'package:adehun_mvp/data/local/token_storage.dart';
import 'package:dio/dio.dart';

/// Attaches the bearer token and transparently refreshes it on 401.
///
/// A [QueuedInterceptor], so `onError` runs one request at a time: a burst of
/// 401s results in exactly one refresh, and the queued requests retry with the
/// new token. Refresh tokens rotate server-side, which is why a second refresh
/// with the same token must never be attempted.
class AuthInterceptor extends QueuedInterceptor {
  final TokenStorage _tokenStorage;
  final Dio _refreshDio;
  final Future<void> Function()? onSessionExpired;

  /// Endpoints that must never carry (or trigger a refresh for) a bearer.
  /// `/auth/register` is NOT here: completing a profile is an authenticated
  /// call so nobody can rewrite another account's name and phone.
  static const _authPaths = [
    '/auth/login',
    '/auth/register-from-invite',
    '/auth/refresh',
  ];

  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 30);
  static const sendTimeout = Duration(seconds: 30);

  AuthInterceptor(
    TokenStorage tokenStorage, {
    this.onSessionExpired,
    Dio? refreshDio,
  }) : _tokenStorage = tokenStorage,
       _refreshDio =
           refreshDio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl,
               connectTimeout: connectTimeout,
               receiveTimeout: receiveTimeout,
               sendTimeout: sendTimeout,
             ),
           ) {
    // Unwrap the envelope on the refresh response too, so we can read
    // `access_token` / `refresh_token` directly from the data payload.
    if (refreshDio == null) {
      _refreshDio.interceptors.add(ApiResponseInterceptor());
    }
  }

  Future<void> _expireSession() async {
    await _tokenStorage.clearTokens();
    if (onSessionExpired != null) {
      await onSessionExpired!();
    }
  }

  Future<void> _refreshTokens(String refreshToken) async {
    final response = await _refreshDio.post(
      refreshUrl,
      data: {'refresh_token': refreshToken},
    );

    final data = response.data;
    final newAccessToken = data is Map ? data['access_token'] as String? : null;
    final newRefreshToken = data is Map ? data['refresh_token'] as String? : null;

    if (newAccessToken == null || newRefreshToken == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }

    await _tokenStorage.saveTokens(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    );
  }

  bool _isAuthEndpoint(RequestOptions options) {
    final path = options.uri.path;
    return _authPaths.any((p) => path.endsWith(p) || options.path.endsWith(p));
  }

  bool _isNetworkFailure(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return e.type == DioExceptionType.unknown && e.response == null;
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requestUri = options.uri;
    final backendUri = Uri.parse(baseUrl);
    final isBackendRequest =
        requestUri.origin == backendUri.origin ||
        requestUri.toString().startsWith(baseUrl);

    if (isBackendRequest && !_isAuthEndpoint(options)) {
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

    if (!isUnauthorized || _isAuthEndpoint(err.requestOptions)) {
      return handler.next(err);
    }

    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) {
      await _expireSession();
      return handler.next(err);
    }

    try {
      await _refreshTokens(refreshToken);
    } on DioException catch (e) {
      if (_isNetworkFailure(e)) {
        // The refresh token may still be perfectly valid; do not log the user
        // out because the network blinked. Surface the original failure.
        log('[AuthInterceptor] refresh skipped: network failure');
        return handler.next(err);
      }
      log('[AuthInterceptor] refresh rejected (${e.response?.statusCode})');
      await _expireSession();
      return handler.next(err);
    } catch (e) {
      log('[AuthInterceptor] refresh failed unexpectedly: ${e.runtimeType}');
      await _expireSession();
      return handler.next(err);
    }

    final newAccessToken = await _tokenStorage.getAccessToken();
    if (newAccessToken == null) {
      await _expireSession();
      return handler.next(err);
    }

    try {
      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer $newAccessToken';
      if (options.baseUrl.isEmpty) {
        options.baseUrl = _refreshDio.options.baseUrl;
      }
      final retryResponse = await _refreshDio.fetch(options);
      return handler.resolve(retryResponse);
    } on DioException catch (e) {
      // A second 401 with a brand-new token means the account itself is no
      // longer valid; anything else is the request's own problem.
      if (e.response?.statusCode == 401) {
        await _expireSession();
      }
      return handler.next(e);
    }
  }
}
