import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_detail_model.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_user_model.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_detail_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tShipmentUserModel = ShipmentUserModel(id: 'id', name: 'name');
  final tShipmentDetailModel = ShipmentDetailModel(
      id: 'id',
      courier: 'courier',
      document: 'document',
      receiptNumber: 'receiptNumber',
      stage: 'stage',
      date: DateTime.now(),
      user: tShipmentUserModel);

  group('shipment detail model test', () {
    test('should be a subclass of ShipmentDetailEntity', () {
      expect(tShipmentDetailModel, isA<ShipmentDetailEntity>());
    });

    test('should not bring implementation details', () {
      expect(tShipmentDetailModel.toEntity(), isA<ShipmentDetailEntity>());
      expect(
          tShipmentDetailModel.toEntity(), isNot(isA<ShipmentDetailModel>()));
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader('models/shipment_detail.json');
      final json = jsonDecode(jsonString);

      // act
      final result = ShipmentDetailModel.fromJson(json);

      // assert
      expect(result.toEntity(), isA<ShipmentDetailEntity>());
    });
  });
}
