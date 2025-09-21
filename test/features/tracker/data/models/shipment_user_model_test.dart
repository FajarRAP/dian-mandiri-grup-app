import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_user_model.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_user_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tShipmentUserModel = ShipmentUserModel(
    id: '05be1bd7-fdc9-488e-ac94-98eba66d1bd4',
    name: 'mamy',
  );

  group('shipment user model test', () {
    test('should be a subclass of ShipmentUserEntity', () {
      expect(tShipmentUserModel, isA<ShipmentUserEntity>());
    });

    test('should not bring implementation details', () {
      expect(tShipmentUserModel.toEntity(), isA<ShipmentUserEntity>());
      expect(tShipmentUserModel.toEntity(), isNot(isA<ShipmentUserModel>()));
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader('models/shipment_user.json');
      final json = jsonDecode(jsonString);

      // act
      final result = ShipmentUserModel.fromJson(json);

      // assert
      expect(result.toEntity(), isA<ShipmentUserEntity>());
    });
  });
}
