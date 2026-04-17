import 'dart:async';

import 'package:adehun_mvp/domain/auth_repository.dart';
import 'package:adehun_mvp/domain/models/login_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/usecase.dart';
import 'package:adehun_mvp/usecases/params/register_from_invite_params.dart';

class RegisterFromInviteUseCase
    implements UseCase<DataState<LoginResponse>, RegisterFromInviteParams> {
  final AuthRepository authRepository;

  RegisterFromInviteUseCase(this.authRepository);

  @override
  Future<DataState<LoginResponse>> call({RegisterFromInviteParams? params}) {
    return authRepository.registerFromInvite(
      params!.idToken,
      params.invitationToken,
    );
  }
}
