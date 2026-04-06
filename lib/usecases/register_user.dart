import 'package:adehun_mvp/domain/auth_repository.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/resources/usecase.dart';
import 'package:adehun_mvp/usecases/params/register_user_params.dart';

class RegisterUserUseCase
    implements UseCase<DataState<UserData>, RegisterUserParams> {
  final AuthRepository authRepository;

  RegisterUserUseCase(this.authRepository);

  @override
  Future<DataState<UserData>> call({RegisterUserParams? params}) async {
    return await authRepository.registerUser(
      userId: params!.userId,
      phoneNumber: params.phoneNumber,
      fullName: params.fullName,
    );
  }
}
