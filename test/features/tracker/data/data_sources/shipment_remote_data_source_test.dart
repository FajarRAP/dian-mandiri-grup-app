import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ship_tracker/core/exceptions/internal_exception.dart';
import 'package:ship_tracker/core/exceptions/server_exception.dart';
import 'package:ship_tracker/features/tracker/data/datasources/shipment_remote_data_source.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_detail_model.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_history_model.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_model.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_report_model.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_detail_entity.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_entity.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_history_entity.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_report_entity.dart';
import 'package:ship_tracker/features/tracker/domain/usecases/create_shipment_report_use_case.dart';
import 'package:ship_tracker/features/tracker/domain/usecases/download_shipment_report_use_case.dart';
import 'package:ship_tracker/features/tracker/domain/usecases/fetch_shipment_reports_use_case.dart';
import 'package:ship_tracker/features/tracker/domain/usecases/fetch_shipments_use_case.dart';
import 'package:ship_tracker/features/tracker/domain/usecases/insert_shipment_document_use_case.dart';
import 'package:ship_tracker/features/tracker/domain/usecases/insert_shipment_use_case.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late ShipmentRemoteDataSourceImpl dataSource;

  setUp(() async {
    await initializeDateFormatting('id_ID', null);
    mockDio = MockDio();
    dataSource = ShipmentRemoteDataSourceImpl(dio: mockDio);
  });

  group('fetch shipments remote data sources test', () {
    final params = FetchShipmentsUseCaseParams(
      page: 1,
      date: DateTime.now(),
      stage: 'scan',
      keyword: '',
    );

    test('should return List<ShipmentEntity> when request status code is 200',
        () async {
      // arrange
      final jsonString =
          fixtureReader('remote_data_sources/fetch_shipments.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.get(any(),
          queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.fetchShipments(params: params);

      // assert
      expect(result, isA<List<ShipmentEntity>>());
      expect(result, isNot(isA<List<ShipmentModel>>()));
    });

    test('should throw ServerException when request status code is not 200',
        () async {
      // arrange
      when(() => mockDio.get(any(),
          queryParameters: any(named: 'queryParameters'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            requestOptions: RequestOptions(),
            data: {'message': 'Unauthorized'},
            statusCode: 401,
          ),
        ),
      );

      // act
      final result = dataSource.fetchShipments(params: params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenThrow(const InternalException());

      // act
      final result = dataSource.fetchShipments(params: params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });

  group('fetch shipment by id remote data sources test', () {
    const params = 'params';

    test('should return ShipmentDetailEntity when request status code is 200',
        () async {
      // arrange
      final jsonString =
          fixtureReader('remote_data_sources/fetch_shipment_by_id.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.fetchShipmentById(shipmentId: params);

      // assert
      expect(result, isA<ShipmentDetailEntity>());
      expect(result, isNot(isA<ShipmentDetailModel>()));
    });

    test('should throw ServerException when request status code is not 200',
        () async {
      // arrange
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            requestOptions: RequestOptions(),
            data: {'message': 'Unauthorized'},
            statusCode: 401,
          ),
        ),
      );

      // act
      final result = dataSource.fetchShipmentById(shipmentId: params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.get(any())).thenThrow(const InternalException());

      // act
      final result = dataSource.fetchShipmentById(shipmentId: params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });

  group('fetch shipment by receipt number remote data sources test', () {
    const params = 'params';

    test('should return ShipmentHistoryEntity when request status code is 200',
        () async {
      // arrange
      final jsonString = fixtureReader(
          'remote_data_sources/fetch_shipment_by_receipt_number.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result =
          await dataSource.fetchShipmentByReceiptNumber(receiptNumber: params);

      // assert
      expect(result, isA<ShipmentHistoryEntity>());
      expect(result, isNot(isA<ShipmentHistoryModel>()));
    });

    test('should throw ServerException when request status code is not 200',
        () async {
      // arrange
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            requestOptions: RequestOptions(),
            data: {'message': 'Unauthorized'},
            statusCode: 401,
          ),
        ),
      );

      // act
      final result =
          dataSource.fetchShipmentByReceiptNumber(receiptNumber: params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.get(any())).thenThrow(const InternalException());

      // act
      final result =
          dataSource.fetchShipmentByReceiptNumber(receiptNumber: params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });

  group('fetch shipment reports remote data sources test', () {
    final params = FetchShipmentReportsUseCaseParams(
      startDate: DateTime.now().subtract(const Duration(days: 7)),
      endDate: DateTime.now(),
      status: 'delivered',
      page: 1,
    );

    test(
        'should return List<ShipmentReportEntity> when request status code is 200',
        () async {
      // arrange
      final jsonString =
          fixtureReader('remote_data_sources/fetch_shipment_reports.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.get(any(),
          queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.fetchShipmentReports(params: params);

      // assert
      expect(result, isA<List<ShipmentReportEntity>>());
      expect(result, isNot(isA<List<ShipmentReportModel>>()));
    });

    test('should throw ServerException when request status code is not 200',
        () async {
      // arrange
      when(() => mockDio.get(any(),
          queryParameters: any(named: 'queryParameters'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            requestOptions: RequestOptions(),
            data: {'message': 'Unauthorized'},
            statusCode: 401,
          ),
        ),
      );

      // act
      final result = dataSource.fetchShipmentReports(params: params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenThrow(const InternalException());

      // act
      final result = dataSource.fetchShipmentReports(params: params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });

  group('create shipment report remote data sources test', () {
    final params = CreateShipmentReportUseCaseParams(
      startDate: DateTime.now().subtract(const Duration(days: 7)),
      endDate: DateTime.now(),
    );

    test('should return String when request status code is 200', () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {'message': 'Success create report shipment!', 'data': null},
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.createShipmentReport(params: params);

      // assert
      expect(result, isA<String>());
      verify(() => mockDio.post(any(), data: any(named: 'data'))).called(1);
    });

    test('should throw ServerException when request status code is not 200',
        () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            requestOptions: RequestOptions(),
            data: {'message': 'Unauthorized'},
            statusCode: 401,
          ),
        ),
      );

      // act
      final result = dataSource.createShipmentReport(params: params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(const InternalException());

      // act
      final result = dataSource.createShipmentReport(params: params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });

  group('delete shipment remote data sources test', () {
    const params = 'params';

    test('should return String when request status code is 200', () async {
      // arrange
      when(() => mockDio.delete(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {'message': 'Success delete shipment!', 'data': null},
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.deleteShipment(shipmentId: params);

      // assert
      expect(result, isA<String>());
      verify(() => mockDio.delete(any())).called(1);
    });

    test('should throw ServerException when request status code is not 200',
        () async {
      // arrange
      when(() => mockDio.delete(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            requestOptions: RequestOptions(),
            data: {'message': 'Unauthorized'},
            statusCode: 401,
          ),
        ),
      );

      // act
      final result = dataSource.deleteShipment(shipmentId: params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.delete(any())).thenThrow(const InternalException());

      // act
      final result = dataSource.deleteShipment(shipmentId: params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });

  group('download shipment report remote data sources test', () {
    final params = DownloadShipmentReportUseCaseParams(
      externalPath: 'externalPath',
      fileUrl: 'fileUrl',
      filename: 'filename',
      createdAt: DateTime.now(),
    );
    test('should return String when request status code is 200', () async {
      // arrange
      when(() => mockDio.download(any(), any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {'message': 'null', 'data': null},
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.downloadShipmentReport(params: params);

      // assert
      expect(result, isA<String>());
      verify(() => mockDio.download(any(), any())).called(1);
    });

    test('should throw ServerException when request status code is not 200',
        () async {
      // arrange
      when(() => mockDio.download(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            requestOptions: RequestOptions(),
            data: {'message': 'Unauthorized'},
            statusCode: 401,
          ),
        ),
      );

      // act
      final result = dataSource.downloadShipmentReport(params: params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.download(any(), any()))
          .thenThrow(const InternalException());

      // act
      final result = dataSource.downloadShipmentReport(params: params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });

  group('insert shipment remote data sources test', () {
    const params = InsertShipmentUseCaseParams(
      receiptNumber: 'receiptNumber',
      stage: 'stage',
    );

    test('should return String when request status code is 200', () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {'message': 'Success insert shipment!', 'data': null},
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.insertShipment(params: params);

      // assert
      expect(result, isA<String>());
      verify(() => mockDio.post(any(), data: any(named: 'data'))).called(1);
    });

    test('should throw ServerException when request status code is not 200',
        () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            requestOptions: RequestOptions(),
            data: {'message': 'Unauthorized'},
            statusCode: 401,
          ),
        ),
      );

      // act
      final result = dataSource.insertShipment(params: params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(const InternalException());

      // act
      final result = dataSource.insertShipment(params: params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });

  group('insert shipment document remote data sources test', () {
    final params = InsertShipmentDocumentUseCaseParams(
      shipmentId: 'shipmentId',
      documentPath: File('test/fixtures/models/shipment.json').path,
      stage: 'stage',
    );

    test('should return String when request status code is 200', () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {'message': 'Success insert shipment document!', 'data': null},
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.insertShipmentDocument(params: params);

      // assert
      expect(result, isA<String>());
      verify(() => mockDio.post(any(), data: any(named: 'data'))).called(1);
    });

    test('should throw ServerException when request status code is not 200',
        () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            requestOptions: RequestOptions(),
            data: {'message': 'Unauthorized'},
            statusCode: 401,
          ),
        ),
      );

      // act
      final result = dataSource.insertShipmentDocument(params: params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(const InternalException());

      // act
      final result = dataSource.insertShipmentDocument(params: params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });
}
