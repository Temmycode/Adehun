import 'package:adehun_mvp/widgets/avatar_initials.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('initials come from first and last name', () {
    expect(AvatarInitials.initialsFor('Ada Lovelace'), 'AL');
    expect(AvatarInitials.initialsFor('  temi  akisanya  '), 'TA');
    expect(AvatarInitials.initialsFor('Cher'), 'C');
    expect(AvatarInitials.initialsFor(''), '?');
    expect(AvatarInitials.initialsFor(null), '?');
  });

  test('the same name always maps to the same colour pair', () {
    final a = AvatarInitials.paletteFor('Ada Lovelace', dark: false);
    final b = AvatarInitials.paletteFor('ada lovelace', dark: false);
    expect(a, b);
  });

  test('different names spread across the palette', () {
    final seen = <(Object, Object)>{};
    for (final name in ['Ada', 'Bola', 'Chidi', 'Dami', 'Emeka', 'Funke', 'Gbenga']) {
      seen.add(AvatarInitials.paletteFor(name, dark: true));
    }
    expect(seen.length, greaterThan(2));
  });
}
