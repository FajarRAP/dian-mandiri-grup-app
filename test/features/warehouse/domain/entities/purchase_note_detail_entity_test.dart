import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/testdata/warehouse_test_data.dart';

void main() {
  final purchaseNoteDetail = tPurchaseNoteDetailEntity;
  final purchaseNoteDetailMatcher = tPurchaseNoteDetailEntity;

  group('purchase note detail entity test', () {
    test('should return true when all property is equal', () {
      // assert
      expect(purchaseNoteDetail, purchaseNoteDetailMatcher);
    });
  });
}
