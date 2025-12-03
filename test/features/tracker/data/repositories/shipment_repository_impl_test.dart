import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ship_tracker/features/tracker/data/repositories/shipment_repository_impl.dart';

import '../../../../helpers/testdata/test_data.dart';
import '../../../../helpers/testdata/tracker_test_data.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late MockShipmentRemoteDataSource mockShipmentRemoteDataSource;
  late MockFileService mockFileService;
  late ShipmentRepositoryImpl shipmentRepository;

  setUpAll(() {
    registerFallbackValue(tCreateShipmentReportParams);
    registerFallbackValue(tDeleteShipmentParams);
    registerFallbackValue(tDownloadShipmentReportParams);
    registerFallbackValue(tFetchShipmentParams);
    registerFallbackValue(tFetchShipmentHistoryParams);
    registerFallbackValue(tFetchShipmentReportsParams);
    registerFallbackValue(tFetchShipmentsParams);
    registerFallbackValue(tCreateShipmentParams);
    registerFallbackValue(tUpdateShipmentDocumentParams);
  });

  setUp(() {
    mockShipmentRemoteDataSource = MockShipmentRemoteDataSource();
    mockFileService = MockFileService();
    shipmentRepository = ShipmentRepositoryImpl(
      shipmentRemoteDataSource: mockShipmentRemoteDataSource,
      fileService: mockFileService,
    );
  });

  group('create shipment report repository test', () {
    final params = tCreateShipmentReportParams;
    const resultMatcher = tCreateShipmentReportSuccess;

    test(
      'should return Right(String) when remote call is successful',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.createShipmentReport(any()),
        ).thenAnswer((_) async => tCreateShipmentReportSuccess);

        // act
        final result = await shipmentRepository.createShipmentReport(params);

        // assert
        expect(result, const Right(resultMatcher));
        verify(
          () => mockShipmentRemoteDataSource.createShipmentReport(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );

    test(
      'should return Left(ServerFailure) when remote data source throws ServerException',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.createShipmentReport(any()),
        ).thenThrow(tServerException);

        // act
        final result = await shipmentRepository.createShipmentReport(params);

        // assert
        expect(result, const Left(tServerFailure));
        verify(
          () => mockShipmentRemoteDataSource.createShipmentReport(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );
  });

  group('delete shipment repository test', () {
    const params = tDeleteShipmentParams;
    const resultMatcher = tDeleteShipmentSuccess;

    test(
      'should return Right(String) when remote call is successful',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.deleteShipment(any()),
        ).thenAnswer((_) async => tDeleteShipmentSuccess);

        // act
        final result = await shipmentRepository.deleteShipment(params);

        // assert
        expect(result, const Right(resultMatcher));
        verify(
          () => mockShipmentRemoteDataSource.deleteShipment(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );

    test(
      'should return Left(ServerFailure) when remote data source throws ServerException',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.deleteShipment(any()),
        ).thenThrow(tServerException);

        // act
        final result = await shipmentRepository.deleteShipment(params);

        // assert
        expect(result, const Left(tServerFailure));
        verify(
          () => mockShipmentRemoteDataSource.deleteShipment(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );
  });

  group('download shipment report repository test', () {
    const params = tDownloadShipmentReportParams;
    const resultMatcher = tDownloadShipmentReportSuccess;

    test(
      'should return Right(String) when remote call is successful',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.downloadShipmentReport(any()),
        ).thenAnswer((_) async => tDownloadShipmentReportSuccess);

        // act
        final result = await shipmentRepository.downloadShipmentReport(params);

        // assert
        expect(result, const Right(resultMatcher));
        verify(
          () => mockShipmentRemoteDataSource.downloadShipmentReport(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );

    test(
      'should return Left(ServerFailure) when remote data source throws ServerException',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.downloadShipmentReport(any()),
        ).thenThrow(tServerException);

        // act
        final result = await shipmentRepository.downloadShipmentReport(params);

        // assert
        expect(result, const Left(tServerFailure));
        verify(
          () => mockShipmentRemoteDataSource.downloadShipmentReport(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );
  });

  group('fetch shipment repository test', () {
    const params = tFetchShipmentParams;
    final resultMatcher = tFetchShipmentSuccess;

    test(
      'should return Right(ShipmentDetailEntity) when remote call is successful',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.fetchShipment(any()),
        ).thenAnswer((_) async => tFetchShipmentSuccess);

        // act
        final result = await shipmentRepository.fetchShipment(params);

        // assert
        expect(result, Right(resultMatcher));
        verify(
          () => mockShipmentRemoteDataSource.fetchShipment(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );

    test(
      'should return Left(ServerFailure) when remote data source throws ServerException',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.fetchShipment(any()),
        ).thenThrow(tServerException);

        // act
        final result = await shipmentRepository.fetchShipment(params);

        // assert
        expect(result, const Left(tServerFailure));
        verify(
          () => mockShipmentRemoteDataSource.fetchShipment(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );
  });

  group('fetch shipment status repository test', () {
    const params = tFetchShipmentHistoryParams;
    final resultMatcher = tFetchShipmentHistorySuccess;

    test(
      'should return Right(ShipmentHistoryEntity) when remote call is successful',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.fetchShipmentStatus(any()),
        ).thenAnswer((_) async => tFetchShipmentHistorySuccess);

        // act
        final result = await shipmentRepository.fetchShipmentStatus(params);

        // assert
        expect(result, Right(resultMatcher));
        verify(
          () => mockShipmentRemoteDataSource.fetchShipmentStatus(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );

    test(
      'should return Left(ServerFailure) when remote data source throws ServerException',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.fetchShipmentStatus(any()),
        ).thenThrow(tServerException);

        // act
        final result = await shipmentRepository.fetchShipmentStatus(params);

        // assert
        expect(result, const Left(tServerFailure));
        verify(
          () => mockShipmentRemoteDataSource.fetchShipmentStatus(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );
  });

  group('fetch shipment reports repository test', () {
    final params = tFetchShipmentReportsParams;
    final resultMatcher = tFetchShipmentReportsSuccess;

    test(
      'should return Right(List<ShipmentReportEntity>) when remote call is successful',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.fetchShipmentReports(any()),
        ).thenAnswer((_) async => tFetchShipmentReportsSuccess);

        // act
        final result = await shipmentRepository.fetchShipmentReports(params);

        // assert
        expect(result, Right(resultMatcher));
        verify(
          () => mockShipmentRemoteDataSource.fetchShipmentReports(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );

    test(
      'should return Left(ServerFailure) when remote data source throws ServerException',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.fetchShipmentReports(any()),
        ).thenThrow(tServerException);

        // act
        final result = await shipmentRepository.fetchShipmentReports(params);

        // assert
        expect(result, const Left(tServerFailure));
        verify(
          () => mockShipmentRemoteDataSource.fetchShipmentReports(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );
  });

  group('fetch shipments repository test', () {
    final params = tFetchShipmentsParams;
    final resultMatcher = tFetchShipmentsSuccess;

    test(
      'should return Right(List<ShipmentEntity>) when remote call is successful',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.fetchShipments(any()),
        ).thenAnswer((_) async => tFetchShipmentsSuccess);

        // act
        final result = await shipmentRepository.fetchShipments(params);

        // assert
        expect(result, Right(resultMatcher));
        verify(
          () => mockShipmentRemoteDataSource.fetchShipments(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );

    test(
      'should return Left(ServerFailure) when remote data source throws ServerException',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.fetchShipments(any()),
        ).thenThrow(tServerException);

        // act
        final result = await shipmentRepository.fetchShipments(params);

        // assert
        expect(result, const Left(tServerFailure));
        verify(
          () => mockShipmentRemoteDataSource.fetchShipments(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );
  });

  group('create shipment repository test', () {
    const params = tCreateShipmentParams;
    const resultMatcher = tCreateShipmentSuccess;

    test(
      'should return Right(String) when remote call is successful',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.createShipment(any()),
        ).thenAnswer((_) async => tCreateShipmentSuccess);

        // act
        final result = await shipmentRepository.createShipment(params);

        // assert
        expect(result, const Right(resultMatcher));
        verify(
          () => mockShipmentRemoteDataSource.createShipment(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );

    test(
      'should return Left(ServerFailure) when remote data source throws ServerException',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.createShipment(any()),
        ).thenThrow(tServerException);

        // act
        final result = await shipmentRepository.createShipment(params);

        // assert
        expect(result, const Left(tServerFailure));
        verify(
          () => mockShipmentRemoteDataSource.createShipment(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );
  });

  group('update shipment document repository test', () {
    const params = tUpdateShipmentDocumentParams;
    const resultMatcher = tUpdateShipmentDocumentSuccess;

    test(
      'should return Right(String) when remote call is successful',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.updateShipmentDocument(any()),
        ).thenAnswer((_) async => tUpdateShipmentDocumentSuccess);

        // act
        final result = await shipmentRepository.updateShipmentDocument(params);

        // assert
        expect(result, const Right(resultMatcher));
        verify(
          () => mockShipmentRemoteDataSource.updateShipmentDocument(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );

    test(
      'should return Left(ServerFailure) when remote data source throws ServerException',
      () async {
        // arrange
        when(
          () => mockShipmentRemoteDataSource.updateShipmentDocument(any()),
        ).thenThrow(tServerException);

        // act
        final result = await shipmentRepository.updateShipmentDocument(params);

        // assert
        expect(result, const Left(tServerFailure));
        verify(
          () => mockShipmentRemoteDataSource.updateShipmentDocument(params),
        ).called(1);
        verifyNoMoreInteractions(mockShipmentRemoteDataSource);
      },
    );
  });

  group('check shipment report existence repository test', () {
    const params = tCheckShipmentExistenceParams;
    const resultMatcher = tCheckShipmentExistenceSuccess;

    test('should return Right(bool) when file service is successful', () async {
      // arrange
      when(
        () => mockFileService.isFileExist(params.filename),
      ).thenAnswer((_) async => tCheckShipmentExistenceSuccess);

      // act
      final result = await shipmentRepository.checkShipmentReportExistence(
        params,
      );

      // assert
      expect(result, const Right(resultMatcher));
      verify(() => mockFileService.isFileExist(params.filename)).called(1);
      verifyNoMoreInteractions(mockFileService);
    });

    test(
      'should return Left(Failure) when file service throws Exception',
      () async {
        // arrange
        when(
          () => mockFileService.isFileExist(any()),
        ).thenThrow(tInternalException);

        // act
        final result = await shipmentRepository.checkShipmentReportExistence(
          params,
        );
        // assert
        expect(result, const Left(tFailure));
        verify(() => mockFileService.isFileExist(params.filename)).called(1);
        verifyNoMoreInteractions(mockFileService);
      },
    );
  });
}
