import 'package:flutter_test/flutter_test.dart';
import 'package:adehun_mvp/main.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AdehunApp());
    // Advance past the splash screen's Future.delayed timer (2.5s)
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
