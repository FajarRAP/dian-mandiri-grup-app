import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/testdata/warehouse_test_data.dart';

void main() {
  const warehouseItem = tWarehouseItemEntity;
  const warehouseItemMatcher = tWarehouseItemEntity;

  group('warehouse item entity test', () {
    test('should return true when all property is equal', () {
      // assert
      expect(warehouseItem, warehouseItemMatcher);
    });
  });
}
