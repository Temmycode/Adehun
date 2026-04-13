import 'package:adehun_mvp/controllers/agreement_controller.dart';
import 'package:adehun_mvp/usecases/params/create_agreement_params.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../utils/currency_input_formatter.dart';

class CreateAgreementScreen extends ConsumerStatefulWidget {
  const CreateAgreementScreen({super.key});

  @override
  ConsumerState<CreateAgreementScreen> createState() =>
      _CreateAgreementScreenState();
}

class _CreateAgreementScreenState extends ConsumerState<CreateAgreementScreen> {
  final _detailsFormKey = GlobalKey<FormState>();
  final _partiesFormKey = GlobalKey<FormState>();
  int _currentStep = 0;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _inviteController = TextEditingController();
  String _role = 'depositor';
  bool _conditionsError = false;

  static final _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
  static final _phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');

  // Richer condition model: each condition has title, description, requiredFrom
  final List<Map<String, dynamic>> _conditions = [];

  // Derived participant info based on role + invite
  Map<String, dynamic> get _myParticipant => {
    'id': 'me',
    'name': 'You',
    'initials': 'YO',
    'role': _role,
  };

  Map<String, dynamic> get _otherParticipant {
    final otherRole = _role == 'depositor' ? 'beneficiary' : 'depositor';
    final inviteText = _inviteController.text.trim();
    return {
      'id': 'other',
      'name': inviteText.isNotEmpty ? inviteText : 'Other Party',
      'initials': inviteText.isNotEmpty ? inviteText[0].toUpperCase() : 'OP',
      'role': otherRole,
    };
  }

  List<Map<String, dynamic>> get _participants => [
    _myParticipant,
    _otherParticipant,
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _inviteController.dispose();
    super.dispose();
  }

  void _createAgreement() {
    if (!_validateCurrentStep()) return;
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      return;
    }

    final amount =
        int.tryParse(
          _amountController.text.trim().replaceAll(',', '').split('.').first,
        ) ??
        0;

    final params = CreateAgreementParams(
      otherParticipantEmailOrPhone: _inviteController.text.trim(),
      role: _role,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      amount: amount,
      conditions: _conditions.map((c) {
        final requiredFrom = c['requiredFrom'] as Map<String, dynamic>;
        final isMe = requiredFrom['id'] == 'me';
        return CreateConditionParams(
          title: c['title'] as String,
          description: c['description'] as String,
          requiredFromEmail: isMe ? '' : _inviteController.text.trim(),
        );
      }).toList(),
    );

    ref.read(agreementControllerProvider.notifier).createAgreement(params);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCreating = ref.watch(
      agreementControllerProvider.select((s) => s.value?.isCreating ?? false),
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('New Agreement', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Step indicator
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Row(
              children: [
                for (var index = 0; index < 3; index++) ...[
                  _StepDot(
                    index: index,
                    currentStep: _currentStep,
                    colors: colors,
                  ),
                  if (index < 2)
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        color: index < _currentStep
                            ? AppColors.primary
                            : colors.surfaceVariant,
                      ),
                    ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Details',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: _currentStep >= 0
                        ? AppColors.primary
                        : colors.textTertiary,
                  ),
                ),
                Text(
                  'Parties',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: _currentStep >= 1
                        ? AppColors.primary
                        : colors.textTertiary,
                  ),
                ),
                Text(
                  'Conditions',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: _currentStep >= 2
                        ? AppColors.primary
                        : colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Step content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildStepContent(),
            ),
          ),

          // Bottom actions
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _currentStep--),
                      child: const Text('Back'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isCreating ? null : _createAgreement,
                    child: isCreating && _currentStep == 2
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            _currentStep == 2 ? 'Create Agreement' : 'Continue',
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildDetailsStep();
      case 1:
        return _buildPartiesStep();
      case 2:
        return _buildConditionsStep();
      default:
        return const SizedBox.shrink();
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _detailsFormKey.currentState?.validate() ?? false;
      case 1:
        return _partiesFormKey.currentState?.validate() ?? false;
      case 2:
        if (_conditions.isEmpty) {
          setState(() => _conditionsError = true);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Add at least one condition before continuing'),
              ),
            );
          return false;
        }
        setState(() => _conditionsError = false);
        return true;
      default:
        return false;
    }
  }

  Widget _buildDetailsStep() {
    final colors = context.colors;
    return Form(
      key: _detailsFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Agreement Details', style: AppTextStyles.h2),
          const SizedBox(height: 4),
          Text(
            'Describe what this agreement is about',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 24),
          Text('Title', style: AppTextStyles.labelLarge),
          const SizedBox(height: 8),
          TextFormField(
            controller: _titleController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'e.g., Website Redesign Project',
            ),
            validator: (value) {
              final v = value?.trim() ?? '';
              if (v.isEmpty) return 'Add a title';
              if (v.length < 3) return 'Title must be at least 3 characters';
              return null;
            },
          ),
          const SizedBox(height: 20),
          Text('Description', style: AppTextStyles.labelLarge),
          const SizedBox(height: 8),
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Describe the deliverables and expectations...',
            ),
            validator: (value) {
              final v = value?.trim() ?? '';
              if (v.isEmpty) return 'Add a description';
              if (v.length < 10) {
                return 'Description must be at least 10 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Text('Amount', style: AppTextStyles.labelLarge),
          const SizedBox(height: 8),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              CurrencyInputFormatter(),
            ],
            style: AppTextStyles.amountMedium,
            decoration: InputDecoration(
              hintText: '0.00',
              hintStyle: AppTextStyles.amountMedium.copyWith(
                color: colors.textTertiary,
              ),
              prefixText: '\u20A6  ',
              prefixStyle: AppTextStyles.amountMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            validator: (value) {
              final v = value?.trim() ?? '';
              if (v.isEmpty) return 'Add an amount';
              final parsed = double.tryParse(v.replaceAll(',', ''));
              if (parsed == null) return 'Enter a valid amount';
              if (parsed < 100_000) {
                return 'Amount must be at least \u20A6100,000.00';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPartiesStep() {
    final colors = context.colors;
    return Form(
      key: _partiesFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Role', style: AppTextStyles.h2),
          const SizedBox(height: 4),
          Text(
            'What is your role in this agreement?',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _RoleCard(
                  icon: Iconsax.money_send_copy,
                  title: 'Depositor',
                  subtitle: 'I\'m paying for a service',
                  isSelected: _role == 'depositor',
                  onTap: () => setState(() => _role = 'depositor'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _RoleCard(
                  icon: Iconsax.setting_2_copy,
                  title: 'Beneficiary',
                  subtitle: 'I\'m delivering a service',
                  isSelected: _role == 'beneficiary',
                  onTap: () => setState(() => _role = 'beneficiary'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text('Invite Other Party', style: AppTextStyles.h2),
          const SizedBox(height: 4),
          Text(
            'Enter their email or phone number',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _inviteController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email address or phone number',
              prefixIcon: Icon(
                Iconsax.user_add_copy,
                color: colors.textTertiary,
              ),
            ),
            validator: (value) {
              final v = value?.trim() ?? '';
              if (v.isEmpty) return 'Enter an email or phone number';
              if (_emailRegex.hasMatch(v) || _phoneRegex.hasMatch(v)) {
                return null;
              }
              return 'Enter a valid email or phone number';
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConditionsStep() {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Conditions', style: AppTextStyles.h2),
        const SizedBox(height: 4),
        Text(
          'What must be completed before funds are released?',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 8),
        // Info chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colors.infoLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(
                Iconsax.info_circle_copy,
                color: AppColors.info,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Both parties can add conditions. Each condition must specify who is responsible for fulfilling it.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.info,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Condition cards list
        if (_conditions.isEmpty) ...[
          _EmptyConditions(onAdd: () => _showAddConditionSheet()),
          if (_conditionsError) ...[
            const SizedBox(height: 8),
            Text(
              'Add at least one condition before continuing',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ],
        ] else ...[
          ...List.generate(_conditions.length, (index) {
            final condition = _conditions[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ConditionCreationCard(
                index: index,
                condition: condition,
                onEdit: () => _showAddConditionSheet(editIndex: index),
                onDelete: () {
                  setState(() => _conditions.removeAt(index));
                },
              ),
            );
          }),
          const SizedBox(height: 8),
          // Add another condition button
          GestureDetector(
            onTap: () => _showAddConditionSheet(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.add, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Add Condition',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showAddConditionSheet({int? editIndex}) {
    final isEditing = editIndex != null;
    final titleCtrl = TextEditingController(
      text: isEditing ? _conditions[editIndex]['title'] as String : '',
    );
    final descCtrl = TextEditingController(
      text: isEditing ? _conditions[editIndex]['description'] as String : '',
    );
    String? selectedParticipantId = isEditing
        ? (_conditions[editIndex]['requiredFrom'] as Map<String, dynamic>)['id']
              as String
        : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        String? titleError;
        String? participantError;
        return StatefulBuilder(
          builder: (builderContext, setSheetState) {
            final colors = builderContext.colors;
            return Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(builderContext).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colors.cardBorder,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Header
                      Text(
                        isEditing ? 'Edit Condition' : 'Add Condition',
                        style: AppTextStyles.h2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Define what needs to be done and who is responsible',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text('Title', style: AppTextStyles.labelLarge),
                      const SizedBox(height: 8),
                      TextField(
                        controller: titleCtrl,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'e.g., Deliver homepage mockup',
                          errorText: titleError,
                        ),
                        onChanged: (_) {
                          if (titleError != null) {
                            setSheetState(() => titleError = null);
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // Description
                      Text('Description', style: AppTextStyles.labelLarge),
                      const SizedBox(height: 8),
                      TextField(
                        controller: descCtrl,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Describe what this condition entails...',
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Required from — participant selector
                      Text('Required From', style: AppTextStyles.labelLarge),
                      const SizedBox(height: 4),
                      Text(
                        'Who must fulfill this condition?',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: _participants.map((participant) {
                          final isSelected =
                              selectedParticipantId == participant['id'];
                          final isMe = participant['id'] == 'me';
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: isMe ? 6 : 0,
                                left: isMe ? 0 : 6,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setSheetState(() {
                                    selectedParticipantId =
                                        participant['id'] as String;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colors.primarySurface
                                        : colors.background,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : colors.cardBorder,
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: isSelected
                                            ? AppColors.primary
                                            : colors.surfaceVariant,
                                        child: Text(
                                          participant['initials'] as String,
                                          style: AppTextStyles.labelMedium
                                              .copyWith(
                                                color: isSelected
                                                    ? Colors.white
                                                    : colors.textSecondary,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        isMe
                                            ? 'You'
                                            : _truncateName(
                                                participant['name'] as String,
                                              ),
                                        style: AppTextStyles.labelMedium
                                            .copyWith(
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : colors.textPrimary,
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w600,
                                            ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primary.withValues(
                                                  alpha: 0.1,
                                                )
                                              : colors.surfaceVariant,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          _capitalize(
                                            participant['role'] as String,
                                          ),
                                          style: AppTextStyles.labelSmall
                                              .copyWith(
                                                color: isSelected
                                                    ? AppColors.primary
                                                    : colors.textTertiary,
                                                fontSize: 9,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      if (participantError != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          participantError!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],

                      const SizedBox(height: 28),

                      // Save button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final titleEmpty = titleCtrl.text.trim().isEmpty;
                            final noParticipant = selectedParticipantId == null;
                            if (titleEmpty || noParticipant) {
                              setSheetState(() {
                                titleError = titleEmpty ? 'Add a title' : null;
                                participantError = noParticipant
                                    ? 'Select who must fulfill this condition'
                                    : null;
                              });
                              return;
                            }

                            final selectedParticipant = _participants
                                .firstWhere(
                                  (p) => p['id'] == selectedParticipantId,
                                );

                            final conditionData = {
                              'title': titleCtrl.text.trim(),
                              'description': descCtrl.text.trim(),
                              'requiredFrom': selectedParticipant,
                            };

                            setState(() {
                              if (isEditing) {
                                _conditions[editIndex] = conditionData;
                              } else {
                                _conditions.add(conditionData);
                              }
                            });

                            Navigator.pop(builderContext);
                          },
                          child: Text(
                            isEditing ? 'Save Changes' : 'Add Condition',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _truncateName(String name) {
    if (name.length <= 14) return name;
    return '${name.substring(0, 12)}...';
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

// ---- Supporting Widgets ----

class _EmptyConditions extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyConditions({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Iconsax.task_square_copy,
              color: colors.textTertiary,
              size: 28,
            ),
          ),
          const SizedBox(height: 14),
          Text('No Conditions Yet', style: AppTextStyles.h3),
          const SizedBox(height: 6),
          Text(
            'Add conditions that must be met\nbefore funds are released',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Iconsax.add, size: 18),
            label: const Text('Add Condition'),
          ),
        ],
      ),
    );
  }
}

class _ConditionCreationCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> condition;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ConditionCreationCard({
    required this.index,
    required this.condition,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final requiredFrom = condition['requiredFrom'] as Map<String, dynamic>;

    return GestureDetector(
      onTap: onEdit,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Index badge
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colors.primarySurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Title & description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        condition['title'] as String,
                        style: AppTextStyles.labelLarge,
                      ),
                      if ((condition['description'] as String).isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          condition['description'] as String,
                          style: AppTextStyles.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                // Actions
                GestureDetector(
                  onTap: onDelete,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      CupertinoIcons.xmark,
                      color: colors.textTertiary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Required from chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colors.primarySurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    child: Text(
                      requiredFrom['initials'] as String,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      requiredFrom['id'] == 'me'
                          ? 'Required from You (${_capitalize(requiredFrom['role'] as String)})'
                          : 'Required from ${requiredFrom['name']} (${_capitalize(requiredFrom['role'] as String)})',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? colors.primarySurface : colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : colors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : colors.textSecondary,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                color: isSelected ? AppColors.primary : colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int index;
  final int currentStep;
  final AppColorScheme colors;

  const _StepDot({
    required this.index,
    required this.currentStep,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index <= currentStep;
    final isComplete = index < currentStep;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : colors.surfaceVariant,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isComplete
            ? const Icon(Iconsax.tick_circle, color: Colors.white, size: 18)
            : Text(
                '${index + 1}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: isActive ? Colors.white : colors.textTertiary,
                ),
              ),
      ),
    );
  }
}
