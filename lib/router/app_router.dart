import 'package:adehun_mvp/router/auth_route_notifier.dart';
import 'package:adehun_mvp/router/redirect.dart';
import 'package:adehun_mvp/screens/add_bank_account_screen.dart';
import 'package:adehun_mvp/screens/bank_accounts_screen.dart';
import 'package:adehun_mvp/screens/edit_profile_screen.dart';
import 'package:adehun_mvp/screens/invite_landing_screen.dart';
import 'package:adehun_mvp/screens/withdraw_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/agreement_detail_screen.dart';
import '../screens/agreement_invitation_screen.dart';
import '../screens/agreements_list_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/condition_detail_screen.dart';
import '../screens/create_agreement_screen.dart';
import '../screens/dispute_screen.dart';
import '../screens/fund_wallet_screen.dart';
import '../screens/home_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/profile_completion_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/success_screen.dart';
import '../screens/transactions_screen.dart';
import '../screens/upload_assets_screen.dart';
import '../screens/wallet_screen.dart';
import '../shell/main_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  refreshListenable: authRouteNotifier,
  redirect: (context, state) {
    final target = computeRedirect(
      location: state.uri.toString(),
      hasSession: authRouteNotifier.hasSession,
      needsProfile: authRouteNotifier.needsProfile,
      isFirstLaunch: authRouteNotifier.isFirstLaunch,
    );
    // Remember where an unauthenticated deep link wanted to go.
    if (target == '/auth' && state.uri.path != '/auth') {
      authRouteNotifier.setRedirectAfterLogin(state.uri.toString());
    }
    return target;
  },
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page not found')),
    body: Center(
      child: TextButton(
        onPressed: () => context.go('/home'),
        child: const Text('Back to home'),
      ),
    ),
  ),
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
    GoRoute(
      path: '/profile-completion',
      builder: (context, state) => const ProfileCompletionScreen(),
    ),

    // Emailed invitation deep link: adehun://open/invite?token=… and
    // https://<api>/invite?token=… both land here.
    GoRoute(
      path: '/invite',
      builder: (context, state) =>
          InviteLandingScreen(token: state.uri.queryParameters['token'] ?? ''),
    ),

    // Main App Shell (with bottom nav)
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: '/wallet',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: WalletScreen()),
        ),
        GoRoute(
          path: '/agreements',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AgreementsListScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProfileScreen()),
        ),
      ],
    ),

    // Full-screen routes (outside shell)
    GoRoute(
      path: '/fund-wallet',
      builder: (context, state) => const FundWalletScreen(),
    ),
    GoRoute(
      path: '/withdraw',
      builder: (context, state) => const WithdrawScreen(),
    ),
    GoRoute(
      path: '/bank-accounts',
      builder: (context, state) => const BankAccountsScreen(),
    ),
    GoRoute(
      path: '/bank-accounts/add',
      builder: (context, state) => const AddBankAccountScreen(),
    ),
    GoRoute(
      path: '/transactions',
      builder: (context, state) => const TransactionsScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
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
        final agreementId = state.uri.queryParameters['agreementId'] ?? '';
        return ConditionDetailScreen(agreementId: agreementId, conditionId: id);
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
      path: '/agreement-invitation/:agreementId',
      builder: (context, state) => AgreementInvitationScreen(
        agreementId: state.pathParameters['agreementId']!,
      ),
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
      builder: (context, state) => SuccessScreen(
        type: state.pathParameters['type']!,
        agreementId: state.uri.queryParameters['agreementId'],
      ),
    ),
  ],
);
