import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_model.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_entity.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/tracker_test_data.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'tracker');
  final shipmentEntity = tShipmentEntity;
  final shipmentModel = tShipmentModel;

  group('shipment model test', () {
    test('should be a subclass of ShipmentEntity', () {
      // assert
      expect(shipmentModel, isA<ShipmentEntity>());
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader.model('shipment.json');
      final json = jsonDecode(jsonString);

      // act
      final result = ShipmentModel.fromJson(json);

      // assert
      expect(result, shipmentModel);
    });

    test('should not bring implementation details', () {
      // assert
      expect(shipmentModel.toEntity(), isNot(isA<ShipmentModel>()));
      expect(shipmentModel.toEntity(), shipmentEntity);
    });
  });
}
