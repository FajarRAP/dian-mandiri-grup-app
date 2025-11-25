import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ship_tracker/features/auth/data/repositories/auth_repository_impl.dart';

import '../../../../helpers/testdata/auth_test_data.dart';
import '../../../../helpers/testdata/test_data.dart';
import '../../../../mocks/mocks.dart';

void main() {
  registerFallbackValue(tUserModel);
  late MockAuthLocalDataSource mockAuthLocalDataSource;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late AuthRepositoryImpl authRepository;

  setUp(() {
    mockAuthLocalDataSource = MockAuthLocalDataSource();
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    authRepository = AuthRepositoryImpl(
      authLocalDataSource: mockAuthLocalDataSource,
      authRemoteDataSource: mockAuthRemoteDataSource,
    );
  });

  group('fetch user repository test', () {
    const resultMatcher = tUserEntity;

    test('should return Right(UserEntity) when remote call is successful',
        () async {
      // arrange
      when(() => mockAuthRemoteDataSource.fetchUser())
          .thenAnswer((_) async => tUserEntity);

      // act
      final result = await authRepository.fetchUser();

      // assert
      expect(result, const Right(resultMatcher));
      verify(() => mockAuthRemoteDataSource.fetchUser()).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyZeroInteractions(mockAuthLocalDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockAuthRemoteDataSource.fetchUser())
          .thenThrow(tServerException);

      // act
      final result = await authRepository.fetchUser();

      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockAuthRemoteDataSource.fetchUser()).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyZeroInteractions(mockAuthLocalDataSource);
    });
  });

  group('fetch user from storage repository test', () {
    const resultMatcher = tUserEntity;

    test('should return Right(UserEntity?) when local call is successful',
        () async {
      // arrange
      when(() => mockAuthLocalDataSource.getUser())
          .thenAnswer((_) async => resultMatcher);

      // act
      final result = await authRepository.fetchUserFromStorage();

      // assert
      expect(result, const Right(resultMatcher));
      verify(() => mockAuthLocalDataSource.getUser()).called(1);
      verifyNoMoreInteractions(mockAuthLocalDataSource);
      verifyZeroInteractions(mockAuthRemoteDataSource);
    });

    test(
        'should return Left(CacheFailure) when local data source throws CacheException',
        () async {
      // arrange
      when(() => mockAuthLocalDataSource.getUser()).thenThrow(tCacheException);

      // act
      final result = await authRepository.fetchUserFromStorage();

      // assert
      expect(result, const Left(tCacheFailure));
      verify(() => mockAuthLocalDataSource.getUser()).called(1);
      verifyNoMoreInteractions(mockAuthLocalDataSource);
      verifyZeroInteractions(mockAuthRemoteDataSource);
    });
  });

  group('refresh token repository test', () {
    const params = tRefreshTokenParams;
    const resultMatcher = tTokenModel;

    test('should return Right(String) when remote call is successful',
        () async {
      // arrange
      when(() => mockAuthRemoteDataSource.refreshToken(params))
          .thenAnswer((_) async => resultMatcher);
      when(() => mockAuthLocalDataSource.cacheTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async => {});

      // act
      final result = await authRepository.refreshToken(params);

      // assert
      expect(result, Right(resultMatcher.message));
      verify(() => mockAuthRemoteDataSource.refreshToken(params)).called(1);
      verify(() => mockAuthLocalDataSource.cacheTokens(
            accessToken: resultMatcher.accessToken,
            refreshToken: resultMatcher.refreshToken,
          )).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockAuthLocalDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockAuthRemoteDataSource.refreshToken(params))
          .thenThrow(tServerException);

      // act
      final result = await authRepository.refreshToken(params);

      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockAuthRemoteDataSource.refreshToken(params)).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyZeroInteractions(mockAuthLocalDataSource);
    });
  });

  group('sign in repository test', () {
    const signInResponseModel = tSignInResponseModel;

    test('should return Right(String) when remote call is successful',
        () async {
      // arrange
      when(() => mockAuthRemoteDataSource.signIn())
          .thenAnswer((_) async => signInResponseModel);
      when(() => mockAuthLocalDataSource.cacheUser(user: any(named: 'user')))
          .thenAnswer((_) async => {});
      when(() => mockAuthLocalDataSource.cacheTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async => {});

      // act
      final result = await authRepository.signIn();

      // assert
      expect(result, Right(signInResponseModel.message));
      verify(() => mockAuthRemoteDataSource.signIn()).called(1);
      verify(() => mockAuthLocalDataSource.cacheUser(
            user: signInResponseModel.user,
          )).called(1);
      verify(() => mockAuthLocalDataSource.cacheTokens(
            accessToken: signInResponseModel.accessToken,
            refreshToken: signInResponseModel.refreshToken,
          )).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockAuthLocalDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockAuthRemoteDataSource.signIn()).thenThrow(tServerException);

      // act
      final result = await authRepository.signIn();

      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockAuthRemoteDataSource.signIn()).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyZeroInteractions(mockAuthLocalDataSource);
    });
  });

  group('sign out repository test', () {
    const resultMatcher = tSignOutSuccess;

    test('should return Right(String) when remote call is successful',
        () async {
      // arrange
      when(() => mockAuthRemoteDataSource.signOut())
          .thenAnswer((_) async => resultMatcher);
      when(() => mockAuthLocalDataSource.clearCache())
          .thenAnswer((_) async => {});

      // act
      final result = await authRepository.signOut();

      // assert
      expect(result, const Right(resultMatcher));
      verify(() => mockAuthRemoteDataSource.signOut()).called(1);
      verify(() => mockAuthLocalDataSource.clearCache()).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockAuthLocalDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockAuthRemoteDataSource.signOut())
          .thenThrow(tServerException);

      // act
      final result = await authRepository.signOut();

      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockAuthRemoteDataSource.signOut()).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyZeroInteractions(mockAuthLocalDataSource);
    });
  });

  group('update profile repository test', () {
    const params = tUpdateProfileParams;
    const resultMatcher = tUpdateProfileSuccess;

    test('should return Right(String) when remote call is successful',
        () async {
      // arrange
      when(() => mockAuthRemoteDataSource.updateProfile(params))
          .thenAnswer((_) async => resultMatcher);

      // act
      final result = await authRepository.updateProfile(params);

      // assert
      expect(result, const Right(resultMatcher));
      verify(() => mockAuthRemoteDataSource.updateProfile(params)).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyZeroInteractions(mockAuthLocalDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockAuthRemoteDataSource.updateProfile(params))
          .thenThrow(tServerException);

      // act
      final result = await authRepository.updateProfile(params);

      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockAuthRemoteDataSource.updateProfile(params)).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyZeroInteractions(mockAuthLocalDataSource);
    });
  });

  group('get refresh token repository test', () {
    test('should return Right(String?) when local call is successful',
        () async {
      // arrange
      when(() => mockAuthLocalDataSource.getRefreshToken())
          .thenAnswer((_) async => tRefreshTokenString);

      // act
      final result = await authRepository.getRefreshToken();

      // assert
      expect(result, const Right(tRefreshTokenString));
      verify(() => mockAuthLocalDataSource.getRefreshToken()).called(1);
      verifyNoMoreInteractions(mockAuthLocalDataSource);
      verifyZeroInteractions(mockAuthRemoteDataSource);
    });

    test(
        'should return Left(CacheFailure) when local data source throws CacheException',
        () async {
      // arrange
      when(() => mockAuthLocalDataSource.getRefreshToken())
          .thenThrow(tCacheException);

      // act
      final result = await authRepository.getRefreshToken();

      // assert
      expect(result, const Left(tCacheFailure));
      verify(() => mockAuthLocalDataSource.getRefreshToken()).called(1);
      verifyNoMoreInteractions(mockAuthLocalDataSource);
      verifyZeroInteractions(mockAuthRemoteDataSource);
    });
  });
}
