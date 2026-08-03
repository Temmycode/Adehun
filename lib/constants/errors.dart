/// Base for the app's domain errors.
///
/// [toString] is deliberately user-facing: controllers put `exception.toString()`
/// straight into state and screens show it in a snackbar. Without a message
/// override that renders as "Instance of 'FundWalletError'".
abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

class LoginFailedError extends AppException {
  const LoginFailedError() : super('Sign in failed. Please try again.');
}

class InvitationRegistrationError extends AppException {
  const InvitationRegistrationError()
    : super("Couldn't accept that invitation. Please try again.");
}

class RegistrationError extends AppException {
  const RegistrationError()
    : super("Couldn't create your account. Please try again.");
}

class GetAgreementsError extends AppException {
  const GetAgreementsError() : super("Couldn't load your agreements.");
}

class CreateAgreementError extends AppException {
  const CreateAgreementError()
    : super("Couldn't create the agreement. Please try again.");
}

class AcceptAgreementError extends AppException {
  const AcceptAgreementError()
    : super("Couldn't accept the agreement. Please try again.");
}

class GetAgreementError extends AppException {
  const GetAgreementError() : super("Couldn't load that agreement.");
}

class GetAgreementInvitationError extends AppException {
  const GetAgreementInvitationError() : super("Couldn't load that invitation.");
}

class AddConditionError extends AppException {
  const AddConditionError()
    : super("Couldn't add the condition. Please try again.");
}

class GetConditionsError extends AppException {
  const GetConditionsError() : super("Couldn't load conditions.");
}

class GetConditionDetailsError extends AppException {
  const GetConditionDetailsError() : super("Couldn't load that condition.");
}

class ApproveConditionError extends AppException {
  const ApproveConditionError()
    : super("Couldn't approve the condition. Please try again.");
}

class RejectConditionError extends AppException {
  const RejectConditionError()
    : super("Couldn't reject the condition. Please try again.");
}

class GetConditionAssetsError extends AppException {
  const GetConditionAssetsError() : super("Couldn't load the uploaded files.");
}

class AddConditionAssetsError extends AppException {
  const AddConditionAssetsError()
    : super("Couldn't save your uploads. Please try again.");
}

class ApproveConditionAssetError extends AppException {
  const ApproveConditionAssetError()
    : super("Couldn't approve that file. Please try again.");
}

class RejectConditionAssetError extends AppException {
  const RejectConditionAssetError()
    : super("Couldn't reject that file. Please try again.");
}

class GetConditionAssetUploadSignatureError extends AppException {
  const GetConditionAssetUploadSignatureError()
    : super("Couldn't start the upload. Please try again.");
}

class GetAgreementStatsError extends AppException {
  const GetAgreementStatsError() : super("Couldn't load your stats.");
}

class GetNotificationsError extends AppException {
  const GetNotificationsError() : super("Couldn't load notifications.");
}

class GetUnreadCountError extends AppException {
  const GetUnreadCountError() : super("Couldn't check for new notifications.");
}

class MarkNotificationsReadError extends AppException {
  const MarkNotificationsReadError() : super("Couldn't mark that as read.");
}

class MarkAllNotificationsReadError extends AppException {
  const MarkAllNotificationsReadError() : super("Couldn't mark all as read.");
}

class UploadSignatureError extends AppException {
  const UploadSignatureError()
    : super("Couldn't start the upload. Please try again.");
}

class FundWalletError extends AppException {
  const FundWalletError()
    : super("Couldn't start the payment. Please try again.");
}

class TransactionNotFoundError extends AppException {
  const TransactionNotFoundError()
    : super("That transaction couldn't be found.");
}

class TransactionSummaryNotFoundError extends AppException {
  const TransactionSummaryNotFoundError()
    : super("Couldn't load your transaction summary.");
}

class TransactionListNotFoundError extends AppException {
  const TransactionListNotFoundError()
    : super("Couldn't load your transactions.");
}
