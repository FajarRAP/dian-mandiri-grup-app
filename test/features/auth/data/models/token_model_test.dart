import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/auth/data/models/token_model.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/auth_test_data.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'auth');
  const tokenModel = tTokenModel;

  group('token model test', () {
    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader.dataSource('refresh_token.json');
      final json = jsonDecode(jsonString);

      // act
      final result = TokenModel.fromJson(json);

      // assert
      expect(result, tokenModel);
    });
  });
}
