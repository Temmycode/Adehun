import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/main.dart';
import 'package:adehun_mvp/router/auth_route_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('boots to onboarding on first launch without a session', (
    tester,
  ) async {
    // The app is portrait-phone only; the default test viewport is a small
    // landscape window that no real device has.
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    authRouteNotifier.seed(hasSession: false, isFirstLaunch: true);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const AdehunApp(),
      ),
    );

    expect(find.text('Adehun'), findsOneWidget); // splash
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Onboarding is a public route; no network or platform channel is hit.
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Secure Escrow, Simplified'), findsNothing);
  });
}
