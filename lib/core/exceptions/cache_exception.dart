class CacheException implements Exception {
  const CacheException({String? message, int? statusCode})
      : message = message ?? 'Terjadi Kesalahan Cache',
        statusCode = statusCode ?? 500;

  final String message;
  final int statusCode;
}
