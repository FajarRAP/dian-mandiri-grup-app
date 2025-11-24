import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/warehouse/data/models/warehouse_item_model.dart';
import 'package:ship_tracker/features/warehouse/domain/entities/warehouse_item_entity.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/warehouse_test_data.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'warehouse');
  const warehouseItemEntity = tWarehouseItemEntity;
  const warehouseItemModel = tWarehouseItemModel;

  group('warehouse item model test', () {
    test('should be a subclass of WarehouseItemEntity', () {
      // assert
      expect(warehouseItemModel, isA<WarehouseItemEntity>());
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader.model('warehouse_item.json');
      final json = jsonDecode(jsonString);

      // act
      final result = WarehouseItemModel.fromJson(json);

      // assert
      expect(result, warehouseItemModel);
    });

    test('should not bring implementation details', () {
      // assert
      expect(warehouseItemModel.toEntity(), isNot(isA<WarehouseItemModel>()));
      expect(warehouseItemModel.toEntity(), warehouseItemEntity);
    });
  });
}
