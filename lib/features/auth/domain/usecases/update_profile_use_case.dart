import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileUseCase implements AsyncUseCaseParams<String, String> {
  const UpdateProfileUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await authRepository.updateProfile(name: params);
  }
}
