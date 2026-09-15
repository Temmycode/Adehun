import 'package:adehun_mvp/core/network/api_response.dart';
import 'package:adehun_mvp/data/interceptors/api_response_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://api.test'));
    adapter = DioAdapter(dio: dio);
    dio.interceptors.add(ApiResponseInterceptor());
  });

  test('unwraps the success envelope', () async {
    adapter.onGet(
      '/thing',
      (server) => server.reply(200, {
        'success': true,
        'data': {'id': '1'},
        'message': 'ok',
      }),
    );
    final response = await dio.get('/thing');
    expect(response.data, {'id': '1'});
  });

  test('rejects a 200 with success=false carrying the ApiError', () async {
    adapter.onGet(
      '/thing',
      (server) => server.reply(200, {
        'success': false,
        'error': {'code': 'CONFLICT', 'message': 'nope'},
      }),
    );
    try {
      await dio.get('/thing');
      fail('expected a DioException');
    } on DioException catch (e) {
      final error = e.error;
      expect(error, isA<ApiError>());
      expect((error as ApiError).code, 'CONFLICT');
      expect(error.message, 'nope');
    }
  });

  test('attaches ApiError to 4xx envelopes in onError', () async {
    adapter.onGet(
      '/thing',
      (server) => server.reply(403, {
        'success': false,
        'error': {'code': 'WITHDRAWALS_DISABLED', 'message': 'off'},
      }),
    );
    try {
      await dio.get('/thing');
      fail('expected a DioException');
    } on DioException catch (e) {
      expect(e.response?.statusCode, 403);
      expect((e.error as ApiError).code, 'WITHDRAWALS_DISABLED');
    }
  });

  test('passes non-envelope bodies through untouched', () async {
    adapter.onGet('/raw', (server) => server.reply(200, {'plain': true}));
    final response = await dio.get('/raw');
    expect(response.data, {'plain': true});
  });
}
