import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import '../utils/typedefs.dart';

mixin DioHandlerMixin {
  Future<T> handleDioRequest<T>(Future<T> Function() function) async {
    try {
      return await function();
    } on DioException catch (de) {
      switch (de.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
          throw NetworkException(
            message: 'Network Error: ${de.message}',
            code: de.response?.statusCode ?? 503,
          );

        case DioExceptionType.badResponse:
          final data = de.response?.data;
          final isMap = data is JsonMap;
          final message = switch (data) {
            final JsonMap json => json['message'] ?? 'Server Error',
            final String str => str.length > 100 ? str.substring(0, 100) : str,
            _ => 'Server Error',
          };

          throw ServerException(
            message: message,
            errors: isMap ? data : null,
            code: de.response?.statusCode ?? 400,
          );
        case DioExceptionType.cancel:
          throw const InternalException(message: 'Request was cancelled');
        case DioExceptionType.badCertificate:
          throw const InternalException(message: 'Bad certificate');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      if (e is NetworkException) rethrow;
      throw InternalException(message: '$e');
    }
  }
}
