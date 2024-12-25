import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class FetchUserUseCase implements AsyncUseCaseNoParams<UserEntity> {
  const FetchUserUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, UserEntity>> call() async {
    return authRepository.fetchUser();
  }
}
