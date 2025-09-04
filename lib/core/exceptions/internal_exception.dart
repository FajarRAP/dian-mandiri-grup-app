class InternalException implements Exception {
  const InternalException({String? message, int? statusCode})
      : message = message ?? 'Terjadi Kesalahan Internal',
        statusCode = statusCode ?? 500;

  final String message;
  final int statusCode;
}
