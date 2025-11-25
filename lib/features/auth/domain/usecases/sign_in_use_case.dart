import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/sign_in_entity.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase implements UseCase<SignInEntity, NoParams> {
  const SignInUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, SignInEntity>> execute(NoParams params) async {
    return await authRepository.signIn();
  }
}
