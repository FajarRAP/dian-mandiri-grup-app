import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ship_tracker/features/auth/data/datasources/auth_remote_data_source.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/auth_test_data.dart';
import '../../../../helpers/testdata/test_data.dart';
import '../../../../mocks/mocks.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'auth');
  late MockDio mockDio;
  late MockGoogleSignInService mockGoogleSignInService;
  late AuthRemoteDataSourceImpl authRemoteDataSource;

  setUp(() {
    mockDio = MockDio();
    mockGoogleSignInService = MockGoogleSignInService();
    authRemoteDataSource = AuthRemoteDataSourceImpl(
      dio: mockDio,
      googleSignIn: mockGoogleSignInService,
    );
  });

  group('fetch user remote data source test', () {
    const userEntity = tUserEntity;

    test('should be return UserModel when request is successful', () async {
      // arrange
      final jsonString = fixtureReader.dataSource('fetch_user.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(), data: json, statusCode: 200));

      // act
      final result = await authRemoteDataSource.fetchUser();

      // assert
      expect(result, userEntity);
      verify(() => mockDio.get('v1/auth/me')).called(1);
    });

    test('should throw ServerException when API returns 4xx/5xx', () async {
      // arrange
      when(() => mockDio.get(any())).thenThrow(DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse));

      // act
      final future = authRemoteDataSource.fetchUser();

      // assert
      await expectLater(future, throwsA(isA<Exception>()));
      verify(() => mockDio.get('v1/auth/me')).called(1);
    });
  });

  group('sign in remote data source test', () {
    const googleAccessToken = tGoogleAccessToken;
    const loginResponseModel = tSignInResponseModel;

    test('should be return LoginResponseModel when request is successful',
        () async {
      // arrange
      final jsonString = fixtureReader.dataSource('sign_in.json');
      final json = jsonDecode(jsonString);
      when(() => mockGoogleSignInService.authenticate())
          .thenAnswer((_) async => googleAccessToken);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
              requestOptions: RequestOptions(), data: json, statusCode: 200));

      // act
      final result = await authRemoteDataSource.signIn();

      // assert
      expect(result, loginResponseModel);
      verify(() => mockGoogleSignInService.authenticate()).called(1);
      verify(() => mockDio.post(
            'v1/auth/google',
            data: {'access_token': googleAccessToken},
          )).called(1);
    });

    test('should throw Exception when Google Sign-In fails', () async {
      // arrange
      when(() => mockGoogleSignInService.authenticate())
          .thenThrow(Exception('Google Sign-In failed'));

      // act
      final future = authRemoteDataSource.signIn();

      // assert
      await expectLater(future, throwsA(isA<Exception>()));
      verify(() => mockGoogleSignInService.authenticate()).called(1);
      verifyNever(() => mockDio.post(any(), data: any(named: 'data')));
    });
  });

  group('sign out remote data source test', () {
    const resultMatcher = tSignOutSuccess;

    test('should be return String when request is successful', () async {
      // arrange
      final jsonString = fixtureReader.dataSource('sign_out.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(), data: json, statusCode: 200));
      when(() => mockGoogleSignInService.signOut()).thenAnswer((_) async => {});

      // act
      final result = await authRemoteDataSource.signOut();

      // assert
      expect(result, resultMatcher);
      verify(() => mockDio.post('v1/auth/logout')).called(1);
      verify(() => mockGoogleSignInService.signOut()).called(1);
    });

    test('should throw Exception when request is unsuccessful', () async {
      // arrange
      when(() => mockDio.post(any())).thenThrow(DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse));

      // act
      final future = authRemoteDataSource.signOut();

      // assert
      await expectLater(future, throwsA(isA<Exception>()));
      verify(() => mockDio.post('v1/auth/logout')).called(1);
      verifyNever(() => mockGoogleSignInService.signOut());
    });
  });

  group('update profile remote data source test', () {
    const params = tUpdateProfileParams;
    const resultMatcher = tUpdateProfileSuccess;

    test('should be return String when request is successful', () async {
      // arrange
      final jsonString = fixtureReader.dataSource('update_profile.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.put(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
              requestOptions: RequestOptions(), data: json, statusCode: 200));

      // act
      final result = await authRemoteDataSource.updateProfile(params);

      // assert
      expect(result, resultMatcher);
      verify(() => mockDio.put(
            'v1/auth/profile',
            data: {'name': params.name},
          )).called(1);
    });

    test('should throw Exception when request is unsuccessful', () async {
      // arrange
      when(() => mockDio.put(any(), data: any(named: 'data'))).thenThrow(
          DioException(
              requestOptions: RequestOptions(),
              error: tServerException,
              type: DioExceptionType.badResponse));

      // act
      final future = authRemoteDataSource.updateProfile(params);

      // assert
      await expectLater(future, throwsA(isA<Exception>()));
      verify(() => mockDio.put(
            'v1/auth/profile',
            data: {'name': params.name},
          )).called(1);
    });
  });

  group('refresh token remote data source test', () {
    const refreshTokenParams = tRefreshTokenParams;
    const tokenModel = tTokenModel;

    test('should be return TokenModel when request is successful', () async {
      // arrange
      final jsonString = fixtureReader.dataSource('refresh_token.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
              requestOptions: RequestOptions(), data: json, statusCode: 200));

      // act
      final result =
          await authRemoteDataSource.refreshToken(refreshTokenParams);

      // assert
      expect(result, tokenModel);
    });

    test('should throw Exception when request is unsuccessful', () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
          DioException(
              requestOptions: RequestOptions(),
              error: tServerException,
              type: DioExceptionType.badResponse));

      // act
      final future = authRemoteDataSource.refreshToken(refreshTokenParams);

      // assert
      await expectLater(future, throwsA(isA<Exception>()));
    });
  });
}
