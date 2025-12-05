import 'package:dio/dio.dart';

import '../../../../core/network/dio_handler_mixin.dart';
import '../../../../core/services/google_sign_in_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/refresh_token_use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';
import '../models/sign_in_response_model.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserEntity> fetchUser();
  Future<TokenModel> refreshToken(RefreshTokenUseCaseParams params);
  Future<SignInResponseModel> signIn();
  Future<String> signOut();
  Future<String> updateProfile(UpdateProfileUseCaseParams params);
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
  Future<UserEntity> fetchUser() async {
    return await handleDioRequest<UserEntity>(() async {
      final response = await dio.get('/auth/me');

      return UserModel.fromJson(response.data['data']).toEntity();
    });
  }

  @override
  Future<TokenModel> refreshToken(RefreshTokenUseCaseParams params) async {
    return await handleDioRequest<TokenModel>(() async {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': params.refreshToken},
      );

      return TokenModel.fromJson(response.data);
    });
  }

  @override
  Future<SignInResponseModel> signIn() async {
    return await handleDioRequest<SignInResponseModel>(() async {
      final googleAccessToken = await googleSignIn.authenticate();
      final response = await dio.post(
        '/auth/google',
        data: {'access_token': googleAccessToken},
      );

      return SignInResponseModel.fromJson(response.data);
    });
  }

  @override
  Future<String> signOut() async {
    return await handleDioRequest<String>(() async {
      final response = await dio.post('/auth/logout');
      await googleSignIn.signOut();

      return response.data['message'];
    });
  }

  @override
  Future<String> updateProfile(UpdateProfileUseCaseParams params) async {
    return await handleDioRequest<String>(() async {
      final response = await dio.put(
        '/auth/profile',
        data: {'name': params.name},
      );

      return response.data['message'];
    });
  }
}
