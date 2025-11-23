import 'package:dio/dio.dart';

import '../../../../core/network/dio_handler_mixin.dart';
import '../../../../core/services/google_sign_in_service.dart';
import '../models/sign_in_response_model.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> fetchUser();
  Future<TokenModel> refreshToken({required String refreshToken});
  Future<SignInResponseModel> signIn();
  Future<String> signOut();
  Future<String> updateProfile({required String name});
}

class AuthRemoteDataSourceImpl
    with DioHandlerMixin
    implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required this.dio,
    required this.googleSignIn,
  });

  final Dio dio;
  final GoogleSignInService googleSignIn;

  @override
  Future<UserModel> fetchUser() async {
    return await handleDioRequest<UserModel>(() async {
      final response = await dio.get('v1/auth/me');

      return UserModel.fromJson(response.data['data']);
    });
  }

  @override
  Future<TokenModel> refreshToken({required String refreshToken}) async {
    return await handleDioRequest<TokenModel>(() async {
      final response = await dio.post(
        'v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      return TokenModel.fromJson(response.data);
    });
  }

  @override
  Future<SignInResponseModel> signIn() async {
    return await handleDioRequest<SignInResponseModel>(() async {
      final googleAccessToken = await googleSignIn.authenticate();
      final response = await dio.post(
        'v1/auth/google',
        data: {'access_token': googleAccessToken},
      );

      return SignInResponseModel.fromJson(response.data);
    });
  }

  @override
  Future<String> signOut() async {
    return await handleDioRequest<String>(() async {
      final response = await dio.post('v1/auth/logout');
      await googleSignIn.signOut();

      return response.data['message'];
    });
  }

  @override
  Future<String> updateProfile({required String name}) async {
    return await handleDioRequest<String>(() async {
      final response = await dio.put(
        'v1/auth/profile',
        data: {'name': name},
      );

      return response.data['message'];
    });
  }
}
