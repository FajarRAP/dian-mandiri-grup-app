import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../entities/user_entity.dart';

abstract class AuthRepositories {
  Future<Either<Failure, String>> signIn();
  Future<Either<Failure, String>> signOut();
  Future<Either<Failure, UserEntity>> fetchUser();
  Future<Either<Failure, String>> refreshToken({required String refreshToken});
  Future<Either<Failure, UserEntity>> fetchUserFromStorage();
  Future<Either<Failure, String>> updateProfile({required String name});
}
