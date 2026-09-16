/// Normalises `ConditionResponse.status`.
///
/// The API writes `pending`, `approved` and `rejected`; `submitted` is used
/// once the beneficiary has uploaded assets and the depositor has to review.
/// Older client code compared against `MET`, which is kept as an alias.
class ConditionStatusHelper {
  static const String pending = 'pending';
  static const String submitted = 'submitted';
  static const String approved = 'approved';
  static const String rejected = 'rejected';

  static String normalize(String? value) {
    return switch ((value ?? '').trim().toLowerCase()) {
      'approved' || 'met' || 'completed' => approved,
      'submitted' || 'in_review' || 'in_progress' => submitted,
      'rejected' => rejected,
      _ => pending,
    };
  }

  static bool isMet(String? value) => normalize(value) == approved;

  static bool isSubmitted(String? value) => normalize(value) == submitted;

  static bool isRejected(String? value) => normalize(value) == rejected;

  static String label(String? value) => switch (normalize(value)) {
        approved => 'Approved',
        submitted => 'Awaiting review',
        rejected => 'Rejected',
        _ => 'Pending',
      };
}
