import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_detail_model.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_detail_entity.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/tracker_test_data.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'tracker');
  final shipmentDetailEntity = tShipmentDetailEntity;
  final shipmentDetailModel = tShipmentDetailModel;

  group('shipment detail model test', () {
    test('should be a subclass of ShipmentDetailEntity', () {
      // assert
      expect(shipmentDetailModel, isA<ShipmentDetailEntity>());
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader.model('shipment_detail.json');
      final json = jsonDecode(jsonString);

      // act
      final result = ShipmentDetailModel.fromJson(json);

      // assert
      expect(result, shipmentDetailModel);
    });

    test('should not bring implementation details', () {
      // assert
      expect(shipmentDetailModel.toEntity(), isNot(isA<ShipmentDetailModel>()));
      expect(shipmentDetailModel.toEntity(), shipmentDetailEntity);
    });
  });
}
