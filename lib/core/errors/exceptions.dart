import 'package:equatable/equatable.dart';

import '../utils/typedefs.dart';

abstract interface class BaseException extends Equatable implements Exception {
  const BaseException({
    required this.message,
    required this.code,
  });

  final String message;
  final int code;

  @override
  List<Object?> get props => [message, code];
}

class InternalException extends BaseException {
  const InternalException({
    super.message = 'An internal error occurred',
    super.code = 500,
  });
}

class NetworkException extends BaseException {
  const NetworkException({
    super.message = 'No internet connection',
    super.code = 503,
  });
}

class ServerException extends BaseException {
  const ServerException({
    super.message = 'A server error occurred',
    super.code = 500,
    this.errors,
  });

  final JsonMap? errors;

  @override
  List<Object?> get props => [...super.props, errors];
}

class CacheException extends BaseException {
  const CacheException({
    super.message = 'A cache error occurred',
    super.code = 500,
  });
}
