import 'package:flutter/foundation.dart';

class ServerException implements Exception {
  const ServerException({String? message, int? statusCode})
      : message = (kDebugMode ? message : null) ?? 'Terjadi Kesalahan Server',
        statusCode = statusCode ?? 500;

  final String message;
  final int statusCode;
}
