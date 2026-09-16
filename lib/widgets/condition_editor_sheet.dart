import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import 'app_bottom_sheet.dart';
import 'app_buttons.dart';
import 'avatar_initials.dart';
import 'labeled_field.dart';

/// Someone a condition can be required from.
class ConditionParty {
  final String id;
  final String name;
  final String role;
  final bool isMe;
  final String? imageUrl;

  const ConditionParty({
    required this.id,
    required this.name,
    required this.role,
    this.isMe = false,
    this.imageUrl,
  });
}

/// What the editor hands back.
class ConditionDraft {
  final String title;
  final String description;
  final String partyId;

  const ConditionDraft({
    required this.title,
    required this.description,
    required this.partyId,
  });
}

/// Bottom sheet for adding or editing a condition. Returns null when
/// dismissed without saving.
Future<ConditionDraft?> showConditionEditorSheet(
  BuildContext context, {
  required List<ConditionParty> parties,
  ConditionDraft? initial,
  String? suggestedTitle,
}) {
  return showAppBottomSheet<ConditionDraft>(
    context,
    builder: (_) => _ConditionEditor(
      parties: parties,
      initial: initial,
      suggestedTitle: suggestedTitle,
    ),
  );
}

class _ConditionEditor extends StatefulWidget {
  final List<ConditionParty> parties;
  final ConditionDraft? initial;
  final String? suggestedTitle;

  const _ConditionEditor({
    required this.parties,
    this.initial,
    this.suggestedTitle,
  });

  @override
  State<_ConditionEditor> createState() => _ConditionEditorState();
}

class _ConditionEditorState extends State<_ConditionEditor> {
  late final TextEditingController _title = TextEditingController(
    text: widget.initial?.title ?? widget.suggestedTitle ?? '',
  );
  late final TextEditingController _description = TextEditingController(
    text: widget.initial?.description ?? '',
  );
  late String? _partyId = widget.initial?.partyId;
  String? _partyError;
  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.initial != null;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  void _save() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (_partyId == null) {
      setState(() => _partyError = 'Choose who has to do this');
      return;
    }
    if (!valid) return;
    Navigator.of(context).pop(
      ConditionDraft(
        title: _title.text.trim(),
        description: _description.text.trim(),
        partyId: _partyId!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isEditing ? 'Edit condition' : 'Add a condition',
              style: AppTextStyles.h2.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Something that has to happen before the money is released.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            LabeledField(
              label: 'What needs to happen?',
              hint: 'e.g. Deliver the homepage design',
              controller: _title,
              autofocus: !_isEditing && widget.suggestedTitle == null,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if ((value ?? '').trim().length < 3) {
                  return 'Give this condition a short title';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            LabeledField(
              label: 'Details (optional)',
              hint: 'Anything the other side should know',
              controller: _description,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Who has to do this?',
              style: AppTextStyles.labelLarge.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                for (var i = 0; i < widget.parties.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _PartyChoice(
                      party: widget.parties[i],
                      selected: _partyId == widget.parties[i].id,
                      onTap: () => setState(() {
                        _partyId = widget.parties[i].id;
                        _partyError = null;
                      }),
                    ),
                  ),
                ],
              ],
            ),
            if (_partyError != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                _partyError!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),
            PrimaryButton(
              label: _isEditing ? 'Save changes' : 'Add condition',
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}

class _PartyChoice extends StatelessWidget {
  final ConditionParty party;
  final bool selected;
  final VoidCallback onTap;

  const _PartyChoice({
    required this.party,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final role = party.role.isEmpty
        ? ''
        : party.role[0].toUpperCase() + party.role.substring(1).toLowerCase();
    return Semantics(
      button: true,
      selected: selected,
      label: '${party.isMe ? 'You' : party.name}, $role',
      child: Material(
        color: selected ? colors.primarySurface : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(
            color: selected ? AppColors.primary : colors.cardBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                AvatarInitials(
                  name: party.isMe ? 'You' : party.name,
                  imageUrl: party.imageUrl,
                  size: 40,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  party.isMe ? 'You' : party.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: selected ? AppColors.primary : colors.textPrimary,
                  ),
                ),
                if (role.isNotEmpty)
                  Text(
                    role,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colors.textSecondary,
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
