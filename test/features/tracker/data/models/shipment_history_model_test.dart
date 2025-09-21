import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_history_model.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_history_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tShipmentHistoryModel = ShipmentHistoryModel(
    id: 'id',
    receiptNumber: 'receiptNumber',
    courier: 'courier',
    date: DateTime.now(),
    stages: [],
  );

  group('shipment history model test', () {
    test('should be a subclass of ShipmentHistoryEntity', () {
      expect(tShipmentHistoryModel, isA<ShipmentHistoryEntity>());
    });

    test('should not bring implementation details', () {
      expect(tShipmentHistoryModel.toEntity(), isA<ShipmentHistoryEntity>());
      expect(
          tShipmentHistoryModel.toEntity(), isNot(isA<ShipmentHistoryModel>()));
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader('models/shipment_history.json');
      final json = jsonDecode(jsonString);

      // act
      final result = ShipmentHistoryModel.fromJson(json);

      // assert
      expect(result.toEntity(), isA<ShipmentHistoryEntity>());
    });
  });
}
