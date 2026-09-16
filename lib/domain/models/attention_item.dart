/// Something the user should act on next, surfaced at the top of Home.
enum AttentionKind { invitation, agree, fund, review, dispute }

class AttentionItem {
  final AttentionKind kind;
  final String title;
  final String subtitle;
  final String route;
  final String? agreementId;

  const AttentionItem({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.route,
    this.agreementId,
  });

  /// Stable identity so list diffs don't animate the same item twice.
  String get key => '${kind.name}:${agreementId ?? route}:$title';
}
