import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/testdata/tracker_test_data.dart';

void main() {
  final shipmentReport = tShipmentReportEntity;
  final shipmentReportMatcher = tShipmentReportEntity;

  group('shipment report entity test', () {
    test('should return true when all property is equal', () {
      // assert
      expect(shipmentReport, shipmentReportMatcher);
    });
  });
}
