import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ship_tracker/core/errors/exceptions.dart';
import 'package:ship_tracker/features/supplier/data/datasources/supplier_remote_data_source.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/supplier_test_data.dart';
import '../../../../helpers/testdata/test_data.dart';
import '../../../../mocks/mocks.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'supplier');
  late MockDio mockDio;
  late SupplierRemoteDataSourceImpl supplierRemoteDataSource;

  setUp(() {
    mockDio = MockDio();
    supplierRemoteDataSource = SupplierRemoteDataSourceImpl(dio: mockDio);
  });

  group('fetch supplier remote data source test', () {
    const params = tFetchSupplierParams;
    const resultMatcher = tFetchSupplierSuccess;

    test(
      'should return SupplierDetailEntity when request is successful',
      () async {
        // arrange
        final jsonString = fixtureReader.dataSource('fetch_supplier.json');
        final json = jsonDecode(jsonString);
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            data: json,
            statusCode: 200,
          ),
        );

        // act
        final result = await supplierRemoteDataSource.fetchSupplier(params);

        // assert
        expect(result, resultMatcher);
        verify(() => mockDio.get('/supplier/${params.supplierId}')).called(1);
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
      final future = supplierRemoteDataSource.fetchSupplier(params);

      // assert
      await expectLater(() => future, throwsA(isA<ServerException>()));
      verify(() => mockDio.get('/supplier/${params.supplierId}')).called(1);
    });
  });

  group('fetch suppliers remote data source test', () {
    const params = tFetchSuppliersParams;
    const resultMatcher = tFetchSuppliersSuccess;

    test(
      'should return List<SupplierEntity> when request is successful',
      () async {
        // arrange
        final jsonString = fixtureReader.dataSource('fetch_suppliers.json');
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
        final result = await supplierRemoteDataSource.fetchSuppliers(params);

        // assert
        expect(result, resultMatcher);
        verify(
          () => mockDio.get(
            '/supplier',
            queryParameters: {
              'column': params.column,
              'order': params.sort,
              'search': params.search.query,
              'limit': params.paginate.limit,
              'page': params.paginate.page,
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
      final future = supplierRemoteDataSource.fetchSuppliers(params);

      // assert
      await expectLater(() => future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.get(
          '/supplier',
          queryParameters: {
            'column': params.column,
            'order': params.sort,
            'search': params.search.query,
            'limit': params.paginate.limit,
            'page': params.paginate.page,
          },
        ),
      ).called(1);
    });
  });

  group('fetch suppliers dropdown remote data source test', () {
    const params = tFetchSuppliersDropdownParams;
    const resultMatcher = tFetchSuppliersDropdownSuccess;

    test(
      'should return List<DropdownEntity> when request is successful',
      () async {
        // arrange
        final jsonString = fixtureReader.dataSource(
          'fetch_suppliers_dropdown.json',
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
        final result = await supplierRemoteDataSource.fetchSuppliersDropdown(
          params,
        );

        // assert
        expect(result, resultMatcher);
        verify(
          () => mockDio.get(
            '/supplier/dropdown',
            queryParameters: {
              'search': params.search.query,
              'limit': params.paginate.limit,
              'page': params.paginate.page,
              'show_all': params.showAll,
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
      final future = supplierRemoteDataSource.fetchSuppliersDropdown(params);

      // assert
      await expectLater(() => future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.get(
          '/supplier/dropdown',
          queryParameters: {
            'search': params.search.query,
            'limit': params.paginate.limit,
            'page': params.paginate.page,
            'show_all': params.showAll,
          },
        ),
      ).called(1);
    });
  });

  group('create supplier remote data source test', () {
    const params = tCreateSupplierParams;
    const resultMatcher = tCreateSupplierSuccess;

    test('should return String message when request is successful', () async {
      // arrange
      final jsonString = fixtureReader.dataSource('create_supplier.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await supplierRemoteDataSource.createSupplier(params);

      // assert
      expect(result, resultMatcher);
      verify(
        () => mockDio.post('/supplier', data: any(named: 'data')),
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
      final future = supplierRemoteDataSource.createSupplier(params);

      // assert
      await expectLater(() => future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.post('/supplier', data: any(named: 'data')),
      ).called(1);
    });
  });

  group('update supplier remote data source test', () {
    const params = tUpdateSupplierParams;
    const resultMatcher = tUpdateSupplierSuccess;
    final file = File(params.avatar ?? '-');

    setUp(() {
      file.writeAsStringSync('lorem');
    });

    tearDown(() {
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('should return String message when request is successful', () async {
      // arrange
      final jsonString = fixtureReader.dataSource('update_supplier.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.put(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await supplierRemoteDataSource.updateSupplier(params);

      // assert
      expect(result, resultMatcher);
      verify(
        () => mockDio.put('/supplier/${params.id}', data: any(named: 'data')),
      ).called(1);
    });

    test('should throw ServerException when API returns 4xx/5xx', () async {
      // arrange
      when(() => mockDio.put(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tServerException,
          type: DioExceptionType.badResponse,
        ),
      );

      // act
      final future = supplierRemoteDataSource.updateSupplier(params);

      // assert
      await expectLater(() => future, throwsA(isA<ServerException>()));
      verify(
        () => mockDio.put('/supplier/${params.id}', data: any(named: 'data')),
      ).called(1);
    });
  });
}
