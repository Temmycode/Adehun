class AgreementStatusHelper {
  static const String draft = 'DRAFT';
  static const String pending = 'PENDING';
  static const String active = 'ACTIVE';
  static const String completed = 'COMPLETED';
  static const String disputed = 'DISPUTED';
  static const String cancelled = 'CANCELLED';
  static const String refunded = 'REFUNDED';

  static String normalize(String? value) {
    final normalized = (value ?? '').trim().toUpperCase();

    if (normalized.isEmpty) {
      return pending;
    }

    switch (normalized) {
      case 'DRAFT':
        return draft;
      case 'PENDING_ACCEPTANCE':
      case 'PENDING':
        return pending;
      case 'ACTIVE':
      case 'CONDITIONS_IN_PROGRESS':
      case 'IN_PROGRESS':
        return active;
      case 'CONDITIONS_MET':
      case 'COMPLETED':
      case 'MET':
        return completed;
      case 'DISPUTED':
        return disputed;
      case 'CANCELLED':
      case 'CANCELED':
        return cancelled;
      case 'REFUNDED':
        return refunded;
      default:
        return normalized;
    }
  }

  static String displayLabel(String? value) {
    return switch (normalize(value)) {
      draft => 'Draft',
      pending => 'Pending',
      active => 'Active',
      completed => 'Completed',
      disputed => 'Disputed',
      cancelled => 'Cancelled',
      refunded => 'Refunded',
      _ => (value ?? '').trim().isEmpty ? 'Pending' : _titleCase(value!),
    };
  }

  static bool isPendingLike(String? value) => normalize(value) == pending;

  static bool isActiveLike(String? value) => normalize(value) == active;

  static bool isCompletedLike(String? value) => normalize(value) == completed;

  static bool isDisputedLike(String? value) => normalize(value) == disputed;

  static bool isCancelledLike(String? value) => normalize(value) == cancelled;

  static bool isRefundedLike(String? value) => normalize(value) == refunded;

  static bool canAddConditions(String? value) {
    final normalized = normalize(value);
    return normalized == draft || normalized == pending;
  }

  static String _titleCase(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Pending';
    return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
  }
}
