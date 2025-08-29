import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../datasources/auth_remote_data_sources.dart';
import '../models/user_model.dart';

class AuthRepositoriesImpl implements AuthRepositories {
  const AuthRepositoriesImpl({
    required this.authRemoteDataSource,
    required this.googleSignIn,
    required this.storage,
  });

  final AuthRemoteDataSources<Response> authRemoteDataSource;
  final GoogleSignIn googleSignIn;
  final FlutterSecureStorage storage;

  @override
  Future<Either<Failure, UserEntity>> fetchUser() async {
    try {
      final response = await authRemoteDataSource.fetchUser();

      return Right(UserModel.fromJson(response.data['data']));
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          return Left(Failure());
      }
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> fetchUserFromStorage() async {
    try {
      final user = await storage.read(key: userKey);

      return Right(UserModel.fromJson(jsonDecode('$user')));
    } catch (e) {
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken(
      {required String refreshToken}) async {
    try {
      final response =
          await authRemoteDataSource.refreshToken(refreshToken: refreshToken);
      final data = response.data['data'];

      await storage.write(key: accessTokenKey, value: data['access_token']);
      await storage.write(key: refreshTokenKey, value: data['refresh_token']);

      return Right(response.data['message']);
    } catch (e) {
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn() async {
    try {
      final googleSignInAccount = await googleSignIn.signIn();
      final googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      final response = await authRemoteDataSource.signIn(
          googleAccessToken: '${googleSignInAuthentication?.accessToken}');
      final data = response.data['data'];

      await storage.write(key: userKey, value: jsonEncode(data['user']));
      await storage.write(key: accessTokenKey, value: data['access_token']);
      await storage.write(key: refreshTokenKey, value: data['refresh_token']);

      // Too lazy to change repositories return type, so i used TopSnackbar here without context
      TopSnackbar.successSnackbar(message: response.data['message']);

      return Right(UserModel.fromJson(data['user']));
    } on DioException {
      await googleSignIn.signOut();
      return const Left(Failure());
    } catch (e) {
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> signOut() async {
    try {
      final response = await authRemoteDataSource.signOut();

      await googleSignIn.signOut();
      await storage.deleteAll();

      return Right(response.data['message']);
    } catch (e) {
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> updateProfile({required String name}) async {
    try {
      final response = await authRemoteDataSource.updateProfile(name: name);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          return const Left(Failure());
      }
    } catch (e) {
      return const Left(Failure());
    }
  }
}
