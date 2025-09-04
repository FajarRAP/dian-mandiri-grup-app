import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/helpers/helpers.dart';
import '../models/sign_in_response_model.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSources {
  Future<UserModel> fetchUser();
  Future<TokenModel> refreshToken({required String refreshToken});
  Future<SignInResponseModel> signIn();
  Future<String> signOut();
  Future<String> updateProfile({required String name});
}

class AuthRemoteDataSourcesImpl implements AuthRemoteDataSources {
  const AuthRemoteDataSourcesImpl({
    required this.dio,
    required this.googleSignIn,
  });

  final Dio dio;
  final GoogleSignIn googleSignIn;

  @override
  Future<UserModel> fetchUser() async {
    try {
      final response = await dio.get('v1/auth/me');

      return UserModel.fromJson(response.data['data']);
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<TokenModel> refreshToken({required String refreshToken}) async {
    try {
      final response = await dio.post(
        'v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      return TokenModel.fromJson(response.data);
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<SignInResponseModel> signIn() async {
    try {
      final googleSignInAccount = await googleSignIn.signIn();
      final googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      final googleAccessToken = googleSignInAuthentication?.accessToken;

      final response = await dio.post(
        'v1/auth/google',
        data: {'access_token': googleAccessToken},
      );

      return SignInResponseModel.fromJson(response.data);
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> signOut() async {
    try {
      final response = await dio.post('v1/auth/logout');
      await googleSignIn.signOut();

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> updateProfile({required String name}) async {
    try {
      final response = await dio.put(
        'auth/profile',
        data: {'name': name},
      );

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }
}
