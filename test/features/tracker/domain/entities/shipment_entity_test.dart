import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/testdata/tracker_test_data.dart';

void main() {
  final shipment = tShipmentEntity;
  final shipmentMatcher = tShipmentEntity;

  group('shipment entity test', () {
    test('should return true when all property is equal', () {
      // assert
      expect(shipment, shipmentMatcher);
    });
  });
}
