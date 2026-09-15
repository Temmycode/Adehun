import 'package:adehun_mvp/core/network/api_response.dart';

/// Returns a user-facing message for a given [ApiError].
///
/// Side effects for `UNAUTHORIZED` (token clear + redirect to /auth) are
/// handled at the interceptor level — see [AuthInterceptor.onSessionExpired].
String handleApiError(ApiError error) {
  switch (error.code) {
    case 'UNAUTHORIZED':
      return 'Your session has expired. Please log in again.';

    case 'FORBIDDEN':
      return 'You do not have permission to do that.';

    case 'WITHDRAWALS_DISABLED':
      return 'Withdrawals are not available yet. We will let you know when '
          'they open.';

    case 'INSUFFICIENT_FUNDS':
    case 'INSUFFICIENT_ESCROW_BALANCE':
    case 'BAD_REQUEST':
      return error.message;

    case 'NOT_FOUND':
      return 'The requested item could not be found.';

    case 'CONFLICT':
      return error.message;

    case 'VALIDATION_ERROR':
      return error.message;

    case 'TOO_MANY_REQUESTS':
      return 'Too many requests. Please wait a moment and try again.';

    case 'INTERNAL_SERVER_ERROR':
    case 'BAD_GATEWAY':
    case 'SERVICE_UNAVAILABLE':
    case 'GATEWAY_TIMEOUT':
      return 'Something went wrong on our end. Please try again.';

    default:
      return error.message;
  }
}
