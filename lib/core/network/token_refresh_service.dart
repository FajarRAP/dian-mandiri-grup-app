import 'package:dio/dio.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import 'auth_status_stream.dart';

class TokenRefreshService {
  const TokenRefreshService({
    required Dio cleanDio,
    required this.authLocalDataSource,
    required this.authStatusStream,
  }) : _dio = cleanDio;

  final Dio _dio;
  final AuthLocalDataSource authLocalDataSource;
  final AuthStatusStream authStatusStream;

  Future<String?> refreshToken() async {
    try {
      final refreshToken = await authLocalDataSource.getRefreshToken();

      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = response.data['data'];

      await authLocalDataSource.cacheTokens(
        accessToken: newAccessToken,
        refreshToken: refreshToken,
      );

      authStatusStream.setAuthenticated();

      return newAccessToken;
    } catch (e) {
      await authLocalDataSource.clearCache();
      authStatusStream.setUnauthenticated();
      return null;
    }
  }
}
