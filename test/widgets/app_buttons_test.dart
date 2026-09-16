import 'package:adehun_mvp/theme/app_theme.dart';
import 'package:adehun_mvp/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('primary button fires onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(PrimaryButton(label: 'Continue', onPressed: () => taps++)),
    );
    await tester.tap(find.text('Continue'));
    expect(taps, 1);
  });

  testWidgets('loading state shows a spinner and swallows taps', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        PrimaryButton(label: 'Save', loading: true, onPressed: () => taps++),
      ),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Save'), findsNothing);
    await tester.tap(find.byType(FilledButton), warnIfMissed: false);
    expect(taps, 0);
  });

  testWidgets('disabled button does not fire', (tester) async {
    await tester.pumpWidget(
      _wrap(const SecondaryButton(label: 'Later', onPressed: null)),
    );
    final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
    expect(button.enabled, isFalse);
  });
}
