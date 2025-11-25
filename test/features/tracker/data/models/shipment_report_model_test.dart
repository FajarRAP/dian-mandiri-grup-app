import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_report_model.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_report_entity.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/tracker_test_data.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'tracker');
  final shipmentReportEntity = tShipmentReportEntity;
  final shipmentReportModel = tShipmentReportModel;

  group('shipment report model test', () {
    test('should be a subclass of ShipmentReportEntity', () {
      // assert
      expect(shipmentReportModel, isA<ShipmentReportEntity>());
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader.model('shipment_report.json');
      final json = jsonDecode(jsonString);

      // act
      final result = ShipmentReportModel.fromJson(json);

      // assert
      expect(result, shipmentReportModel);
    });

    test('should not bring implementation details', () {
      // assert
      expect(shipmentReportModel.toEntity(), isNot(isA<ShipmentReportModel>()));
      expect(shipmentReportModel.toEntity(), shipmentReportEntity);
    });
  });
}
