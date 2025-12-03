import 'package:dio/dio.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import 'token_refresh_service.dart';

class AuthInterceptor extends QueuedInterceptorsWrapper {
  AuthInterceptor({
    required this.dio,
    required this.authLocalDataSource,
    required this.tokenRefreshService,
  });

  final Dio dio;
  final AuthLocalDataSource authLocalDataSource;
  final TokenRefreshService tokenRefreshService;

  var _isRefreshing = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    const unauthenticatedPaths = ['/auth/google'];

    if (unauthenticatedPaths.contains(options.path)) {
      return handler.next(options);
    }

    final accessToken = await authLocalDataSource.getAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;

    if (response?.statusCode == 401 &&
        response?.requestOptions.path != '/auth/refresh') {
      const unauthenticatedPaths = ['/auth/google'];

      if (unauthenticatedPaths.contains(err.requestOptions.path)) {
        return handler.next(err);
      }

      if (!_isRefreshing) {
        _isRefreshing = true;

        try {
          await tokenRefreshService.refreshToken();
        } catch (e) {
          _isRefreshing = false;
          return handler.next(err);
        }

        _isRefreshing = false;
      }

      final newAccessToken = await authLocalDataSource.getAccessToken();

      if (newAccessToken == null) {
        return handler.next(err);
      }

      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer $newAccessToken';

      try {
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioException catch (de) {
        return handler.next(de);
      }
    }

    return handler.next(err);
  }
}
