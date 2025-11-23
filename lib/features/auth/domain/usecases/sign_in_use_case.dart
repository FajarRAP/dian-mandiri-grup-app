import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase implements UseCase<String, NoParams> {
  const SignInUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await authRepository.signIn();
  }
}
