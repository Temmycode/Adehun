import 'package:adehun_mvp/controllers/invitation_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_nav_bar.dart';

class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/wallet')) return 1;
    if (location.startsWith('/agreements')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pending invitations show as a badge on the Agreements tab.
    final pendingInvites = ref.watch(invitedAgreementsProvider).maybeWhen(
          data: (list) => list
              .where((inv) => inv.status.toLowerCase() == 'pending')
              .length,
          orElse: () => 0,
        );

    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: AppNavBar(
        index: _currentIndex(context),
        pendingBadge: pendingInvites,
        onCreate: () => context.push('/create-agreement'),
        onTap: (i) => context.go(switch (i) {
          1 => '/wallet',
          3 => '/agreements',
          4 => '/profile',
          _ => '/home',
        }),
      ),
    );
  }
}
