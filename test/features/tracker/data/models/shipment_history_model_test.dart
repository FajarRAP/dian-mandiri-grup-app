import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_history_model.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_history_entity.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/tracker_test_data.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'tracker');
  final shipmentHistoryEntity = tShipmentHistoryEntity;
  final shipmentHistoryModel = tShipmentHistoryModel;

  group('shipment history model test', () {
    test('should be a subclass of ShipmentHistoryEntity', () {
      // assert
      expect(shipmentHistoryModel, isA<ShipmentHistoryEntity>());
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader.model('shipment_history.json');
      final json = jsonDecode(jsonString);

      // act
      final result = ShipmentHistoryModel.fromJson(json);

      // assert
      expect(result, shipmentHistoryModel);
    });

    test('should not bring implementation details', () {
      // assert
      expect(
          shipmentHistoryModel.toEntity(), isNot(isA<ShipmentHistoryModel>()));
      expect(shipmentHistoryModel.toEntity(), shipmentHistoryEntity);
    });
  });
}
