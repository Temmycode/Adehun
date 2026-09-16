/// API origin. Override per build with
/// `--dart-define=API_BASE_URL=http://127.0.0.1:8000` or
/// `--dart-define-from-file=config.local.json`.
const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://adehun-api.onrender.com',
);

/// Builds the websocket URL for [path] from [baseUrl], so every socket follows
/// the configured API origin (staging, local, production) automatically.
String websocketUrl(String path, String token) {
  final socketBase = baseUrl.replaceFirstMapped(
    RegExp(r'^https?://'),
    (match) => match.group(0) == 'https://' ? 'wss://' : 'ws://',
  );
  return '$socketBase$path?token=${Uri.encodeQueryComponent(token)}';
}

/// AUTH ENDPOINTS
const String registerUrl = '/auth/register';
const String registerFromInviteUrl = '/auth/register-from-invite';
const String loginUrl = '/auth/login';
const String refreshUrl = '/auth/refresh';
const String logoutUrl = '/auth/logout';

/// USER ENDPOINTS
const String currentUserUrl = '/users/current';
const String updateUserUrl = '/users/{user_id}';
const String profileUploadSignatureUrl = '/users/upload-signature';

/// AGREEMENT ENDPOINTS
const String getAllUserAgreementUrl = '/agreements/';
const String addAgreementUrl = '/agreements/';
const String getInvitedAgreementUrl = '/agreements/invited';
const String acceptAgreementUrl = '/agreements/{agreement_id}/accept';
const String rejectAgreementUrl = '/agreements/{agreement_id}/reject';
const String fundAgreementUrl = '/agreements/{agreement_id}/fund';
const String releaseAgreementUrl = '/agreements/{agreement_id}/release';
const String cancelAgreementUrl = '/agreements/{agreement_id}/cancel';
const String getAgreementUrl = '/agreements/{agreement_id}';
const String getAgreementInvitationUrl =
    '/agreements/{agreement_id}/invitation';
const String agreementWebsocketUrl = '/agreements/ws';

/// INVITATION ENDPOINTS
const String invitationLookupUrl = '/invitations/{token}';

/// CONDITION ENDPOINTS
const String addConditionToAgreementUrl =
    '/agreements/{agreement_id}/conditions';
const String getUserConditionsUrl = '/agreements/{agreement_id}/conditions';
const String getConditionDetailsUrl = '/conditions/{condition_id}';
const String approveConditionUrl = '/conditions/{condition_id}/approve';
const String rejectConditionUrl = '/conditions/{condition_id}/reject';
const String getConditionAssetsUrl = '/conditions/{condition_id}/assets';
const String getConditionAssetUploadSignatureUrl =
    '/conditions/{condition_id}/assets/upload-signature';
const String approveConditionAssetUrl =
    '/conditions/{condition_id}/assets/{asset_id}/approve';
const String rejectConditionAssetUrl =
    '/conditions/{condition_id}/assets/{asset_id}/reject';

/// DISPUTE ENDPOINTS
const String getDisputeUploadSignatureUrl =
    '/agreements/{agreement_id}/disputes/upload-signature';
const String raiseDisputeUrl = '/agreements/{agreement_id}/disputes';
const String getAgreementDisputesUrl = '/agreements/{agreement_id}/disputes';

/// STATISTICS ENDPOINTS
const String getUserAgreementsStatsUrl = '/stats/agreements/';

/// NOTIFICATION ENDPOINTS
const String getNotificationsUrl = '/notifications';
const String getUnreadNotificationsCountUrl = '/notifications/unread-count';
const String markNotificationsReadUrl = '/notifications/read';
const String markAllNotificationsReadUrl = '/notifications/read-all';

/// WALLET ENDPOINTS
const String getWalletUrl = '/wallet';
const String fundWalletUrl = '/wallet/fund';
const String withdrawUrl = '/wallet/withdraw';
const String getWithdrawalUrl = '/wallet/withdrawals/{reference}';
const String walletWebsocketUrl = '/wallet/ws';

/// BANK ACCOUNT ENDPOINTS
const String listBanksUrl = '/bank-accounts/banks';
const String resolveBankAccountUrl = '/bank-accounts/resolve';
const String bankAccountsUrl = '/bank-accounts';
const String setDefaultBankAccountUrl = '/bank-accounts/{account_id}/default';
const String deleteBankAccountUrl = '/bank-accounts/{account_id}';

/// TRANSACTION ENDPOINTS
const String getTransactionsUrl = '/transactions';
const String getTransactionSummaryUrl = '/transactions/summary';
const String getTransactionUrl = '/transactions/{transaction_id}';
