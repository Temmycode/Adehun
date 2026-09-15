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

class CancelAgreementError extends AppException {
  const CancelAgreementError()
    : super("Couldn't cancel the agreement. Please try again.");
}

class FundAgreementError extends AppException {
  const FundAgreementError()
    : super("Couldn't move the funds into escrow. Please try again.");
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

class RaiseDisputeError extends AppException {
  const RaiseDisputeError()
    : super("Couldn't raise the dispute. Please try again.");
}

class GetDisputesError extends AppException {
  const GetDisputesError() : super("Couldn't load disputes.");
}

class GetDisputeUploadSignatureError extends AppException {
  const GetDisputeUploadSignatureError()
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

class GetWalletError extends AppException {
  const GetWalletError() : super("Couldn't load your wallet balance.");
}

class WithdrawError extends AppException {
  const WithdrawError()
    : super("Couldn't start the withdrawal. Please try again.");
}

class GetBanksError extends AppException {
  const GetBanksError() : super("Couldn't load the list of banks.");
}

class ResolveBankAccountError extends AppException {
  const ResolveBankAccountError()
    : super("Couldn't verify that account. Check the number and bank.");
}

class GetBankAccountsError extends AppException {
  const GetBankAccountsError() : super("Couldn't load your bank accounts.");
}

class AddBankAccountError extends AppException {
  const AddBankAccountError()
    : super("Couldn't save that bank account. Please try again.");
}

class UpdateBankAccountError extends AppException {
  const UpdateBankAccountError()
    : super("Couldn't update that bank account. Please try again.");
}

class GetProfileError extends AppException {
  const GetProfileError() : super("Couldn't load your profile.");
}

class UpdateProfileError extends AppException {
  const UpdateProfileError()
    : super("Couldn't save your profile. Please try again.");
}

class InvitationLookupError extends AppException {
  const InvitationLookupError()
    : super('This invitation is invalid or has expired.');
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
