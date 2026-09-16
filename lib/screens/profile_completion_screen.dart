import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/providers/auth_providers.dart';
import 'package:adehun_mvp/usecases/params/register_user_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_buttons.dart';
import '../widgets/avatar_initials.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/labeled_field.dart';
import '../widgets/step_indicator.dart';

class ProfileCompletionScreen extends ConsumerStatefulWidget {
  const ProfileCompletionScreen({super.key});

  @override
  ConsumerState<ProfileCompletionScreen> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState
    extends ConsumerState<ProfileCompletionScreen> {
  late final TextEditingController _nameController;
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).userData;
    _nameController = TextEditingController(text: user?.name?.trim() ?? '');
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final user = ref.read(authControllerProvider).userData;
    if (!_formKey.currentState!.validate() || user == null) return;
    await ref.read(authControllerProvider.notifier).registerUser(
          RegisterUserParams(
            userId: user.id!,
            phoneNumber: _phoneController.text.trim(),
            fullName: _nameController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLoading = ref.watch(authLoadingProvider);
    final user = ref.watch(authControllerProvider).userData;
    final previewName = _nameController.text.trim().isEmpty
        ? user?.name
        : _nameController.text;

    return Scaffold(
      backgroundColor: colors.background,
      bottomNavigationBar: BottomActionBar(
        primary: PrimaryButton(
          label: 'Continue',
          loading: isLoading,
          onPressed: _submit,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.lg,
            AppSpacing.gutter,
            AppSpacing.xxl,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepIndicator(
                  current: 1,
                  labels: ['Sign in', 'Your details'],
                ),
                const SizedBox(height: AppSpacing.xxxl),
                Text(
                  'Nice to meet you',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Two quick details and you can start your first agreement.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                Center(
                  child: AvatarInitials(
                    name: previewName,
                    imageUrl: user?.profilePictureUrl,
                    size: 88,
                    showBorder: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                LabeledField(
                  label: 'Full name',
                  hint: 'How the other party will see you',
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  prefix: const Icon(Iconsax.user_copy),
                  validator: (value) {
                    if (value == null || value.trim().length < 2) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                LabeledField(
                  label: 'Phone number',
                  hint: '801 234 5678',
                  helper:
                      "We'll text you when the other party accepts, funds or approves. It's also needed for withdrawals.",
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onSubmitted: (_) => _submit(),
                  prefix: Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.lg,
                      right: AppSpacing.sm,
                    ),
                    child: Text(
                      '+234',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  validator: (value) {
                    final digits = (value ?? '').trim();
                    if (digits.length < 7) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
