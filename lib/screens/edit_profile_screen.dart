import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/controllers/profile_controller.dart';
import 'package:adehun_mvp/widgets/profile_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

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

  String _normalisePhone(String raw) =>
      raw.replaceAll(RegExp(r'[\s\-()]'), '');

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final ok = await ref
        .read(profileControllerProvider.notifier)
        .save(name: _name.text.trim(), phoneNumber: _normalisePhone(_phone.text));
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Profile updated')));
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
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error)));
        ref.read(profileControllerProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Edit Profile', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    SizedBox(
                      width: 96,
                      height: 96,
                      child: user?.profilePictureUrl != null
                          ? ProfileImage(image: user!.profilePictureUrl)
                          : CircleAvatar(
                              backgroundColor: colors.primarySurface,
                              child: Text(
                                user?.initials ?? '',
                                style: AppTextStyles.h1.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: profile.isBusy
                            ? null
                            : () => ref
                                  .read(profileControllerProvider.notifier)
                                  .changeAvatar(),
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: colors.background, width: 2),
                          ),
                          child: profile.isUploadingAvatar
                              ? const Padding(
                                  padding: EdgeInsets.all(8),
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
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text('Full name', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: 'Your name'),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.length < 2) return 'Enter at least 2 characters';
                  if (value.length > 80) return 'Keep it under 80 characters';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text('Phone number', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: '+234 801 234 5678'),
                validator: (v) {
                  final value = _normalisePhone(v ?? '');
                  if (!_phonePattern.hasMatch(value)) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Email: ${user?.email ?? ''}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.textTertiary,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: profile.isBusy ? null : _save,
                  child: profile.isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
