const String baseUrl = 'http://10.0.2.2:8000';
// 'http://127.0.0.1:8000';
const String androidBaseUrl = 'http://10.0.2.2:8000';

/// AUTH ENDPOINTS
const String registerUrl = '/auth/register';
const String registerFromInviteUrl = '/auth/register-from-invite';
const String loginUrl = '/auth/login';
const String refreshUrl = '/auth/refresh';

/// AGREEMENT ENDPOINTS
const String getAllUserAgreementUrl = '/agreements/';
const String addAgreementUrl = '/agreements/';
const String acceptAgreementUrl = '/agreements/{agreement_id}/';
const String getAgreementUrl = '/agreements/{agreement_id}/';

/// CONDITION ENDPOINTS
const String addConditionToAgreementUrl =
    '/agreements/{agreement_id}/conditions';
const String getUserConditionsUrl = '/conditions/';
const String getConditionDetailsUrl = '/conditions/{condition_id}';
const String approveConditionUrl = '/conditions/{condition_id}/approve';
const String rejectConditionUrl = '/conditions/{condition_id}/reject';

/// STATISTICS ENDPOINTS
const String getUserAgreementsStatsUrl = '/stats/agreements/';

/// NOTIFICATION ENDPOINTS
const String getNotificationsUrl = '/notifications';
const String getUnreadNotificationsCountUrl = '/notifications/unread-count';
const String markNotificationsReadUrl = '/notifications/read';
const String markAllNotificationsReadUrl = '/notifications/read-all';
