class ServerException implements Exception {
  const ServerException({String? message, int? statusCode})
      : message = message ?? 'Terjadi Kesalahan Server',
        statusCode = statusCode ?? 500;

  final String message;
  final int statusCode;
}
