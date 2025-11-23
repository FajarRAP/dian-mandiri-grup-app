import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/utils/respository_handler_mixin.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
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
      {required String refreshToken}) async {
    return await handleRepositoryRequest<String>(() async {
      final result =
          await authRemoteDataSource.refreshToken(refreshToken: refreshToken);
      await authLocalDataSource.cacheTokens(token: result);

      return result.message;
    });
  }

  @override
  Future<Either<Failure, String>> signIn() async {
    return await handleRepositoryRequest<String>(() async {
      final result = await authRemoteDataSource.signIn();
      await authLocalDataSource.cacheUser(user: result.user);
      await authLocalDataSource.cacheTokens(token: result.token);

      return result.token.message;
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
  Future<Either<Failure, String>> updateProfile({required String name}) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await authRemoteDataSource.updateProfile(name: name);

      return result;
    });
  }
}
