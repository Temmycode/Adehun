import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/profile_completion_screen.dart';
import '../screens/home_screen.dart';
import '../screens/wallet_screen.dart';
import '../screens/fund_wallet_screen.dart';
import '../screens/agreements_list_screen.dart';
import '../screens/create_agreement_screen.dart';
import '../screens/agreement_detail_screen.dart';
import '../screens/condition_detail_screen.dart';
import '../screens/upload_assets_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/agreement_invitation_screen.dart';
import '../screens/upgrade_screen.dart';
import '../screens/dispute_screen.dart';
import '../screens/success_screen.dart';
import '../shell/main_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // Splash
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // Onboarding
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Auth
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),

    // Profile Completion
    GoRoute(
      path: '/profile-completion',
      builder: (context, state) => const ProfileCompletionScreen(),
    ),

    // Main App Shell (with bottom nav)
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/wallet',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: WalletScreen(),
          ),
        ),
        GoRoute(
          path: '/agreements',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AgreementsListScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),

    // Full-screen routes (outside shell)
    GoRoute(
      path: '/fund-wallet',
      builder: (context, state) => const FundWalletScreen(),
    ),
    GoRoute(
      path: '/create-agreement',
      builder: (context, state) => const CreateAgreementScreen(),
    ),
    GoRoute(
      path: '/agreement/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AgreementDetailScreen(agreementId: id);
      },
    ),
    GoRoute(
      path: '/condition/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ConditionDetailScreen(conditionId: id);
      },
    ),
    GoRoute(
      path: '/upload-assets/:conditionId',
      builder: (context, state) {
        final conditionId = state.pathParameters['conditionId']!;
        return UploadAssetsScreen(conditionId: conditionId);
      },
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/agreement-invitation/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AgreementInvitationScreen(agreementId: id);
      },
    ),
    GoRoute(
      path: '/upgrade',
      builder: (context, state) => const UpgradeScreen(),
    ),
    GoRoute(
      path: '/dispute/:agreementId',
      builder: (context, state) {
        final agreementId = state.pathParameters['agreementId']!;
        return DisputeScreen(agreementId: agreementId);
      },
    ),
    GoRoute(
      path: '/success/:type',
      builder: (context, state) {
        final type = state.pathParameters['type']!;
        return SuccessScreen(type: type);
      },
    ),
  ],
);
