import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_user_model.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_user_entity.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/tracker_test_data.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'tracker');
  const shipmentUserEntity = tShipmentUserEntity;
  const shipmentUserModel = tShipmentUserModel;

  group('shipment user model test', () {
    test('should be a subclass of ShipmentUserEntity', () {
      // assert
      expect(shipmentUserModel, isA<ShipmentUserEntity>());
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader.model('shipment_user.json');
      final json = jsonDecode(jsonString);

      // act
      final result = ShipmentUserModel.fromJson(json);

      // assert
      expect(result, shipmentUserModel);
    });

    test('should not bring implementation details', () {
      // assert
      expect(shipmentUserModel.toEntity(), isNot(isA<ShipmentUserModel>()));
      expect(shipmentUserModel.toEntity(), shipmentUserEntity);
    });
  });
}
