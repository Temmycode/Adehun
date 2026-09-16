import 'package:intl/intl.dart';

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// "Today", "Yesterday", "Mon, 12 Sep" or "Mon, 12 Sep 2025" for older years.
String dayLabel(DateTime date, {DateTime? now}) {
  final today = now ?? DateTime.now();
  final local = date.toLocal();
  if (isSameDay(local, today)) return 'Today';
  if (isSameDay(local, today.subtract(const Duration(days: 1)))) {
    return 'Yesterday';
  }
  final pattern = local.year == today.year ? 'EEE, d MMM' : 'EEE, d MMM yyyy';
  return DateFormat(pattern).format(local);
}

/// Whether item [index] starts a new day relative to the item before it.
bool startsNewDay<T>(List<T> items, int index, DateTime Function(T) dateOf) {
  if (index == 0) return true;
  return !isSameDay(dateOf(items[index - 1]), dateOf(items[index]));
}
