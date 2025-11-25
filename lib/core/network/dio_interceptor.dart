import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../service_container.dart';
import '../common/constants.dart';

class DioInterceptor implements Interceptor {
  final _storage = getIt.get<FlutterSecureStorage>();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await _storage.read(key: refreshTokenKey);
      final authCubit = getIt.get<AuthCubit>();

      if (err.requestOptions.path.endsWith('/refresh')) {
        await _storage.deleteAll();
        authCubit.refreshTokenExpired();
        return handler.next(err);
      }

      try {
        await authCubit.refreshToken(refreshToken: refreshToken);
        final newAccessToken = await _storage.read(key: accessTokenKey);
        final newOptions = err.requestOptions
          ..headers['Authorization'] = 'Bearer $newAccessToken';
        final response = await Dio().fetch(newOptions);

        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _storage.read(key: accessTokenKey);
    final isLogin = options.path.endsWith('/google');
    final isRefresh = options.path.endsWith('/refresh');

    if (accessToken != null && !isLogin && !isRefresh) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    options.headers['Accept'] = 'application/json';
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.requestOptions.path == '/auth/refresh' &&
        response.statusCode == 401) {
      await _storage.deleteAll();
    }

    return handler.next(response);
  }
}
