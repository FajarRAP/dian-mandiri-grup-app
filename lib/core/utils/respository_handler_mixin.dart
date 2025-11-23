import 'package:dartz/dartz.dart';

import '../errors/exceptions.dart';
import '../failure/failure.dart';

mixin RepositoryHandlerMixin {
  Future<Either<Failure, T>> handleRepositoryRequest<T>(
      Future<T> Function() function,
      {Failure? Function(ServerException se)? onServerException}) async {
    try {
      final result = await function();

      return Right(result);
    } on CacheException catch (ce) {
      return Left(CacheFailure(
        message: ce.message,
        statusCode: ce.code,
      ));
    } on NetworkException catch (ne) {
      return Left(NetworkFailure(
        message: ne.message,
        statusCode: ne.code,
      ));
    } on ServerException catch (se) {
      if (onServerException != null) {
        final customFailure = onServerException(se);

        if (customFailure != null) {
          return Left(customFailure);
        }
      }
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.code,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.code,
      ));
    } catch (e) {
      return Left(Failure(
        message: '$e',
        statusCode: 0,
      ));
    }
  }
}
