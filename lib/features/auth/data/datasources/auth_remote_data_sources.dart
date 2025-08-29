import 'package:dio/dio.dart';

import '../../../../core/common/constants.dart';

abstract class AuthRemoteDataSources<T> {
  Future<T> signIn({required String googleAccessToken});
  Future<T> signOut();
  Future<T> fetchUser();
  Future<T> refreshToken({required String refreshToken});
  Future<T> updateProfile({required String name});
}

class AuthRemoteDataSourcesImpl implements AuthRemoteDataSources<Response> {
  const AuthRemoteDataSourcesImpl({required this.dio});

  final Dio dio;

  @override
  Future<Response> fetchUser() async {
    return await dio.get('$authEndpoint/me');
  }

  @override
  Future<Response> refreshToken({required String refreshToken}) async {
    return await dio.post(
      '$authEndpoint/refresh',
      data: {'refresh_token': refreshToken},
    );
  }

  @override
  Future<Response> signIn({required String googleAccessToken}) async {
    return await dio.post(
      '$authEndpoint/google',
      data: {'access_token': googleAccessToken},
    );
  }

  @override
  Future<Response> signOut() async {
    return await dio.post('$authEndpoint/logout');
  }

  @override
  Future<Response> updateProfile({required String name}) async {
    return await dio.put('$authEndpoint/profile', data: {'name': name});
  }
}
