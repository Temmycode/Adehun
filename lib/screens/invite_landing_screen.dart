import 'dart:io';

import 'package:adehun_mvp/controllers/invitation_providers.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/models/invite_lookup.dart';
import 'package:adehun_mvp/router/auth_route_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Target of `adehun://open/invite?token=…` and `https://<api>/invite?token=…`.
///
/// Looks the token up, then either sends the user to sign in (remembering the
/// token so sign-in goes through the invite-aware endpoint) or straight to the
/// invitation screen.
class InviteLandingScreen extends ConsumerStatefulWidget {
  final String token;
  const InviteLandingScreen({super.key, required this.token});

  @override
  ConsumerState<InviteLandingScreen> createState() =>
      _InviteLandingScreenState();
}

class _InviteLandingScreenState extends ConsumerState<InviteLandingScreen> {
  InviteLookup? _lookup;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    if (widget.token.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'This link is missing its invitation code.';
      });
      return;
    }
    try {
      final response = await ref
          .read(invitationApiServiceProvider)
          .lookup(widget.token);
      if (!mounted) return;
      if (response.response.statusCode == HttpStatus.ok) {
        setState(() {
          _lookup = response.data;
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          _error = 'This invitation is invalid or has expired.';
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'This invitation is invalid or has expired.';
      });
    }
  }

  void _continue() {
    final lookup = _lookup;
    if (lookup == null) return;
    if (authRouteNotifier.hasSession) {
      ref.invalidate(invitedAgreementsProvider);
      context.go('/agreement-invitation/${lookup.agreementId}');
    } else {
      authRouteNotifier.setPendingInvite(widget.token);
      authRouteNotifier.setRedirectAfterLogin(
        '/agreement-invitation/${lookup.agreementId}',
      );
      context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final lookup = _lookup;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Center(
            child: _loading
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _error == null ? Iconsax.sms_tracking : Iconsax.warning_2,
                        size: 64,
                        color: _error == null ? AppColors.primary : AppColors.error,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _error == null
                            ? '${lookup!.inviterName} invited you'
                            : 'Invitation unavailable',
                        style: AppTextStyles.h2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error ??
                            'You have been invited to "${lookup!.agreementTitle}" '
                                'as the ${lookup.role}.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_error == null && lookup!.emailHint.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Sent to ${lookup.emailHint}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.textTertiary,
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _error == null
                              ? _continue
                              : () => context.go(
                                  authRouteNotifier.hasSession ? '/home' : '/auth',
                                ),
                          child: Text(
                            _error == null
                                ? (authRouteNotifier.hasSession
                                      ? 'View invitation'
                                      : 'Sign in to continue')
                                : 'Continue',
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
