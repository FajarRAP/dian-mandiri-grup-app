import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileUseCase
    implements UseCase<String, UpdateProfileUseCaseParams> {
  const UpdateProfileUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, String>> execute(
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
