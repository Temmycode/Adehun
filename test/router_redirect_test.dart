import 'package:adehun_mvp/router/redirect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String? go(
    String location, {
    bool hasSession = false,
    bool needsProfile = false,
    bool isFirstLaunch = false,
  }) => computeRedirect(
    location: location,
    hasSession: hasSession,
    needsProfile: needsProfile,
    isFirstLaunch: isFirstLaunch,
  );

  group('signed out', () {
    test('private routes bounce to /auth', () {
      for (final path in ['/home', '/wallet', '/agreement/abc', '/withdraw']) {
        expect(go(path), '/auth', reason: path);
      }
    });

    test('first launch bounces to onboarding instead', () {
      expect(go('/home', isFirstLaunch: true), '/onboarding');
    });

    test('public routes are allowed', () {
      expect(go('/auth'), isNull);
      expect(go('/onboarding'), isNull);
      expect(go('/splash'), isNull);
      expect(go('/invite?token=abc'), isNull);
    });

    test('profile completion requires a session', () {
      expect(go('/profile-completion'), '/auth');
    });
  });

  group('signed in', () {
    test('auth and onboarding redirect home', () {
      expect(go('/auth', hasSession: true), '/home');
      expect(go('/onboarding', hasSession: true), '/home');
    });

    test('private routes are allowed', () {
      expect(go('/home', hasSession: true), isNull);
      expect(go('/agreement/x?tab=1', hasSession: true), isNull);
    });

    test('incomplete profile is pinned to profile completion', () {
      expect(go('/home', hasSession: true, needsProfile: true), '/profile-completion');
      expect(go('/profile-completion', hasSession: true, needsProfile: true), isNull);
    });

    test('complete profile leaves profile completion', () {
      expect(go('/profile-completion', hasSession: true), '/home');
    });

    test('invite links always open', () {
      expect(go('/invite?token=x', hasSession: true), isNull);
      expect(go('/invite?token=x', hasSession: true, needsProfile: true), isNull);
    });
  });
}
