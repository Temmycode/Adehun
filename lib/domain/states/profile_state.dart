import 'package:flutter/foundation.dart' show immutable;

@immutable
class ProfileState {
  final bool isSaving;
  final bool isUploadingAvatar;
  final String? errorMessage;

  const ProfileState({
    this.isSaving = false,
    this.isUploadingAvatar = false,
    this.errorMessage,
  });

  bool get isBusy => isSaving || isUploadingAvatar;

  ProfileState copyWith({
    bool? isSaving,
    bool? isUploadingAvatar,
    String? Function()? errorMessage,
  }) {
    return ProfileState(
      isSaving: isSaving ?? this.isSaving,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
