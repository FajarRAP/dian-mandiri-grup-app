import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/auth_repository.dart';

class RefreshTokenUseCase
    implements UseCase<String, RefreshTokenUseCaseParams> {
  const RefreshTokenUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, String>> call(RefreshTokenUseCaseParams params) async {
    return await authRepository.refreshToken(params);
  }
}

class RefreshTokenUseCaseParams extends Equatable {
  const RefreshTokenUseCaseParams({required this.refreshToken});

  final String refreshToken;

  @override
  List<Object?> get props => [refreshToken];
}
