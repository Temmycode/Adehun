import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_toast.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/avatar_initials.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/labeled_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;

  static final _phonePattern = RegExp(r'^\+?[0-9]{7,15}$');

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).userData;
    _name = TextEditingController(text: user?.name ?? '');
    _phone = TextEditingController(text: user?.phoneNumber ?? '');
    _name.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileControllerProvider.notifier).refreshFromServer();
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  String _normalisePhone(String raw) => raw.replaceAll(RegExp(r'[\s\-()]'), '');

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final ok = await ref
        .read(profileControllerProvider.notifier)
        .save(name: _name.text.trim(), phoneNumber: _normalisePhone(_phone.text));
    if (!mounted) return;
    if (ok) {
      showAppToast(context, 'Profile updated', kind: ToastKind.success);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final profile = ref.watch(profileControllerProvider);
    final user = ref.watch(authControllerProvider).userData;

    ref.listen(profileControllerProvider, (prev, next) {
      final error = next.errorMessage;
      if (error != null && error != prev?.errorMessage) {
        showAppToast(context, error, kind: ToastKind.error);
        ref.read(profileControllerProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AppTopBar(title: 'Edit profile'),
      bottomNavigationBar: BottomActionBar(
        primary: PrimaryButton(
          label: 'Save changes',
          loading: profile.isSaving,
          onPressed: profile.isBusy ? null : _save,
        ),
      ),
      body: SingleChildScrollView(
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
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AvatarInitials(
                      name: _name.text.trim().isEmpty ? user?.name : _name.text,
                      imageUrl: user?.profilePictureUrl,
                      size: 96,
                      showBorder: true,
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Semantics(
                        button: true,
                        label: 'Change photo',
                        child: Material(
                          color: AppColors.primary,
                          shape: CircleBorder(
                            side: BorderSide(color: colors.background, width: 3),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: profile.isBusy
                                ? null
                                : () => ref
                                    .read(profileControllerProvider.notifier)
                                    .changeAvatar(),
                            child: SizedBox(
                              width: 36,
                              height: 36,
                              child: profile.isUploadingAvatar
                                  ? const Padding(
                                      padding: EdgeInsets.all(9),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Iconsax.camera,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              LabeledField(
                label: 'Full name',
                hint: 'Your name',
                controller: _name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                prefix: const Icon(Iconsax.user_copy),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.length < 2) return 'Enter at least 2 characters';
                  if (value.length > 80) return 'Keep it under 80 characters';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              LabeledField(
                label: 'Phone number',
                hint: '+234 801 234 5678',
                helper: 'Used for withdrawal confirmations and updates.',
                controller: _phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                prefix: const Icon(Iconsax.call_copy),
                onSubmitted: (_) => _save(),
                validator: (v) {
                  if (!_phonePattern.hasMatch(_normalisePhone(v ?? ''))) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              LabeledField(
                label: 'Email',
                initialValue: user?.email ?? '',
                enabled: false,
                helper: 'Your email comes from Google and cannot be changed here.',
                prefix: const Icon(Iconsax.sms_copy),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
