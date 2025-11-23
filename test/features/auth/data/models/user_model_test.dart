import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/auth/data/models/user_model.dart';
import 'package:ship_tracker/features/auth/domain/entities/user_entity.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/auth_test_data.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'auth');
  const userModel = tUserModel;
  const userEntity = tUserEntity;

  group('user model test', () {
    test('should be a subclass of UserEntity', () {
      // assert
      expect(userModel, isA<UserEntity>());
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader.model('user.json');
      final json = jsonDecode(jsonString);

      // act
      final result = UserModel.fromJson(json);

      // assert
      expect(result, userModel);
    });

    test('should not bring implementation details', () {
      // assert
      expect(userModel.toEntity(), isNot(isA<UserModel>()));
      expect(userModel.toEntity(), userEntity);
    });
  });
}
