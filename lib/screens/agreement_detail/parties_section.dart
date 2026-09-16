import 'package:adehun_mvp/domain/models/participant.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_color_scheme.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/app_card.dart';
import '../../widgets/avatar_initials.dart';
import '../../widgets/skeletons.dart';

/// Depositor and beneficiary in one card. Falls back to the invitation email
/// while the other party has not signed up yet.
class PartiesSection extends StatelessWidget {
  final Participant? depositor;
  final Participant? beneficiary;
  final String? invitationEmail;
  final String? currentUserEmail;
  final bool loading;

  const PartiesSection({
    super.key,
    required this.depositor,
    required this.beneficiary,
    required this.invitationEmail,
    required this.currentUserEmail,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      child: Column(
        children: [
          if (loading)
            const PartyRowSkeleton()
          else
            _PartyRow(
              label: 'Depositor · pays',
              participant: depositor,
              fallbackEmail: invitationEmail,
              isYou: _isYou(depositor),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Row(
              children: [
                Expanded(child: Divider(color: colors.cardBorder)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Icon(
                    Iconsax.arrow_swap_horizontal_copy,
                    color: colors.textTertiary,
                    size: 18,
                  ),
                ),
                Expanded(child: Divider(color: colors.cardBorder)),
              ],
            ),
          ),
          if (loading)
            const PartyRowSkeleton()
          else
            _PartyRow(
              label: 'Beneficiary · gets paid',
              participant: beneficiary,
              fallbackEmail: invitationEmail,
              isYou: _isYou(beneficiary),
            ),
        ],
      ),
    );
  }

  bool _isYou(Participant? p) =>
      currentUserEmail != null &&
      p?.email != null &&
      p!.email!.toLowerCase() == currentUserEmail!.toLowerCase();
}

class _PartyRow extends StatelessWidget {
  final String label;
  final Participant? participant;
  final String? fallbackEmail;
  final bool isYou;

  const _PartyRow({
    required this.label,
    required this.participant,
    required this.fallbackEmail,
    required this.isYou,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final name = participant?.name?.trim();
    final display = (name != null && name.isNotEmpty)
        ? name
        : (participant?.email ?? fallbackEmail ?? 'Not joined yet');
    final pending = name == null || name.isEmpty;

    return Row(
      children: [
        AvatarInitials(
          name: pending ? null : display,
          imageUrl: participant?.profilePictureUrl,
          size: 40,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      display,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: pending
                            ? colors.textSecondary
                            : colors.textPrimary,
                        fontStyle: pending ? FontStyle.italic : null,
                      ),
                    ),
                  ),
                  if (isYou) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primarySurface,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        'You',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
