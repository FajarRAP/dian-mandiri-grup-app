import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ship_tracker/core/errors/exceptions.dart';
import 'package:ship_tracker/features/warehouse/data/datasources/warehouse_remote_data_source.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/test_data.dart';
import '../../../../helpers/testdata/warehouse_test_data.dart';
import '../../../../mocks/mocks.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'warehouse');
  late MockDio mockDio;
  late WarehouseRemoteDataSourceImpl warehouseRemoteDataSource;

  setUp(() {
    mockDio = MockDio();
    warehouseRemoteDataSource = WarehouseRemoteDataSourceImpl(dio: mockDio);
  });

  group('delete purchase note remote data source test', () {
    const params = tDeletePurchaseNoteParams;
    const resultMatcher = tDeletePurchaseNoteSuccess;

    test('should return String when request is successful', () async {
      // arrange
      final jsonString = fixtureReader.dataSource('delete_purchase_note.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.delete(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await warehouseRemoteDataSource.deletePurchaseNote(params);

      // assert
      expect(result, resultMatcher);
      verify(
        () => mockDio.delete('/purchase-note/${params.purchaseNoteId}'),
      ).called(1);
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
      final future = warehouseRemoteDataSource.deletePurchaseNote(params);

      // assert
      await expectLater(future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.delete('/purchase-note/${params.purchaseNoteId}'),
      ).called(1);
    });
  });

  group('fetch purchase note remote data source test', () {
    final params = tFetchPurchaseNoteParams;
    final resultMatcher = tFetchPurchaseNoteSuccess;

    test(
      'should return PurchaseNoteDetailEntity when request is successful',
      () async {
        final jsonString = fixtureReader.dataSource('fetch_purchase_note.json');
        final json = jsonDecode(jsonString);
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            data: json,
            statusCode: 200,
          ),
        );

        final result = await warehouseRemoteDataSource.fetchPurchaseNote(
          params,
        );

        expect(result, resultMatcher);
        verify(
          () => mockDio.get('/purchase-note/${params.purchaseNoteId}'),
        ).called(1);
      },
    );

    test('should throw ServerException when API returns 4xx/5xx', () async {
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse,
        ),
      );

      final future = warehouseRemoteDataSource.fetchPurchaseNote(params);

      await expectLater(future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.get('/purchase-note/${params.purchaseNoteId}'),
      ).called(1);
    });
  });

  group('fetch purchase notes remote data source test', () {
    const params = tFetchPurchaseNotesParams;
    final resultMatcher = tFetchPurchaseNotesSuccess;

    test(
      'should return List<PurchaseNoteSummaryEntity> when request is successful',
      () async {
        final jsonString = fixtureReader.dataSource(
          'fetch_purchase_notes.json',
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

        final result = await warehouseRemoteDataSource.fetchPurchaseNotes(
          params,
        );

        expect(result, resultMatcher);
        verify(
          () => mockDio.get(
            '/purchase-note',
            queryParameters: {
              'column': params.column,
              'sort': params.sort,
              'search': params.search.query,
              'limit': params.paginate.limit,
              'page': params.paginate.page,
            },
          ),
        ).called(1);
      },
    );

    test('should throw ServerException when API returns 4xx/5xx', () async {
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

      final future = warehouseRemoteDataSource.fetchPurchaseNotes(params);

      await expectLater(future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.get(
          '/purchase-note',
          queryParameters: {
            'column': params.column,
            'sort': params.sort,
            'search': params.search.query,
            'limit': params.paginate.limit,
            'page': params.paginate.page,
          },
        ),
      ).called(1);
    });
  });

  group('fetch purchase notes dropdown remote data source test', () {
    const params = tFetchPurchaseNotesDropdownParams;
    const resultMatcher = tFetchPurchaseNotesDropdownSuccess;

    test(
      'should return List<DropdownEntity> when request is successful',
      () async {
        final jsonString = fixtureReader.dataSource(
          'fetch_purchase_notes_dropdown.json',
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

        final result = await warehouseRemoteDataSource
            .fetchPurchaseNotesDropdown(params);

        expect(result, resultMatcher);
        verify(
          () => mockDio.get(
            '/purchase-note/dropdown',
            queryParameters: {
              'search': params.search,
              'limit': params.limit,
              'page': params.page,
            },
          ),
        ).called(1);
      },
    );

    test('should throw ServerException when API returns 4xx/5xx', () async {
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

      final future = warehouseRemoteDataSource.fetchPurchaseNotesDropdown(
        params,
      );

      await expectLater(future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.get(
          '/purchase-note/dropdown',
          queryParameters: {
            'search': params.search,
            'limit': params.limit,
            'page': params.page,
          },
        ),
      ).called(1);
    });
  });

  group('insert purchase note file remote data source test', () {
    final params = tInsertPurchaseNoteFileParams;
    const resultMatcher = tInsertPurchaseNoteFileSuccess;
    final file = File(params.receipt);
    final spreadsheet = File(params.file);

    setUp(() {
      file.createSync();
      spreadsheet.createSync();
    });

    tearDown(() {
      if (file.existsSync()) {
        file.deleteSync();
      }
      if (spreadsheet.existsSync()) {
        spreadsheet.deleteSync();
      }
    });

    test('should return String when request is successful', () async {
      final jsonString = fixtureReader.dataSource(
        'create_purchaes_note_file.json',
      );
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      final result = await warehouseRemoteDataSource.importPurchaseNote(params);

      expect(result, resultMatcher);
      verify(
        () => mockDio.post(
          '/purchase-note/spreadsheet',
          data: any(named: 'data'),
        ),
      ).called(1);
    });

    test('should throw ServerException when API returns 4xx/5xx', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse,
        ),
      );

      final future = warehouseRemoteDataSource.importPurchaseNote(params);

      await expectLater(future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.post(
          '/purchase-note/spreadsheet',
          data: any(named: 'data'),
        ),
      ).called(1);
    });
  });

  group('insert purchase note manual remote data source test', () {
    final params = tInsertPurchaseNoteManualParams;
    const resultMatcher = tInsertPurchaseNoteManualSuccess;
    final file = File(params.receipt);

    setUp(() {
      file.createSync();
    });

    tearDown(() {
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('should return String when request is successful', () async {
      final jsonString = fixtureReader.dataSource(
        'create_purchase_note_manual.json',
      );
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      final result = await warehouseRemoteDataSource.createPurchaseNote(params);

      expect(result, resultMatcher);
      verify(
        () => mockDio.post('/purchase-note', data: any(named: 'data')),
      ).called(1);
    });

    test('should throw ServerException when API returns 4xx/5xx', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse,
        ),
      );

      final future = warehouseRemoteDataSource.createPurchaseNote(params);

      await expectLater(future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.post('/purchase-note', data: any(named: 'data')),
      ).called(1);
    });
  });

  group('insert return cost remote data source test', () {
    const params = tInsertReturnCostParams;
    const resultMatcher = tInsertReturnCostSuccess;

    test('should return String when request is successful', () async {
      final jsonString = fixtureReader.dataSource('update_return_cost.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.patch(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      final result = await warehouseRemoteDataSource.insertReturnCost(params);

      expect(result, resultMatcher);
      verify(
        () => mockDio.patch(
          '/purchase-note/${params.purchaseNoteId}/return-cost',
          data: {'amount': params.amount},
        ),
      ).called(1);
    });

    test('should throw ServerException when API returns 4xx/5xx', () async {
      when(() => mockDio.patch(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse,
        ),
      );

      final future = warehouseRemoteDataSource.insertReturnCost(params);

      await expectLater(future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.patch(
          '/purchase-note/${params.purchaseNoteId}/return-cost',
          data: {'amount': params.amount},
        ),
      ).called(1);
    });
  });

  group('insert shipping fee remote data source test', () {
    const params = tInsertShippingFeeParams;
    const resultMatcher = tInsertShippingFeeSuccess;

    test('should return String when request is successful', () async {
      final jsonString = fixtureReader.dataSource('create_shipping_fee.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      final result = await warehouseRemoteDataSource.insertShippingFee(params);

      expect(result, resultMatcher);
      verify(
        () => mockDio.post(
          '/purchase-note/shipment-price',
          data: any(named: 'data'),
        ),
      ).called(1);
    });

    test('should throw ServerException when API returns 4xx/5xx', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse,
        ),
      );

      final future = warehouseRemoteDataSource.insertShippingFee(params);

      await expectLater(future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.post(
          '/purchase-note/shipment-price',
          data: any(named: 'data'),
        ),
      ).called(1);
    });
  });

  group('update purchase note remote data source test', () {
    final params = tUpdatePurchaseNoteParams;
    const resultMatcher = tUpdatePurchaseNoteSuccess;

    test('should return String when request is successful', () async {
      final jsonString = fixtureReader.dataSource('update_purchase_note.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.put(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      final result = await warehouseRemoteDataSource.updatePurchaseNote(params);

      expect(result, resultMatcher);
      verify(
        () => mockDio.put(
          '/purchase-note/${params.purchaseNoteId}',
          data: any(named: 'data'),
        ),
      ).called(1);
    });

    test('should throw ServerException when API returns 4xx/5xx', () async {
      when(() => mockDio.put(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse,
        ),
      );

      final future = warehouseRemoteDataSource.updatePurchaseNote(params);

      await expectLater(future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.put(
          '/purchase-note/${params.purchaseNoteId}',
          data: any(named: 'data'),
        ),
      ).called(1);
    });
  });
}
