import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/utils/respository_handler_mixin.dart';
import '../../domain/entities/sign_in_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/refresh_token_use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl with RepositoryHandlerMixin implements AuthRepository {
  const AuthRepositoryImpl({
    required this.authLocalDataSource,
    required this.authRemoteDataSource,
  });

  final AuthLocalDataSource authLocalDataSource;
  final AuthRemoteDataSource authRemoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> fetchUser() async {
    return await handleRepositoryRequest<UserEntity>(() async {
      final result = await authRemoteDataSource.fetchUser();

      return result;
    });
  }

  @override
  Future<Either<Failure, UserEntity?>> fetchUserFromStorage() async {
    return await handleRepositoryRequest<UserEntity?>(() async {
      final result = await authLocalDataSource.getUser();

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> refreshToken(
    RefreshTokenUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await authRemoteDataSource.refreshToken(params);
      await authLocalDataSource.cacheTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );

      return result.message;
    });
  }

  @override
  Future<Either<Failure, SignInEntity>> signIn() async {
    return await handleRepositoryRequest<SignInEntity>(() async {
      final result = await authRemoteDataSource.signIn();
      await authLocalDataSource.cacheUser(user: result.user);
      await authLocalDataSource.cacheTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );

      return SignInEntity(
        message: result.message,
        user: result.user.toEntity(),
      );
    });
  }

  @override
  Future<Either<Failure, String>> signOut() async {
    return await handleRepositoryRequest<String>(() async {
      final result = await authRemoteDataSource.signOut();
      await authLocalDataSource.clearCache();

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> updateProfile(
    UpdateProfileUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await authRemoteDataSource.updateProfile(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, String?>> getRefreshToken() async {
    return await handleRepositoryRequest<String?>(() async {
      final result = await authLocalDataSource.getRefreshToken();

      return result;
    });
  }
}
