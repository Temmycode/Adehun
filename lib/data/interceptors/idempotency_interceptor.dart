import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

/// Attaches an `Idempotency-Key` to every state-changing request.
///
/// The API rejects several endpoints outright without one — `/accept` returns
/// `400 BAD_REQUEST: Idempotency-Key header is required`. Its OpenAPI spec
/// marks the parameter `required: false` on exactly those endpoints, so the
/// schema can't be trusted to tell us where it's needed. Rather than chase that
/// endpoint by endpoint, every mutating request gets one.
///
/// Endpoints that already set the header explicitly (wallet funding, escrow
/// funding) keep their own key — this only fills in the gaps.
///
/// The key is generated per request, not per retry: Dio reuses the same
/// [RequestOptions] when it retries, so a replayed call carries the key the
/// server already saw and collapses to a no-op instead of running twice.
class IdempotencyInterceptor extends Interceptor {
  static const _header = 'Idempotency-Key';
  static const _mutatingMethods = {'POST', 'PUT', 'PATCH', 'DELETE'};

  final Uuid _uuid;

  IdempotencyInterceptor({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final method = options.method.toUpperCase();

    if (_mutatingMethods.contains(method) &&
        !options.headers.keys.any(
          (key) => key.toLowerCase() == _header.toLowerCase(),
        )) {
      options.headers[_header] = _uuid.v4();
    }

    handler.next(options);
  }
}
