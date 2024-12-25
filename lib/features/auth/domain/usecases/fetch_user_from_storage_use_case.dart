import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class FetchUserFromStorageUseCase implements AsyncUseCaseNoParams<UserEntity> {
  const FetchUserFromStorageUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, UserEntity>> call() async {
    return await authRepository.fetchUserFromStorage();
  }
}
