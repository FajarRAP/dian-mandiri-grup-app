import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/auth_repository.dart';

class RefreshTokenUseCase implements AsyncUseCaseParams<String, String> {
  const RefreshTokenUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await authRepository.refreshToken(refreshToken: params);
  }
}
