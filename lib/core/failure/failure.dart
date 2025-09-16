class Failure {
  const Failure({
    this.message = 'Terjadi kesalahan',
    this.statusCode = 500,
  });

  final String message;
  final int statusCode;
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

  final List<String> headers;
  final int hiddenColumnCount;
  final List<List<Map<String, dynamic>?>> rows;

  factory SpreadsheetFailure.fromJson(Map<String, dynamic> json) {
    return SpreadsheetFailure(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Terjadi kesalahan',
      headers: List<String>.from(json['data']['header'])..insert(0, 'Row'),
      hiddenColumnCount: json['data']['hide_column'],
      rows: List<dynamic>.from(json['data']['content'])
          .map((e) => List<Map<String, dynamic>?>.from(e['column'])
            ..insert(0, {'value': '${e['row']}'}))
          .toList(),
    );
  }
}
