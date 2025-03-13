import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../service_container.dart';
import '../common/constants.dart';

class DioInterceptor implements Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final storage = getIt.get<FlutterSecureStorage>();
    final refreshToken = await storage.read(key: refreshTokenKey);
    final authRepository = getIt.get<AuthRepository>();

    if (err.response?.statusCode == 401) {
      if (err.requestOptions.path == '$authEndpoint/refresh') {
        await storage.deleteAll();
      } else if (refreshToken != null) {
        await authRepository.refreshToken(refreshToken: refreshToken);
      }
    }

    return handler.next(err);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final storage = getIt.get<FlutterSecureStorage>();
    final accessToken = await storage.read(key: accessTokenKey);

    if (options.path != '$authEndpoint/refresh') {
      options.headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final storage = getIt.get<FlutterSecureStorage>();
    if (response.requestOptions.path == '$authEndpoint/refresh' &&
        response.statusCode == 401) {
      await storage.deleteAll();
    }

    return handler.next(response);
  }
}
