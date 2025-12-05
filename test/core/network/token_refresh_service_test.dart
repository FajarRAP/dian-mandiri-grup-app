import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ship_tracker/core/network/token_refresh_service.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockDio dio;
  late MockAuthLocalDataSource authLocalDataSource;
  late MockAuthStatusStream authStatusStream;
  late TokenRefreshService tokenRefreshService;

  setUp(() {
    dio = MockDio();
    authLocalDataSource = MockAuthLocalDataSource();
    authStatusStream = MockAuthStatusStream();
    tokenRefreshService = TokenRefreshService(
      cleanDio: dio,
      authLocalDataSource: authLocalDataSource,
      authStatusStream: authStatusStream,
    );
  });

  group('token refresh service test', () {
    test(
      'should throw exception, clear cache, and set stream to unauthenticated, then return null when refresh token is null',
      () async {
        // arrange
        when(
          () => authLocalDataSource.getRefreshToken(),
        ).thenAnswer((_) async => null);
        when(() => authLocalDataSource.clearCache()).thenAnswer((_) async {});

        // act
        final result = await tokenRefreshService.refreshToken();

        // assert
        expect(result, null);
        verify(() => authLocalDataSource.getRefreshToken()).called(1);
        verify(() => authLocalDataSource.clearCache()).called(1);
        verify(() => authStatusStream.setUnauthenticated()).called(1);
      },
    );

    test('should return newAccessToken when token refresh success', () async {
      // arrange
      when(
        () => authLocalDataSource.getRefreshToken(),
      ).thenAnswer((_) async => 'validRefreshToken');
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {'data': 'newAccessToken'},
        ),
      );
      when(
        () => authLocalDataSource.cacheTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      // act
      final result = await tokenRefreshService.refreshToken();

      // assert
      expect(result, 'newAccessToken');
      verify(() => authLocalDataSource.getRefreshToken()).called(1);
      verify(
        () => dio.post(
          '/auth/refresh',
          data: {'refresh_token': 'validRefreshToken'},
        ),
      ).called(1);
      verify(
        () => authLocalDataSource.cacheTokens(
          accessToken: 'newAccessToken',
          refreshToken: 'validRefreshToken',
        ),
      ).called(1);
      verify(() => authStatusStream.setAuthenticated()).called(1);
    });
  });
}
