import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ship_tracker/core/network/auth_interceptor.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockDio dio;
  late MockAuthLocalDataSource authLocalDataSource;
  late MockTokenRefreshService tokenRefreshService;
  late AuthInterceptor authInterceptor;
  late MockRequestInterceptorHandler requestHandler;
  late MockErrorInterceptorHandler errorHandler;

  setUp(() {
    dio = MockDio();
    authLocalDataSource = MockAuthLocalDataSource();
    tokenRefreshService = MockTokenRefreshService();
    authInterceptor = AuthInterceptor(
      dio: dio,
      authLocalDataSource: authLocalDataSource,
      tokenRefreshService: tokenRefreshService,
    );
    requestHandler = MockRequestInterceptorHandler();
    errorHandler = MockErrorInterceptorHandler();
  });

  group('onRequest', () {
    test(
      'should not contains Authorization header when in unauthenticated path',
      () async {
        // arrange
        final options = RequestOptions(path: '/auth/google');

        // act
        await authInterceptor.onRequest(options, requestHandler);

        // assert
        expect(options.headers.containsKey('Authorization'), isFalse);
        verify(() => requestHandler.next(options)).called(1);
        verifyNever(() => authLocalDataSource.getAccessToken());
      },
    );

    test(
      'should contains Authorization header when in authenticated path',
      () async {
        // arrange
        final options = RequestOptions(path: '/some-authenticated-path');
        when(
          () => authLocalDataSource.getAccessToken(),
        ).thenAnswer((_) async => 'access-token');

        // act
        await authInterceptor.onRequest(options, requestHandler);

        // assert
        expect(options.headers.containsKey('Authorization'), isTrue);
        verify(() => authLocalDataSource.getAccessToken()).called(1);
        verify(() => requestHandler.next(options)).called(1);
      },
    );
  });

  group('onError', () {
    test('should next when status code is 4xx but not 401', () async {
      // arrange
      final err = DioException(
        requestOptions: RequestOptions(path: '/some-path'),
        response: Response(
          requestOptions: RequestOptions(path: '/some-path'),
          statusCode: 404,
        ),
      );

      // act
      await authInterceptor.onError(err, errorHandler);

      // assert
      verify(() => errorHandler.next(err)).called(1);
      verifyNever(() => tokenRefreshService.refreshToken());
      verifyNever(() => authLocalDataSource.getAccessToken());
    });

    test('should next when in excluded paths', () async {
      // arrange
      final err = DioException(
        requestOptions: RequestOptions(path: '/auth/google'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/google'),
          statusCode: 401,
        ),
      );

      // act
      await authInterceptor.onError(err, errorHandler);

      // assert
      verify(() => errorHandler.next(err)).called(1);
      verifyNever(() => tokenRefreshService.refreshToken());
      verifyNever(() => authLocalDataSource.getAccessToken());
    });

    test('should next when token refresh service error', () async {
      // arrange
      final err = DioException(
        requestOptions: RequestOptions(path: '/some-authenticated-path'),
        response: Response(
          requestOptions: RequestOptions(path: '/some-authenticated-path'),
          statusCode: 401,
        ),
      );
      when(
        () => tokenRefreshService.refreshToken(),
      ).thenThrow(Exception('Refresh token error'));

      // act
      await authInterceptor.onError(err, errorHandler);

      // assert
      verify(() => tokenRefreshService.refreshToken()).called(1);
      verify(() => errorHandler.next(err)).called(1);
      verifyNever(() => authLocalDataSource.getAccessToken());
    });

    test(
      'should next when token refresh service failed because refresh token expired (return null)',
      () async {
        // arrange
        final err = DioException(
          requestOptions: RequestOptions(path: '/some-authenticated-path'),
          response: Response(
            requestOptions: RequestOptions(path: '/some-authenticated-path'),
            statusCode: 401,
          ),
        );
        when(
          () => tokenRefreshService.refreshToken(),
        ).thenAnswer((_) async => null);
        when(
          () => authLocalDataSource.getAccessToken(),
        ).thenAnswer((_) async => null);

        // act
        await authInterceptor.onError(err, errorHandler);

        // assert
        verify(() => tokenRefreshService.refreshToken()).called(1);
        verify(() => errorHandler.next(err)).called(1);
        verify(() => authLocalDataSource.getAccessToken()).called(1);
      },
    );

    test(
      'should throw DioException when token refresh success but api call fails',
      () async {
        // arrange
        final err = DioException(
          requestOptions: RequestOptions(path: '/some-authenticated-path'),
          response: Response(
            requestOptions: RequestOptions(path: '/some-authenticated-path'),
            statusCode: 401,
          ),
        );
        final de = DioException(
          requestOptions: RequestOptions(path: '/some-authenticated-path'),
          response: Response(
            requestOptions: RequestOptions(path: '/some-authenticated-path'),
            statusCode: 403,
          ),
        );
        when(
          () => tokenRefreshService.refreshToken(),
        ).thenAnswer((_) async => 'new-access-token');
        when(
          () => authLocalDataSource.getAccessToken(),
        ).thenAnswer((_) async => 'new-access-token');
        when(() => dio.fetch(err.requestOptions)).thenThrow(de);

        // act
        await authInterceptor.onError(err, errorHandler);

        // assert
        verify(() => tokenRefreshService.refreshToken()).called(1);
        verify(() => authLocalDataSource.getAccessToken()).called(1);
        verify(() => dio.fetch(err.requestOptions)).called(1);
        verify(() => errorHandler.next(de)).called(1);
      },
    );

    test(
      'should resolve when token refresh service and api call success',
      () async {
        // arrange
        final err = DioException(
          requestOptions: RequestOptions(path: '/some-authenticated-path'),
          response: Response(
            requestOptions: RequestOptions(path: '/some-authenticated-path'),
            statusCode: 401,
          ),
        );
        final successResponse = Response(
          requestOptions: RequestOptions(path: '/some-authenticated-path'),
          statusCode: 200,
          data: {'data': 'some-data'},
        );
        when(
          () => tokenRefreshService.refreshToken(),
        ).thenAnswer((_) async => 'new-access-token');
        when(
          () => authLocalDataSource.getAccessToken(),
        ).thenAnswer((_) async => 'new-access-token');
        when(
          () => dio.fetch(err.requestOptions),
        ).thenAnswer((_) async => successResponse);

        // act
        await authInterceptor.onError(err, errorHandler);

        // assert
        verify(() => tokenRefreshService.refreshToken()).called(1);
        verify(() => authLocalDataSource.getAccessToken()).called(1);
        verify(() => dio.fetch(err.requestOptions)).called(1);
        verify(() => errorHandler.resolve(successResponse)).called(1);
      },
    );
  });
}
