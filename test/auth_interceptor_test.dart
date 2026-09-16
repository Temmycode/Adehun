import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/data/interceptors/api_response_interceptor.dart';
import 'package:adehun_mvp/data/interceptors/auth_interceptor.dart';
import 'package:adehun_mvp/data/local/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

/// In-memory stand-in; the platform keychain is never touched.
class FakeTokenStorage extends TokenStorage {
  String? access;
  String? refresh;

  FakeTokenStorage({this.access, this.refresh})
    : super(const FlutterSecureStorage());

  @override
  Future<String?> getAccessToken() async => access;

  @override
  Future<String?> getRefreshToken() async => refresh;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    access = accessToken;
    refresh = refreshToken;
  }

  @override
  Future<void> clearTokens() async {
    access = null;
    refresh = null;
  }
}

Map<String, dynamic> _unauthorized() => {
  'success': false,
  'error': {'code': 'UNAUTHORIZED', 'message': 'Could not validate credentials'},
};

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late Dio refreshDio;
  late DioAdapter refreshAdapter;
  late FakeTokenStorage storage;
  late int expiredCalls;

  setUp(() {
    expiredCalls = 0;
    storage = FakeTokenStorage(access: 'old-access', refresh: 'old-refresh');

    refreshDio = Dio(BaseOptions(baseUrl: baseUrl));
    refreshAdapter = DioAdapter(dio: refreshDio);
    refreshDio.interceptors.add(ApiResponseInterceptor());

    dio = Dio(BaseOptions(baseUrl: baseUrl));
    adapter = DioAdapter(dio: dio);
    dio.interceptors.add(ApiResponseInterceptor());
    dio.interceptors.add(
      AuthInterceptor(
        storage,
        refreshDio: refreshDio,
        onSessionExpired: () async => expiredCalls++,
      ),
    );
  });

  test('attaches the bearer to API requests but not to login', () async {
    adapter.onGet(
      '/users/current',
      (server) => server.reply(200, {'success': true, 'data': {'id': 'me'}}),
      headers: {'Authorization': 'Bearer old-access'},
    );
    final response = await dio.get('/users/current');
    expect(response.data, {'id': 'me'});

    adapter.onPost(
      '/auth/login',
      (server) => server.reply(200, {'success': true, 'data': {}}),
      data: {'id_token': 'x'},
    );
    final login = await dio.post('/auth/login', data: {'id_token': 'x'});
    expect(login.requestOptions.headers.containsKey('Authorization'), isFalse);
  });

  test('401 -> refresh -> retry with the new token', () async {
    adapter.onGet('/users/current', (server) => server.reply(401, _unauthorized()));
    refreshAdapter.onPost(
      refreshUrl,
      (server) => server.reply(200, {
        'success': true,
        'data': {'access_token': 'new-access', 'refresh_token': 'new-refresh'},
      }),
      data: {'refresh_token': 'old-refresh'},
    );
    refreshAdapter.onGet(
      '/users/current',
      (server) => server.reply(200, {'success': true, 'data': {'id': 'me'}}),
      headers: {'Authorization': 'Bearer new-access'},
    );

    final response = await dio.get('/users/current');
    expect(response.data, {'id': 'me'});
    expect(storage.access, 'new-access');
    expect(storage.refresh, 'new-refresh');
    expect(expiredCalls, 0);
  });

  test('a rejected refresh expires the session exactly once', () async {
    adapter.onGet('/users/current', (server) => server.reply(401, _unauthorized()));
    refreshAdapter.onPost(
      refreshUrl,
      (server) => server.reply(401, _unauthorized()),
      data: {'refresh_token': 'old-refresh'},
    );

    await expectLater(dio.get('/users/current'), throwsA(isA<DioException>()));
    expect(expiredCalls, 1);
    expect(storage.access, isNull);
    expect(storage.refresh, isNull);
  });

  test('a network failure during refresh does not sign the user out', () async {
    adapter.onGet('/users/current', (server) => server.reply(401, _unauthorized()));
    refreshAdapter.onPost(
      refreshUrl,
      (server) => server.throws(
        0,
        DioException(
          requestOptions: RequestOptions(path: refreshUrl),
          type: DioExceptionType.connectionError,
        ),
      ),
      data: {'refresh_token': 'old-refresh'},
    );

    await expectLater(dio.get('/users/current'), throwsA(isA<DioException>()));
    expect(expiredCalls, 0);
    expect(storage.refresh, 'old-refresh');
  });

  test('no refresh token means immediate session expiry', () async {
    storage.refresh = null;
    adapter.onGet('/users/current', (server) => server.reply(401, _unauthorized()));
    await expectLater(dio.get('/users/current'), throwsA(isA<DioException>()));
    expect(expiredCalls, 1);
  });

  test('register carries the bearer (profile completion is authenticated)', () async {
    adapter.onPost(
      '/auth/register',
      (server) => server.reply(201, {'success': true, 'data': {'id': 'me'}}),
      data: {'name': 'Ada'},
      headers: {'Authorization': 'Bearer old-access'},
    );
    final response = await dio.post('/auth/register', data: {'name': 'Ada'});
    expect(response.data, {'id': 'me'});
  });
}
