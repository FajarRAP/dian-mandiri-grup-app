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
    super.message = 'Terjadi kesalahan internal',
    super.code = 500,
  });
}

class NetworkException extends BaseException {
  const NetworkException({
    super.message = 'Tidak ada koneksi internet',
    super.code = 503,
  });
}

class ServerException extends BaseException {
  const ServerException({
    super.message = 'Terjadi kesalahan server',
    super.code = 500,
    this.errors,
  });

  final JsonMap? errors;

  @override
  List<Object?> get props => [...super.props, errors];
}

class CacheException extends BaseException {
  const CacheException({
    super.message = 'Terjadi kesalahan cache',
    super.code = 500,
  });
}
