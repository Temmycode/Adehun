import 'package:intl/intl.dart';

extension RelativeTime on DateTime {
  String toRelativeTime({DateTime? clock}) {
    final now = clock ?? DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 5) return 'just now';
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    final sameYear = now.year == year;
    return DateFormat(sameYear ? 'MMM d' : 'MMM d, yyyy').format(this);
  }
}
