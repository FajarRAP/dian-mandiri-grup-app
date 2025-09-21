import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_report_model.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_report_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tShipmentReportModel = ShipmentReportModel(
      id: 'id',
      file: 'file',
      name: 'name',
      status: 'status',
      date: DateTime.now());

  group('shipment report model test', () {
    test('should be a subclass of ShipmentReportEntity', () {
      expect(tShipmentReportModel, isA<ShipmentReportEntity>());
    });

    test('should not bring implementation details', () {
      expect(tShipmentReportModel.toEntity(), isA<ShipmentReportEntity>());
      expect(
          tShipmentReportModel.toEntity(), isNot(isA<ShipmentReportModel>()));
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader('models/shipment_report.json');
      final json = jsonDecode(jsonString);

      // act
      final result = ShipmentReportModel.fromJson(json);

      // assert
      expect(result.toEntity(), isA<ShipmentReportEntity>());
    });
  });
}
