import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/testdata/tracker_test_data.dart';

void main() {
  final stage = tStageEntity;
  final stageMatcher = tStageEntity;

  group('stage entity test', () {
    test('should return true when all property is equal', () {
      // assert
      expect(stage, stageMatcher);
    });
  });
}
