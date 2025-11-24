import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/testdata/tracker_test_data.dart';

void main() {
  const shipmentUser = tShipmentUserEntity;
  const shipmentUserMatcher = tShipmentUserEntity;

  group('shipment user entity test', () {
    test('should return true when all property is equal', () {
      // assert
      expect(shipmentUser, shipmentUserMatcher);
    });
  });
}
