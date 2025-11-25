import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ship_tracker/core/errors/exceptions.dart';
import 'package:ship_tracker/core/helpers/helpers.dart';
import 'package:ship_tracker/features/tracker/data/datasources/shipment_remote_data_source.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/test_data.dart';
import '../../../../helpers/testdata/tracker_test_data.dart';
import '../../../../mocks/mocks.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'tracker');
  late MockDio mockDio;
  late ShipmentRemoteDataSourceImpl shipmentRemoteDataSource;

  setUp(() async {
    await initializeDateFormatting('id_ID', null);
    mockDio = MockDio();
    shipmentRemoteDataSource = ShipmentRemoteDataSourceImpl(dio: mockDio);
  });

  group('fetch shipments remote data sources test', () {
    final params = tFetchShipmentsParams;
    final resultMatcher = tFetchShipmentsSuccess;

    test(
      'should return List<ShipmentEntity> when request is successful',
      () async {
        // arrange
        final jsonString = fixtureReader.dataSource('fetch_shipments.json');
        final json = jsonDecode(jsonString);
        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            data: json,
            statusCode: 200,
          ),
        );

        // act
        final result = await shipmentRemoteDataSource.fetchShipments(params);

        // assert
        expect(result, resultMatcher);
        verify(
          () => mockDio.get(
            '/shipment',
            queryParameters: {
              'date': params.date.toYMD,
              'stage': params.stage,
              'search': params.keyword,
              'page': params.page,
            },
          ),
        ).called(1);
      },
    );

    test('should throw ServerException when API returns 4xx/5xx', () async {
      // arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse,
        ),
      );

      // act
      final future = shipmentRemoteDataSource.fetchShipments(params);

      // assert
      await expectLater(future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.get(
          '/shipment',
          queryParameters: {
            'date': params.date.toYMD,
            'stage': params.stage,
            'search': params.keyword,
            'page': params.page,
          },
        ),
      ).called(1);
    });
  });

  group('fetch shipment by id remote data sources test', () {
    const params = tFetchShipmentParams;
    final resultMatcher = tFetchShipmentSuccess;

    test(
      'should return ShipmentDetailEntity when request is successful',
      () async {
        // arrange
        final jsonString = fixtureReader.dataSource('fetch_shipment.json');
        final json = jsonDecode(jsonString);
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            data: json,
            statusCode: 200,
          ),
        );

        // act
        final result = await shipmentRemoteDataSource.fetchShipmentById(params);

        // assert
        expect(result, resultMatcher);
        verify(() => mockDio.get('/shipment/${params.shipmentId}')).called(1);
      },
    );

    test('should throw ServerException when API returns 4xx/5xx', () async {
      // arrange
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse,
        ),
      );

      // act
      final future = shipmentRemoteDataSource.fetchShipmentById(params);

      // assert
      await expectLater(future, throwsA(isA<ServerException>()));
      verify(() => mockDio.get('/shipment/${params.shipmentId}')).called(1);
    });
  });

  group('fetch shipment by receipt number remote data sources test', () {
    const params = tFetchShipmentHistoryParams;
    final resultMatcher = tFetchShipmentHistorySuccess;

    test(
      'should return ShipmentHistoryEntity when request is successful',
      () async {
        // arrange
        final jsonString = fixtureReader.dataSource(
          'fetch_shipment_history.json',
        );
        final json = jsonDecode(jsonString);
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            data: json,
            statusCode: 200,
          ),
        );

        // act
        final result = await shipmentRemoteDataSource
            .fetchShipmentByReceiptNumber(params);

        // assert
        expect(result, resultMatcher);
        verify(
          () => mockDio.get('/shipment/status/${params.receiptNumber}'),
        ).called(1);
      },
    );

    test('should throw ServerException when API returns 4xx/5xx', () async {
      // arrange
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse,
        ),
      );

      // act
      final future = shipmentRemoteDataSource.fetchShipmentByReceiptNumber(
        params,
      );

      // assert
      await expectLater(future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.get('/shipment/status/${params.receiptNumber}'),
      ).called(1);
    });
  });

  group('fetch shipment reports remote data sources test', () {
    final params = tFetchShipmentReportsParams;
    final resultMatcher = tFetchShipmentReportsSuccess;

    test(
      'should return List<ShipmentReportEntity> when request is successful',
      () async {
        // arrange
        final jsonString = fixtureReader.dataSource(
          'fetch_shipment_reports.json',
        );
        final json = jsonDecode(jsonString);
        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            data: json,
            statusCode: 200,
          ),
        );

        // act
        final result = await shipmentRemoteDataSource.fetchShipmentReports(
          params,
        );

        // assert
        expect(result, resultMatcher);
        verify(
          () => mockDio.get(
            '/shipment/report',
            queryParameters: {
              'start_date': params.startDate.toYMD,
              'end_date': params.endDate.toYMD,
              'status': params.status,
              'page': params.page,
            },
          ),
        ).called(1);
      },
    );

    test('should throw ServerException when API returns 4xx/5xx', () async {
      // arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse,
        ),
      );

      // act
      final future = shipmentRemoteDataSource.fetchShipmentReports(params);

      // assert
      await expectLater(future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.get(
          '/shipment/report',
          queryParameters: {
            'start_date': params.startDate.toYMD,
            'end_date': params.endDate.toYMD,
            'status': params.status,
            'page': params.page,
          },
        ),
      ).called(1);
    });
  });

  group('create shipment report remote data sources test', () {
    final params = tCreateShipmentReportParams;
    const resultMatcher = tCreateShipmentReportSuccess;

    test('should return String when request is successful', () async {
      // arrange
      final jsonString = fixtureReader.dataSource(
        'create_shipment_report.json',
      );
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await shipmentRemoteDataSource.createShipmentReport(
        params,
      );

      // assert
      expect(result, resultMatcher);
      verify(
        () => mockDio.post(
          '/shipment/report',
          data: {
            'start_date': params.startDate.toYMD,
            'end_date': params.endDate.toYMD,
          },
        ),
      ).called(1);
    });

    test('should throw ServerException when API returns 4xx/5xx', () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse,
        ),
      );

      // act
      final future = shipmentRemoteDataSource.createShipmentReport(params);

      // assert
      await expectLater(future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.post(
          '/shipment/report',
          data: {
            'start_date': params.startDate.toYMD,
            'end_date': params.endDate.toYMD,
          },
        ),
      ).called(1);
    });
  });

  group('delete shipment remote data sources test', () {
    const params = tDeleteShipmentParams;
    const resultMatcher = tDeleteShipmentSuccess;

    test('should return String when request is successful', () async {
      // arrange
      final jsonString = fixtureReader.dataSource('delete_shipment.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.delete(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await shipmentRemoteDataSource.deleteShipment(params);

      // assert
      expect(result, resultMatcher);
      verify(() => mockDio.delete('/shipment/${params.shipmentId}')).called(1);
    });

    test('should throw ServerException when API returns 4xx/5xx', () async {
      // arrange
      when(() => mockDio.delete(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse,
        ),
      );

      // act
      final future = shipmentRemoteDataSource.deleteShipment(params);

      // assert
      await expectLater(future, throwsA(isA<ServerException>()));
      verify(() => mockDio.delete('/shipment/${params.shipmentId}')).called(1);
    });
  });

  group('download shipment report remote data sources test', () {
    final params = tDownloadShipmentReportParams;
    const resultMatcher = tDownloadShipmentReportSuccess;

    test('should return String when request is successful', () async {
      // arrange
      final formattedDate = params.createdAt.toLocal().toDMY;
      when(
        () => mockDio.download(any(), any()),
      ).thenAnswer((_) async => Response(requestOptions: RequestOptions()));

      // act
      final result = await shipmentRemoteDataSource.downloadShipmentReport(
        params,
      );

      // assert
      expect(result, resultMatcher);
      verify(
        () => mockDio.download(
          params.fileUrl,
          '${params.externalPath}/${params.filename}_$formattedDate.xlsx',
        ),
      ).called(1);
    });

    test('should throw ServerException when API returns 4xx/5xx', () async {
      // arrange
      final formattedDate = params.createdAt.toLocal().toDMY;
      when(() => mockDio.download(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse,
        ),
      );

      // act
      final future = shipmentRemoteDataSource.downloadShipmentReport(params);

      // assert
      await expectLater(future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.download(
          params.fileUrl,
          '${params.externalPath}/${params.filename}_$formattedDate.xlsx',
        ),
      ).called(1);
    });
  });

  group('insert shipment remote data sources test', () {
    const params = tCreateShipmentParams;
    const resultMatcher = tCreateShipmentSuccess;

    test('should return String when request is successful', () async {
      // arrange
      final jsonString = fixtureReader.dataSource('create_shipment.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await shipmentRemoteDataSource.insertShipment(params);

      // assert
      expect(result, resultMatcher);
      verify(
        () => mockDio.post(
          '/shipment',
          data: {'receipt_number': params.receiptNumber, 'stage': params.stage},
        ),
      ).called(1);
    });

    test('should throw ServerException when API returns 4xx/5xx', () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse,
        ),
      );

      // act
      final future = shipmentRemoteDataSource.insertShipment(params);

      // assert
      await expectLater(future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.post(
          '/shipment',
          data: {'receipt_number': params.receiptNumber, 'stage': params.stage},
        ),
      ).called(1);
    });
  });

  group('insert shipment document remote data sources test', () {
    const params = tUpdateShipmentDocumentParams;
    const resultMatcher = tUpdateShipmentDocumentSuccess;
    final file = File(params.documentPath);

    setUp(() {
      file.writeAsStringSync('lorem');
    });

    tearDown(() {
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('should return String when request is successful', () async {
      // arrange
      final jsonString = fixtureReader.dataSource(
        'update_shipment_document.json',
      );
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await shipmentRemoteDataSource.insertShipmentDocument(
        params,
      );

      // assert
      expect(result, resultMatcher);
      verify(
        () => mockDio.post(
          '/shipment/${params.shipmentId}/document',
          data: any(named: 'data'),
        ),
      ).called(1);
    });

    test('should throw ServerException when API returns 4xx/5xx', () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse,
        ),
      );

      // act
      final result = shipmentRemoteDataSource.insertShipmentDocument(params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.post(
          '/shipment/${params.shipmentId}/document',
          data: any(named: 'data'),
        ),
      ).called(1);
    });
  });
}
