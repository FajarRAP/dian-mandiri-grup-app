import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/auth_repository.dart';

class GetRefreshTokenUseCase implements UseCase<String?, NoParams> {
  const GetRefreshTokenUseCase({required this.authRepository});

  final AuthRepository authRepository;
  @override
  Future<Either<Failure, String?>> execute(NoParams params) async {
    return await authRepository.getRefreshToken();
  }
}
