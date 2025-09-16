import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/auth_repositories.dart';

class UpdateProfileUseCase implements UseCase<String, String> {
  const UpdateProfileUseCase({required this.authRepositories});

  final AuthRepositories authRepositories;

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await authRepositories.updateProfile(name: params);
  }
}
