import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ship_tracker/common/constants/app_configs.dart';
import 'package:ship_tracker/core/errors/exceptions.dart';
import 'package:ship_tracker/features/auth/data/datasources/auth_local_data_source.dart';

import '../../../../helpers/testdata/auth_test_data.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late MockStorage mockStorage;
  late AuthLocalDataSourceImpl authLocalDataSource;

  setUp(() {
    mockStorage = MockStorage();
    authLocalDataSource = AuthLocalDataSourceImpl(storage: mockStorage);
  });

  group('cache tokens local data source test', () {
    const token = tTokenModel;

    test('should be call storage.write when use correct key', () async {
      // arrange
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async => {});
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async => {});

      // act
      await authLocalDataSource.cacheTokens(
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
      );

      // assert
      verify(
        () => mockStorage.write(
          key: AppConfigs.accessTokenKey,
          value: token.accessToken,
        ),
      ).called(1);
      verify(
        () => mockStorage.write(
          key: AppConfigs.refreshTokenKey,
          value: token.refreshToken,
        ),
      ).called(1);
    });

    test('should throw CacheException when unexpected error occur', () async {
      // arrange
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenThrow(Exception());

      // act
      final future = authLocalDataSource.cacheTokens(
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
      );

      // assert
      await expectLater(future, throwsA(isA<CacheException>()));
      verifyNever(
        () => mockStorage.write(
          key: AppConfigs.refreshTokenKey,
          value: token.refreshToken,
        ),
      );
    });
  });

  group('cache user local data source test', () {
    const user = tUserModel;

    test('should be call storage.write when use correct key', () async {
      // arrange
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async => {});

      // act
      await authLocalDataSource.cacheUser(user: user);

      // assert
      verify(
        () => mockStorage.write(
          key: AppConfigs.userKey,
          value: jsonEncode(user.toJson()),
        ),
      ).called(1);
    });

    test('should throw CacheException when unexpected error occur', () async {
      // arrange
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenThrow(Exception());

      // act
      final future = authLocalDataSource.cacheUser(user: user);

      // assert
      await expectLater(future, throwsA(isA<CacheException>()));
    });
  });

  group('clear cache local data source test', () {
    test('should be call storage.deleteAll', () async {
      // arrange
      when(() => mockStorage.deleteAll()).thenAnswer((_) async => {});

      // act
      await authLocalDataSource.clearCache();

      // assert
      verify(() => mockStorage.deleteAll()).called(1);
    });

    test('should throw CacheException when unexpected error occur', () async {
      // arrange
      when(() => mockStorage.deleteAll()).thenThrow(Exception());

      // act
      final future = authLocalDataSource.clearCache();

      // assert
      await expectLater(future, throwsA(isA<CacheException>()));
    });
  });

  group('get access token local data source test', () {
    const token = tTokenModel;

    test('should be call storage.read when use correct key', () async {
      // arrange
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => token.accessToken);

      // act
      final result = await authLocalDataSource.getAccessToken();

      // assert
      expect(result, token.accessToken);
      verify(() => mockStorage.read(key: AppConfigs.accessTokenKey)).called(1);
    });

    test('should throw CacheException when unexpected error occur', () async {
      // arrange
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenThrow(Exception());

      // act
      final future = authLocalDataSource.getAccessToken();

      // assert
      await expectLater(future, throwsA(isA<CacheException>()));
    });
  });

  group('get refresh token local data source test', () {
    const token = tTokenModel;

    test('should be call storage.read when use correct key', () async {
      // arrange
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => token.refreshToken);

      // act
      final result = await authLocalDataSource.getRefreshToken();

      // assert
      expect(result, token.refreshToken);
      verify(() => mockStorage.read(key: AppConfigs.refreshTokenKey)).called(1);
    });

    test('should throw CacheException when unexpected error occur', () async {
      // arrange
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenThrow(Exception());

      // act
      final future = authLocalDataSource.getRefreshToken();

      // assert
      await expectLater(future, throwsA(isA<CacheException>()));
    });
  });

  group('get user from storage local data source test', () {
    const userString = tUserString;
    const userEntity = tUserEntity;

    test('should be return UserEntity? when successful', () async {
      // arrange
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => userString);

      // act
      final result = await authLocalDataSource.getUser();

      // assert
      expect(result, userEntity);
      verify(() => mockStorage.read(key: AppConfigs.userKey)).called(1);
    });

    test('should be return null when no user found in storage', () async {
      // arrange
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => null);

      // act
      final result = await authLocalDataSource.getUser();

      // assert
      expect(result, null);
      verify(() => mockStorage.read(key: AppConfigs.userKey)).called(1);
    });

    test('should throw CacheException when unexpected error occur', () async {
      // arrange
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenThrow(Exception());

      // act
      final future = authLocalDataSource.getUser();

      // assert
      await expectLater(future, throwsA(isA<CacheException>()));
    });
  });
}
