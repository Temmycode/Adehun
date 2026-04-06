import 'dart:async';

import 'package:adehun_mvp/domain/auth_repository.dart';
import 'package:adehun_mvp/domain/models/login_response.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/resources/usecase.dart';

class GoogleSignInUseCase
    implements UseCase<DataState<LoginResponse>, void> {
  final AuthRepository authRepository;

  GoogleSignInUseCase(this.authRepository);

  @override
  Future<DataState<LoginResponse>> call({void params}) async {
    return await authRepository.googleSignIn();
  }
}
