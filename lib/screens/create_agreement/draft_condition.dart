/// A condition the user has drafted but not yet sent.
///
/// [partyId] is `'me'` or `'other'`; it is resolved to an email at submit
/// time, once the invite field is final.
class DraftCondition {
  static const me = 'me';
  static const other = 'other';

  final String title;
  final String description;
  final String partyId;

  const DraftCondition({
    required this.title,
    required this.description,
    required this.partyId,
  });

  bool get isForMe => partyId == me;
}

/// Suggested condition titles offered as chips.
const conditionTemplates = <String>[
  'Deliver the files',
  'Approve the design',
  'Ship the item',
  'Confirm receipt',
  'Complete milestone 1',
];
