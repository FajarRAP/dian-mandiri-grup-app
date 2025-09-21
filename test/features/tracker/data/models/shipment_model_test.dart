import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_model.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tShipmentModel = ShipmentModel(
      id: 'id',
      courier: 'courier',
      date: DateTime.now(),
      receiptNumber: 'receiptNumber');

  group('shipment model test', () {
    test('should be a subclass of ShipmentEntity', () {
      expect(tShipmentModel, isA<ShipmentEntity>());
    });

    test('should not bring implementation details', () {
      expect(tShipmentModel.toEntity(), isA<ShipmentEntity>());
      expect(tShipmentModel.toEntity(), isNot(isA<ShipmentModel>()));
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader('models/shipment.json');
      final json = jsonDecode(jsonString);

      // act
      final result = ShipmentModel.fromJson(json);

      // assert
      expect(result.toEntity(), isA<ShipmentEntity>());
    });
  });
}
