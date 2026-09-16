import 'dart:io';

import 'package:adehun_mvp/controllers/invitation_providers.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/models/invite_lookup.dart';
import 'package:adehun_mvp/router/auth_route_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_motion.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_card.dart';
import '../widgets/skeletons.dart';
import 'splash_screen.dart' show AdehunMark;

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
      final response =
          await ref.read(invitationApiServiceProvider).lookup(widget.token);
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
    final hasSession = authRouteNotifier.hasSession;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.lg,
            AppSpacing.gutter,
            AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const AdehunMark(size: 36, onPrimary: false),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Adehun',
                    style: AppTextStyles.h2.copyWith(color: colors.textPrimary),
                  ),
                ],
              ),
              const Spacer(),
              AnimatedSwitcher(
                duration: AppMotion.normal,
                child: _loading
                    ? const _LoadingCard(key: ValueKey('loading'))
                    : _error != null
                        ? _ErrorCard(key: const ValueKey('error'), message: _error!)
                        : _InviteCard(key: const ValueKey('invite'), lookup: lookup!)
                            .entrance(context, 0),
              ),
              const Spacer(),
              if (!_loading)
                PrimaryButton(
                  label: _error == null
                      ? (hasSession ? 'View invitation' : 'Sign in to continue')
                      : 'Continue',
                  onPressed: _error == null
                      ? _continue
                      : () => context.go(hasSession ? '/home' : '/auth'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      padding: EdgeInsets.all(AppSpacing.xxl),
      child: Shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonCircle(diameter: 56),
            SizedBox(height: AppSpacing.lg),
            SkeletonLine(widthFactor: 0.6, height: 18),
            SizedBox(height: AppSpacing.sm),
            SkeletonLine(widthFactor: 0.9, height: 12),
            SizedBox(height: 6),
            SkeletonLine(widthFactor: 0.5, height: 12),
          ],
        ),
      ),
    );
  }
}

class _InviteCard extends StatelessWidget {
  final InviteLookup lookup;

  const _InviteCard({super.key, required this.lookup});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.primarySurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Iconsax.sms_tracking, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '${lookup.inviterName} invited you',
            style: AppTextStyles.h2.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'You have been invited to "${lookup.agreementTitle}" as the ${lookup.role}.',
            style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
          ),
          if (lookup.emailHint.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Sent to ${lookup.emailHint}',
              style: AppTextStyles.bodySmall.copyWith(color: colors.textTertiary),
            ),
          ],
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.errorLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Iconsax.warning_2, color: AppColors.error, size: 28),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Invitation unavailable',
            style: AppTextStyles.h2.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
