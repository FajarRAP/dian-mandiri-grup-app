import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/cache_exception.dart';
import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this.authLocalDataSource,
    required this.authRemoteDataSource,
  });

  final AuthLocalDataSource authLocalDataSource;
  final AuthRemoteDataSource authRemoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> fetchUser() async {
    try {
      final result = await authRemoteDataSource.fetchUser();

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on CacheException catch (ce) {
      return Left(CacheFailure(
        message: ce.message,
        statusCode: ce.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> fetchUserFromStorage() async {
    try {
      final result = await authLocalDataSource.getUser();

      if (result == null) {
        return Left(CacheFailure(
          message: 'No user found in storage',
          statusCode: 404,
        ));
      }

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on CacheException catch (ce) {
      return Left(CacheFailure(
        message: ce.message,
        statusCode: ce.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken(
      {required String refreshToken}) async {
    try {
      final result =
          await authRemoteDataSource.refreshToken(refreshToken: refreshToken);
      await authLocalDataSource.cacheTokens(token: result);

      return Right(result.message);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on CacheException catch (ce) {
      return Left(CacheFailure(
        message: ce.message,
        statusCode: ce.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> signIn() async {
    try {
      final result = await authRemoteDataSource.signIn();
      await authLocalDataSource.cacheUser(user: result.user);
      await authLocalDataSource.cacheTokens(token: result.token);

      return Right(result.token.message);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on CacheException catch (ce) {
      return Left(CacheFailure(
        message: ce.message,
        statusCode: ce.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> signOut() async {
    try {
      final result = await authRemoteDataSource.signOut();
      await authLocalDataSource.clearCache();

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on CacheException catch (ce) {
      return Left(CacheFailure(
        message: ce.message,
        statusCode: ce.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> updateProfile({required String name}) async {
    try {
      final result = await authRemoteDataSource.updateProfile(name: name);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on CacheException catch (ce) {
      return Left(CacheFailure(
        message: ce.message,
        statusCode: ce.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }
}
