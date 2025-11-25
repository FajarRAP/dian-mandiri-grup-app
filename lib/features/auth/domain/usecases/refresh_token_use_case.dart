import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/auth_repository.dart';

class RefreshTokenUseCase
    implements UseCase<String, RefreshTokenUseCaseParams> {
  const RefreshTokenUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, String>> execute(
      RefreshTokenUseCaseParams params) async {
    return await authRepository.refreshToken(params);
  }
}

class RefreshTokenUseCaseParams extends Equatable {
  const RefreshTokenUseCaseParams({required this.refreshToken});

  final String refreshToken;

  @override
  List<Object?> get props => [refreshToken];
}
