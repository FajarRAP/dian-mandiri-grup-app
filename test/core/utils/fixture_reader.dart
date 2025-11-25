import 'dart:io';

import 'package:equatable/equatable.dart';

class FixtureReader extends Equatable {
  const FixtureReader({this.path = 'test/fixtures', required this.domain});

  final String path;
  final String domain;

  String dataSource(String json) =>
      File('$path/$domain/datasources/$json').readAsStringSync();
  String model(String json) =>
      File('$path/$domain/models/$json').readAsStringSync();

  @override
  List<Object?> get props => [path, domain];
}
