import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_entity.dart';
import '../usecases/refresh_token_use_case.dart';
import '../usecases/update_profile_use_case.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> signIn();
  Future<Either<Failure, String>> signOut();
  Future<Either<Failure, UserEntity>> fetchUser();
  Future<Either<Failure, String>> refreshToken(
      RefreshTokenUseCaseParams params);
  Future<Either<Failure, UserEntity?>> fetchUserFromStorage();
  Future<Either<Failure, String>> updateProfile(
      UpdateProfileUseCaseParams params);
}
