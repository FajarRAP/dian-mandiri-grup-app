import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ship_tracker/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:ship_tracker/features/auth/data/models/sign_in_response_model.dart';
import 'package:ship_tracker/features/auth/data/models/token_model.dart';
import 'package:ship_tracker/features/auth/data/models/user_model.dart';

class MockDio extends Mock implements Dio {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

void main() {
  late MockDio mockDio;
  late MockGoogleSignIn mockGoogleSignIn;
  late AuthRemoteDataSourcesImpl dataSources;
  late RequestOptions requestOptions;

  const tRefreshToken = 'refresh_token';

  setUp(() {
    mockDio = MockDio();
    mockGoogleSignIn = MockGoogleSignIn();
    dataSources = AuthRemoteDataSourcesImpl(
      dio: mockDio,
      googleSignIn: mockGoogleSignIn,
    );
    requestOptions = RequestOptions();
  });

  group(
    'me',
    () {
      const json = <String, dynamic>{
        "message": "Get auth me successfully",
        "data": {
          "id": "uuid",
          "name": "Fajar",
          "email": "email",
          "permissions": ["super_admin"]
        }
      };

      test(
        'should be return UserModel when request is successful',
        () async {
          // arrange
          when(() => mockDio.get(any())).thenAnswer((_) async => Response(
              requestOptions: requestOptions, data: json, statusCode: 200));

          // act
          final result = await dataSources.fetchUser();

          // assert
          expect(result, isA<UserModel>());
        },
      );
    },
  );

  group(
    'sign in',
    () {
      const json = <String, dynamic>{
        "message": "Success verify login by google",
        "data": {
          "access_token": "access_token",
          "refresh_token": "refresh_token",
          "user": {
            "id": "uuid",
            "name": "Fajar",
            "email": "email",
            "permissions": ["super_admin"]
          }
        }
      };

      test(
        'should be return SignInResponseModel when request is successful',
        () async {
          // arrange
          when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);
          when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
              (_) async => Response(
                  requestOptions: requestOptions, data: json, statusCode: 200));

          // act
          final result = await dataSources.signIn();

          // assert
          expect(result, isA<SignInResponseModel>());
          verify(() => mockGoogleSignIn.signIn()).called(1);
        },
      );
    },
  );

  group(
    'sign out',
    () {
      const json = <String, dynamic>{
        "message": "Auth logout successfully",
        "data": null,
      };

      test('should be return String when request is successful', () async {
        // arrange

        when(() => mockDio.post(any())).thenAnswer((_) async => Response(
            requestOptions: requestOptions, data: json, statusCode: 200));
        when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);

        // act
        final result = await dataSources.signOut();

        // assert
        expect(result, isA<String>());
        verify(() => mockGoogleSignIn.signOut()).called(1);
      });
    },
  );

  group(
    'update profile',
    () {
      const json = <String, dynamic>{
        "message": "Profile updated successfully",
        "data": null,
      };

      test('should be return String when request is successful', () async {
        // arrange
        when(() => mockDio.put(any(), data: any(named: 'data'))).thenAnswer(
            (_) async => Response(
                requestOptions: requestOptions, data: json, statusCode: 200));

        // act
        final result = await dataSources.updateProfile(name: 'name');

        // assert
        expect(result, isA<String>());
      });
    },
  );

  group(
    'refresh token',
    () {
      const json = <String, dynamic>{
        "message": "Auth refresh Successfully",
        "data": {
          "access_token": "access_token",
          "refresh_token": "refresh_token",
        }
      };

      test(
        'should be return TokenModel when request is successful',
        () async {
          // arrange
          when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
              (_) async => Response(
                  requestOptions: requestOptions, data: json, statusCode: 200));

          // act
          final result =
              await dataSources.refreshToken(refreshToken: tRefreshToken);

          // assert
          expect(result, isA<TokenModel>());
        },
      );
    },
  );
}
