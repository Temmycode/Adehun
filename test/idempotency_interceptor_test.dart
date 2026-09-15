import 'package:adehun_mvp/data/interceptors/idempotency_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs [options] through the interceptor and returns the headers it produced.
///
/// The interceptor mutates [options] in place before handing it on, so reading
/// the headers back off it afterwards is what we assert against.
Map<String, dynamic> _run(RequestOptions options) {
  IdempotencyInterceptor().onRequest(options, RequestInterceptorHandler());
  return options.headers;
}

RequestOptions _req(String method, {Map<String, dynamic>? headers}) =>
    RequestOptions(path: '/agreements/x/accept', method: method, headers: headers ?? {});

String? _key(Map<String, dynamic> headers) =>
    headers['Idempotency-Key'] as String?;

void main() {
  // The bug this exists for: POST /accept returns
  // "400 BAD_REQUEST: Idempotency-Key header is required".
  test('adds a key to POST', () {
    expect(_key(_run(_req('POST'))), isNotNull);
  });

  test('adds a key to every other mutating method', () {
    for (final method in ['PUT', 'PATCH', 'DELETE']) {
      expect(_key(_run(_req(method))), isNotNull, reason: '$method got no key');
    }
  });

  test('leaves GET alone', () {
    expect(_key(_run(_req('GET'))), isNull);
  });

  test('generates a valid, distinct uuid per request', () {
    final first = _key(_run(_req('POST')))!;
    final second = _key(_run(_req('POST')))!;

    expect(first, isNot(equals(second)));
    expect(
      RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      ).hasMatch(first),
      isTrue,
      reason: 'not a v4 uuid: $first',
    );
  });

  // Endpoints that set their own key (wallet funding, escrow funding) must keep
  // it — overwriting would break the ledger reference the server dedupes on.
  test('never overwrites a key the caller already set', () {
    final headers = _run(
      _req('POST', headers: {'Idempotency-Key': 'caller-supplied'}),
    );

    expect(_key(headers), 'caller-supplied');
  });

  // Dio's header map is case-insensitive, so a caller using a different casing
  // is still detected and left alone rather than getting a second key.
  test('respects a differently-cased existing header', () {
    final headers = _run(
      _req('POST', headers: {'idempotency-key': 'caller-supplied'}),
    );

    expect(headers['idempotency-key'], 'caller-supplied');
    expect(_key(headers), 'caller-supplied');
  });

  test('lowercase method names still count as mutating', () {
    expect(_key(_run(_req('post'))), isNotNull);
  });
}
