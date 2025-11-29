import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../../helpers/testdata/tracker_test_data.dart';

void main() {
  final shipmentReport = tShipmentReportEntity;
  final shipmentReportMatcher = tShipmentReportEntity;

  setUp(() async {
    await initializeDateFormatting('id_ID', null);
  });

  group('shipment report entity test', () {
    test('should return true when all property is equal', () {
      // assert
      expect(shipmentReport, shipmentReportMatcher);
    });

    test('should return correct saved filename', () {
      // arrange
      const expectedFilename =
          'Reporting of 2025-09-21 - 2025-09-21 16:30:07.xlsx';

      // act
      final savedFilename = shipmentReport.savedFilename;

      // assert
      expect(savedFilename, expectedFilename);
    });
  });
}
