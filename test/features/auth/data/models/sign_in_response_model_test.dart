import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/auth/data/models/sign_in_response_model.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/auth_test_data.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'auth');
  const signInResponse = tSignInResponseModel;

  group('sign in response model test', () {
    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader.dataSource('sign_in.json');
      final json = jsonDecode(jsonString);

      // act
      final result = SignInResponseModel.fromJson(json);

      // assert
      expect(result, signInResponse);
    });
  });
}
