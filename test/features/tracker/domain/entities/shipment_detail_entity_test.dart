import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/testdata/tracker_test_data.dart';

void main() {
  final shipmentDetail = tShipmentDetailEntity;
  final shipmentDetailMatcher = tShipmentDetailEntity;

  group('shipment detail entity test', () {
    test('should return true when all property is equal', () {
      // assert
      expect(shipmentDetail, shipmentDetailMatcher);
    });
  });
}
