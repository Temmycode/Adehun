import 'package:adehun_mvp/data/local/token_storage.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  static const _authPaths = [
    '/auth/login',
    '/auth/register',
    '/auth/register-from-invite',
    '/auth/refresh',
  ];

  AuthInterceptor(TokenStorage tokenStorage) : _tokenStorage = tokenStorage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isAuthEndpoint = _authPaths.any((path) => options.path.contains(path));

    if (!isAuthEndpoint) {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    handler.next(options);
  }
}
