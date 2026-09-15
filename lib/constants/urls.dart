const String baseUrl = 'https://adehun-api.onrender.com';
const String androidBaseUrl = 'http://10.0.2.2:8000';

/// AUTH ENDPOINTS
const String registerUrl = '/auth/register';
const String registerFromInviteUrl = '/auth/register-from-invite';
const String loginUrl = '/auth/login';
const String refreshUrl = '/auth/refresh';

/// AGREEMENT ENDPOINTS
const String getAllUserAgreementUrl = '/agreements/';
const String addAgreementUrl = '/agreements/';
const String getInvitedAgreementUrl = '/agreements/invited';
const String acceptAgreementUrl = '/agreements/{agreement_id}/accept';
const String fundAgreementUrl = '/agreements/{agreement_id}/fund';
const String cancelAgreementUrl = '/agreements/{agreement_id}/cancel';
const String getAgreementUrl = '/agreements/{agreement_id}/';
const String getAgreementInvitationUrl =
    '/agreements/{agreement_id}/invitation';
const String agreementWebsocketUrl = '/agreements/ws';

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
const String fundWalletUrl = '/wallet/fund';
const String walletWebsocketUrl = '/wallet/ws';

/// TRANSACTION ENDPOINTS
const String getTransactionsUrl = '/transactions';
const String getTransactionSummaryUrl = '/transactions/summary';
const String getTransactionUrl = '/transactions/{transaction_id}';
