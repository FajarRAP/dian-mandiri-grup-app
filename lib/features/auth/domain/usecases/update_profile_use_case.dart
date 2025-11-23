import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileUseCase
    implements UseCase<String, UpdateProfileUseCaseParams> {
  const UpdateProfileUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, String>> call(
      UpdateProfileUseCaseParams params) async {
    return await authRepository.updateProfile(params);
  }
}

class UpdateProfileUseCaseParams extends Equatable {
  const UpdateProfileUseCaseParams({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}
