import 'package:adehun_mvp/constants/dispute_enums.dart';
import 'package:adehun_mvp/domain/models/transaction.dart';
import 'package:adehun_mvp/theme/app_theme.dart';
import 'package:adehun_mvp/widgets/status_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('agreement statuses render their display labels', (tester) async {
    const cases = {
      'pending': 'Pending',
      'ACTIVE': 'Active',
      'completed': 'Completed',
      'disputed': 'Disputed',
      'cancelled': 'Cancelled',
      'refunded': 'Refunded',
      null: 'Pending',
    };
    for (final entry in cases.entries) {
      await tester.pumpWidget(_wrap(StatusPill.agreement(entry.key)));
      expect(find.text(entry.value), findsOneWidget, reason: '${entry.key}');
    }
  });

  testWidgets('dispute and transaction factories render', (tester) async {
    await tester.pumpWidget(_wrap(StatusPill.dispute(DisputeStatus.underReview)));
    expect(find.text('Under Review'), findsOneWidget);

    await tester.pumpWidget(
      _wrap(StatusPill.transaction(TransactionStatus.reversed)),
    );
    expect(find.text('Reversed'), findsOneWidget);
  });

  testWidgets('custom pill shows label without icon', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const StatusPill(
          label: 'Custom',
          foreground: Colors.black,
          background: Colors.white,
        ),
      ),
    );
    expect(find.text('Custom'), findsOneWidget);
    expect(find.byType(Icon), findsNothing);
  });
}
