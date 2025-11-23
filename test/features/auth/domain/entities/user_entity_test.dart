import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/testdata/auth_test_data.dart';

void main() {
  const user = tUserEntity;
  const userMatcher = tUserEntity;

  group('user entity test', () {
    test('should return true when all property is equal', () {
      // assert
      expect(user, userMatcher);
    });
  });
}
