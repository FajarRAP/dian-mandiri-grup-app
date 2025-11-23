import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ship_tracker/core/common/constants.dart';
import 'package:ship_tracker/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ship_tracker/features/auth/data/models/token_model.dart';
import 'package:ship_tracker/features/auth/data/models/user_model.dart';

class MockStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockStorage mockStorage;
  late AuthLocalDataSourceImpl authLocalDataSource;

  const token = TokenModel(
      accessToken: 'access_token',
      refreshToken: 'refresh_token',
      message: 'message');
  const user = UserModel(
    id: 'id',
    email: 'email',
    name: 'name',
    permissions: [],
  );
  final userString = jsonEncode(user.toJson());

  setUp(() {
    mockStorage = MockStorage();
    authLocalDataSource = AuthLocalDataSourceImpl(storage: mockStorage);
  });

  group(
    'cache token: ',
    () {
      test('should be call storage.write when use correct key', () async {
        // arrange
        when(() => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'))).thenAnswer((_) async => {});
        when(() => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'))).thenAnswer((_) async => {});

        // act
        await authLocalDataSource.cacheTokens(token: token);

        // assert
        verify(() => mockStorage.write(
            key: accessTokenKey, value: token.accessToken)).called(1);
        verify(() => mockStorage.write(
            key: refreshTokenKey, value: token.refreshToken)).called(1);
      });
    },
  );
  group(
    'cache user: ',
    () {
      test('should be call storage.write when use correct key', () async {
        // arrange
        when(() => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'))).thenAnswer((_) async => {});
        // act

        await authLocalDataSource.cacheUser(user: user);

        // assert

        verify(() => mockStorage.write(
            key: userKey, value: jsonEncode(user.toJson()))).called(1);
      });
    },
  );
  group(
    'clear user: ',
    () {
      test('should be call storage.deleteAll', () async {
        // arrange
        when(() => mockStorage.deleteAll()).thenAnswer((_) async => {});

        // act
        await authLocalDataSource.clearCache();

        // assert
        verify(() => mockStorage.deleteAll()).called(1);
      });
    },
  );
  group(
    'get access token: ',
    () {
      test('should be call storage.read when use correct key', () async {
        // arrange
        when(() => mockStorage.read(key: any(named: 'key')))
            .thenAnswer((_) async => token.accessToken);

        // act
        final result = await authLocalDataSource.getAccessToken();

        // assert
        expect(result, token.accessToken);
        verify(() => mockStorage.read(key: accessTokenKey)).called(1);
      });
    },
  );
  group(
    'get refresh token: ',
    () {
      test('should be call storage.read when use correct key', () async {
        // arrange
        when(() => mockStorage.read(key: any(named: 'key')))
            .thenAnswer((_) async => token.refreshToken);

        // act
        final result = await authLocalDataSource.getRefreshToken();

        // assert
        expect(result, token.refreshToken);
        verify(() => mockStorage.read(key: refreshTokenKey)).called(1);
      });
    },
  );

  group(
    'get user from storage: ',
    () {
      test('should be return UserModel? when successful', () async {
        // arrange
        when(() => mockStorage.read(key: any(named: 'key')))
            .thenAnswer((_) async => userString);

        // act
        final result = await authLocalDataSource.getUser();

        // assert
        expect(result, isA<UserModel?>());
        verify(() => mockStorage.read(key: userKey)).called(1);
      });
    },
  );
}
