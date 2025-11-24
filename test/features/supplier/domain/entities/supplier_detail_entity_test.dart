import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/testdata/supplier_test_data.dart';

void main() {
  const supplierDetail = tSupplierDetailEntity;
  const supplierDetailMatcher = tSupplierDetailEntity;

  group('supplier detail entity test', () {
    test('should return true when all property is equal', () {
      // assert
      expect(supplierDetail, supplierDetailMatcher);
    });
  });
}
