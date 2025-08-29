import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../service_container.dart';
import '../common/constants.dart';

class DioInterceptor implements Interceptor {
  final _storage = getIt.get<FlutterSecureStorage>();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final refreshToken = await _storage.read(key: refreshTokenKey);

    if (err.response?.statusCode == 401) {
      if (err.requestOptions.path == '$authEndpoint/refresh') {
        await _storage.deleteAll();
        getIt.get<AuthCubit>().refreshTokenExpired();
      } else if (refreshToken != null) {
        await getIt
            .get<AuthRepository>()
            .refreshToken(refreshToken: refreshToken);
        final accessToken = await _storage.read(key: accessTokenKey);
        return handler.resolve(await Dio().fetch(err.requestOptions
          ..headers['Authorization'] = 'Bearer $accessToken'));
      }
    }

    return handler.next(err);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _storage.read(key: accessTokenKey);

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
    if (response.requestOptions.path == '$authEndpoint/refresh' &&
        response.statusCode == 401) {
      await _storage.deleteAll();
    }

    return handler.next(response);
  }
}
