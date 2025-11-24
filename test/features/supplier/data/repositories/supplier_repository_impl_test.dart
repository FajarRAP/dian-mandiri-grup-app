import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ship_tracker/features/supplier/data/repositories/supplier_repository_impl.dart';

import '../../../../helpers/testdata/supplier_test_data.dart';
import '../../../../helpers/testdata/test_data.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late MockSupplierRemoteDataSource mockSupplierRemoteDataSource;
  late SupplierRepositoryImpl supplierRepository;

  setUpAll(() {
    registerFallbackValue(tFetchSupplierParams);
    registerFallbackValue(tFetchSuppliersParams);
    registerFallbackValue(tFetchSuppliersDropdownParams);
    registerFallbackValue(tCreateSupplierParams);
    registerFallbackValue(tUpdateSupplierParams);
  });

  setUp(() {
    mockSupplierRemoteDataSource = MockSupplierRemoteDataSource();
    supplierRepository = SupplierRepositoryImpl(
      supplierRemoteDataSource: mockSupplierRemoteDataSource,
    );
  });

  group('fetch supplier repository test', () {
    const params = tFetchSupplierParams;
    const resultMatcher = tFetchSupplierSuccess;

    test('should return Right(String) when remote call is successful',
        () async {
      // arrange
      when(() => mockSupplierRemoteDataSource.fetchSupplier(any()))
          .thenAnswer((_) async => resultMatcher);

      // act
      final result = await supplierRepository.fetchSupplier(params);
      // assert
      expect(result, const Right(resultMatcher));
      verify(() => mockSupplierRemoteDataSource.fetchSupplier(params))
          .called(1);
      verifyNoMoreInteractions(mockSupplierRemoteDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockSupplierRemoteDataSource.fetchSupplier(any()))
          .thenThrow(tServerException);

      // act
      final result = await supplierRepository.fetchSupplier(params);

      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockSupplierRemoteDataSource.fetchSupplier(params))
          .called(1);
      verifyNoMoreInteractions(mockSupplierRemoteDataSource);
    });
  });

  group('fetch suppliers repository test', () {
    const params = tFetchSuppliersParams;
    const resultMatcher = tFetchSuppliersSuccess;

    test(
        'should return Right(List<SupplierEntity>) when remote call is successful',
        () async {
      // arrange
      when(() => mockSupplierRemoteDataSource.fetchSuppliers(any()))
          .thenAnswer((_) async => resultMatcher);

      // act
      final result = await supplierRepository.fetchSuppliers(params);
      // assert
      expect(result, const Right(resultMatcher));
      verify(() => mockSupplierRemoteDataSource.fetchSuppliers(params))
          .called(1);
      verifyNoMoreInteractions(mockSupplierRemoteDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockSupplierRemoteDataSource.fetchSuppliers(any()))
          .thenThrow(tServerException);

      // act
      final result = await supplierRepository.fetchSuppliers(params);

      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockSupplierRemoteDataSource.fetchSuppliers(params))
          .called(1);
      verifyNoMoreInteractions(mockSupplierRemoteDataSource);
    });
  });

  group('fetch suppliers dropdown repository test', () {
    const params = tFetchSuppliersDropdownParams;
    const resultMatcher = tFetchSuppliersDropdownSuccess;

    test(
        'should return Right(List<DropdownEntity>) when remote call is successful',
        () async {
      // arrange
      when(() => mockSupplierRemoteDataSource.fetchSuppliersDropdown(any()))
          .thenAnswer((_) async => resultMatcher);

      // act
      final result = await supplierRepository.fetchSuppliersDropdown(params);
      // assert
      expect(result, const Right(resultMatcher));
      verify(() => mockSupplierRemoteDataSource.fetchSuppliersDropdown(params))
          .called(1);
      verifyNoMoreInteractions(mockSupplierRemoteDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockSupplierRemoteDataSource.fetchSuppliersDropdown(any()))
          .thenThrow(tServerException);

      // act
      final result = await supplierRepository.fetchSuppliersDropdown(params);

      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockSupplierRemoteDataSource.fetchSuppliersDropdown(params))
          .called(1);
      verifyNoMoreInteractions(mockSupplierRemoteDataSource);
    });
  });

  group('create supplier repository test', () {
    const params = tCreateSupplierParams;
    const resultMatcher = tCreateSupplierSuccess;

    test('should return Right(String) when remote call is successful',
        () async {
      // arrange
      when(() => mockSupplierRemoteDataSource.insertSupplier(any()))
          .thenAnswer((_) async => resultMatcher);

      // act
      final result = await supplierRepository.insertSupplier(params);

      // assert
      expect(result, const Right(resultMatcher));
      verify(() => mockSupplierRemoteDataSource.insertSupplier(params))
          .called(1);
      verifyNoMoreInteractions(mockSupplierRemoteDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockSupplierRemoteDataSource.insertSupplier(any()))
          .thenThrow(tServerException);

      // act
      final result = await supplierRepository.insertSupplier(params);

      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockSupplierRemoteDataSource.insertSupplier(params))
          .called(1);
      verifyNoMoreInteractions(mockSupplierRemoteDataSource);
    });
  });

  group('update supplier repository test', () {
    const params = tUpdateSupplierParams;
    const resultMatcher = tUpdateSupplierSuccess;

    test('should return Right(String) when remote call is successful',
        () async {
      // arrange
      when(() => mockSupplierRemoteDataSource.updateSupplier(any()))
          .thenAnswer((_) async => resultMatcher);

      // act
      final result = await supplierRepository.updateSupplier(params);

      // assert
      expect(result, const Right(resultMatcher));
      verify(() => mockSupplierRemoteDataSource.updateSupplier(params))
          .called(1);
      verifyNoMoreInteractions(mockSupplierRemoteDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockSupplierRemoteDataSource.updateSupplier(any()))
          .thenThrow(tServerException);

      // act
      final result = await supplierRepository.updateSupplier(params);

      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockSupplierRemoteDataSource.updateSupplier(params))
          .called(1);
      verifyNoMoreInteractions(mockSupplierRemoteDataSource);
    });
  });
}
