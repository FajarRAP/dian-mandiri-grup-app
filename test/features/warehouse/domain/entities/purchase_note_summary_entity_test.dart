import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/testdata/warehouse_test_data.dart';

void main() {
  final purchaseNoteSummary = tPurchaseNoteSummaryEntity;
  final purchaseNoteSummaryMatcher = tPurchaseNoteSummaryEntity;

  group('purchase note summary entity test', () {
    test('should return true when all property is equal', () {
      // assert
      expect(purchaseNoteSummary, purchaseNoteSummaryMatcher);
    });
  });
}
