import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/testdata/supplier_test_data.dart';

void main() {
  const supplier = tSupplierEntity;
  const supplierMatcher = tSupplierEntity;

  group('supplier entity test', () {
    test('should return true when all property is equal', () {
      // assert
      expect(supplier, supplierMatcher);
    });
  });
}
