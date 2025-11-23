import 'package:equatable/equatable.dart';

import '../utils/typedefs.dart';

class Failure extends Equatable {
  const Failure({
    this.message = 'Terjadi kesalahan',
    this.statusCode = 500,
  });

  final String message;
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message,
    super.statusCode,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message,
    super.statusCode,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message,
    super.statusCode,
  });
}

class SpreadsheetFailure extends Failure {
  const SpreadsheetFailure({
    super.statusCode,
    required super.message,
    required this.headers,
    required this.hiddenColumnCount,
    required this.rows,
  });

  factory SpreadsheetFailure.fromJson(Map<String, dynamic> json) {
    return SpreadsheetFailure(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Terjadi kesalahan',
      headers: List<String>.from(json['data']['header'])..insert(0, 'Row'),
      hiddenColumnCount: json['data']['hide_column'],
      rows: List<dynamic>.from(json['data']['content'])
          .map((e) => ListJsonMap.from(e['column'])
            ..insert(0, {'value': '${e['row']}'}))
          .toList(),
    );
  }

  final List<String> headers;
  final int hiddenColumnCount;
  final List<ListJsonMap> rows;

  @override
  List<Object?> get props => [...super.props, headers, hiddenColumnCount, rows];
}
