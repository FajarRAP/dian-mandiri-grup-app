import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exceptions/network_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/helpers/is_internet_connected.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoriesImpl implements AuthRepositories {
  final AuthRemoteDataSource authRemote;

  AuthRepositoriesImpl({required this.authRemote});

  @override
  Future<Either<Failure, UserEntity>> login(
      String email, String password) async {
    try {
      if (!await isInternetConnected()) throw NetworkException();

      final res = await authRemote.login(email, password);
      return Right(UserModel.fromUser(res.user!));
    } on AuthException catch (ae) {
      switch (ae.statusCode) {
        case '400':
          return Left(Failure(message: 'Email/Password Salah'));
        default:
          return Left(Failure(message: 'Ada Kesalahan'));
      }
    } on NetworkException catch (ne) {
      return Left(Failure(message: ne.message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
      String email, String password, int role) async {
    try {
      if (!await isInternetConnected()) throw NetworkException();

      final res = await authRemote.register(email, password, role);
      return Right(UserModel.fromUser(res.user!));
    } on AuthException catch (ae) {
      switch (ae.code) {
        case 'user_already_exists':
          return Left(Failure(message: 'Email telah digunakan'));
        case 'weak_password':
          return Left(Failure(message: 'Password minimal 6 karakter'));
        default:
          return Left(Failure(message: ae.message));
      }
    } on NetworkException catch (ne) {
      return Left(Failure(message: ne.message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(
      Map<String, dynamic> metadata) async {
    try {
      if (!await isInternetConnected()) throw NetworkException();

      final response =
          await authRemote.updateUser(UserAttributes(data: metadata));

      return Right(UserModel.fromUser(response.user!));
    } on NetworkException catch (ne) {
      return Left(Failure(message: ne.message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> resetPassword(
      String token, String email, String password) async {
    try {
      if (!await isInternetConnected()) throw NetworkException();

      // Dibalik layar langsung login
      await authRemote.verifyOTP(email, token);
      final response =
          await authRemote.updateUser(UserAttributes(password: password));

      return Right(UserModel.fromUser(response.user!));
    } on NetworkException catch (ne) {
      return Left(Failure(message: ne.message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> sendPasswordResetToken(String email) async {
    try {
      if (!await isInternetConnected()) throw NetworkException();

      await authRemote.sendPasswordResetToken(email);
      return const Right('Kode reset berhasil terkirim, silakan cek email');
    } on NetworkException catch (ne) {
      return Left(Failure(message: ne.message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> logout() async {
    try {
      if (!await isInternetConnected()) throw NetworkException();

      await authRemote.logout();
      return const Right('Berhasil logout');
    } on NetworkException catch (ne) {
      return Left(Failure(message: ne.message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
