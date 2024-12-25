import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase implements AsyncUseCaseNoParams<String> {
  const SignOutUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, String>> call() async {
    return await authRepository.signOut();
  }
}
