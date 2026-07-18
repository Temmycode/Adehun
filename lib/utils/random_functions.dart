String getInitials(String username) {
  final nameWords = username
      .trim()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();

  final initials = nameWords.isEmpty
      ? "U"
      : nameWords.length == 1
      ? nameWords.first[0].toUpperCase()
      : (nameWords.first[0] + nameWords.last[0]).toUpperCase();
  return initials.toUpperCase();
}
