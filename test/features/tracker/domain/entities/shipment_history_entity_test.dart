import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/testdata/tracker_test_data.dart';

void main() {
  final shipmentHistory = tShipmentHistoryEntity;
  final shipmentHistoryMatcher = tShipmentHistoryEntity;

  group('shipment history entity test', () {
    test('should return true when all property is equal', () {
      // assert
      expect(shipmentHistory, shipmentHistoryMatcher);
    });
  });
}
