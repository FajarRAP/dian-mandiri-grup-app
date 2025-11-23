import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class FetchUserFromStorageUseCase implements UseCase<UserEntity?, NoParams> {
  const FetchUserFromStorageUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, UserEntity?>> execute(NoParams params) async {
    return await authRepository.fetchUserFromStorage();
  }
}
