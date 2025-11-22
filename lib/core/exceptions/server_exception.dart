class ServerException implements Exception {
  const ServerException({
    String? message,
    int? statusCode,
    this.errors,
  })  : message = message ?? 'Terjadi Kesalahan Server',
        statusCode = statusCode ?? 500;

  final String message;
  final int statusCode;
  final Map<String, dynamic>? errors;
}
