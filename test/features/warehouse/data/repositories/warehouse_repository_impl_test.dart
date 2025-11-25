import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ship_tracker/core/errors/exceptions.dart';
import 'package:ship_tracker/core/failure/failure.dart';
import 'package:ship_tracker/features/warehouse/data/repositories/warehouse_repository_impl.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/test_data.dart';
import '../../../../helpers/testdata/warehouse_test_data.dart';
import '../../../../mocks/mocks.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'warehouse');
  late MockWarehouseRemoteDataSource mockWarehouseRemoteDataSource;
  late WarehouseRepositoryImpl warehouseRepository;

  setUpAll(() {
    registerFallbackValue(tDeletePurchaseNoteParams);
    registerFallbackValue(tFetchPurchaseNoteParams);
    registerFallbackValue(tFetchPurchaseNotesParams);
    registerFallbackValue(tFetchPurchaseNotesDropdownParams);
    registerFallbackValue(tInsertPurchaseNoteFileParams);
    registerFallbackValue(tInsertPurchaseNoteManualParams);
    registerFallbackValue(tInsertReturnCostParams);
    registerFallbackValue(tInsertShippingFeeParams);
    registerFallbackValue(tUpdatePurchaseNoteParams);
  });

  setUp(() {
    mockWarehouseRemoteDataSource = MockWarehouseRemoteDataSource();
    warehouseRepository = WarehouseRepositoryImpl(
      warehouseRemoteDataSource: mockWarehouseRemoteDataSource,
    );
  });

  group('delete purchase note repository test', () {
    const params = tDeletePurchaseNoteParams;
    const resultMatcher = tDeletePurchaseNoteSuccess;

    test('should return Right(String) when remote call is successful',
        () async {
      // arrange
      when(() => mockWarehouseRemoteDataSource.deletePurchaseNote(any()))
          .thenAnswer((_) async => resultMatcher);

      // act
      final result = await warehouseRepository.deletePurchaseNote(params);
      // assert
      expect(result, const Right(resultMatcher));
      verify(() => mockWarehouseRemoteDataSource.deletePurchaseNote(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockWarehouseRemoteDataSource.deletePurchaseNote(any()))
          .thenThrow(tServerException);

      // act
      final result = await warehouseRepository.deletePurchaseNote(params);
      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockWarehouseRemoteDataSource.deletePurchaseNote(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });
  });

  group('fetch purchase note repository test', () {
    final params = tFetchPurchaseNoteParams;
    final resultMatcher = tFetchPurchaseNoteSuccess;

    test(
        'should return Right(PurchaseNoteDetailEntity) when remote call is successful',
        () async {
      // arrange
      when(() => mockWarehouseRemoteDataSource.fetchPurchaseNote(any()))
          .thenAnswer((_) async => resultMatcher);

      // act
      final result = await warehouseRepository.fetchPurchaseNote(params);

      // assert
      expect(result, Right(resultMatcher));
      verify(() => mockWarehouseRemoteDataSource.fetchPurchaseNote(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockWarehouseRemoteDataSource.fetchPurchaseNote(any()))
          .thenThrow(tServerException);

      // act
      final result = await warehouseRepository.fetchPurchaseNote(params);

      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockWarehouseRemoteDataSource.fetchPurchaseNote(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });
  });

  group('fetch purchase notes repository test', () {
    const params = tFetchPurchaseNotesParams;
    final resultMatcher = tFetchPurchaseNotesSuccess;

    test(
        'should return Right(List<PurchaseNoteSummaryEntity>) when remote call is successful',
        () async {
      // arrange
      when(() => mockWarehouseRemoteDataSource.fetchPurchaseNotes(any()))
          .thenAnswer((_) async => resultMatcher);

      // act
      final result = await warehouseRepository.fetchPurchaseNotes(params);

      // assert
      expect(result, Right(resultMatcher));
      verify(() => mockWarehouseRemoteDataSource.fetchPurchaseNotes(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockWarehouseRemoteDataSource.fetchPurchaseNotes(any()))
          .thenThrow(tServerException);

      // act
      final result = await warehouseRepository.fetchPurchaseNotes(params);

      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockWarehouseRemoteDataSource.fetchPurchaseNotes(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });
  });

  group('fetch purchase notes dropdown repository test', () {
    const params = tFetchPurchaseNotesDropdownParams;
    const resultMatcher = tFetchPurchaseNotesDropdownSuccess;

    test(
        'should return Right(List<DropdownEntity>) when remote call is successful',
        () async {
      // arrange
      when(() =>
              mockWarehouseRemoteDataSource.fetchPurchaseNotesDropdown(any()))
          .thenAnswer((_) async => resultMatcher);

      // act
      final result =
          await warehouseRepository.fetchPurchaseNotesDropdown(params);

      // assert
      expect(result, const Right(resultMatcher));
      verify(() =>
              mockWarehouseRemoteDataSource.fetchPurchaseNotesDropdown(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() =>
              mockWarehouseRemoteDataSource.fetchPurchaseNotesDropdown(any()))
          .thenThrow(tServerException);

      // act
      final result =
          await warehouseRepository.fetchPurchaseNotesDropdown(params);

      // assert
      expect(result, const Left(tServerFailure));
      verify(() =>
              mockWarehouseRemoteDataSource.fetchPurchaseNotesDropdown(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });
  });

  group('insert purchase note file repository test', () {
    final params = tInsertPurchaseNoteFileParams;
    const resultMatcher = tInsertPurchaseNoteFileSuccess;

    test('should return Right(String) when remote call is successful',
        () async {
      // arrange
      when(() => mockWarehouseRemoteDataSource.insertPurchaseNoteFile(any()))
          .thenAnswer((_) async => resultMatcher);

      // act
      final result = await warehouseRepository.insertPurchaseNoteFile(params);

      // assert
      expect(result, const Right(resultMatcher));
      verify(() => mockWarehouseRemoteDataSource.insertPurchaseNoteFile(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });

    test(
        'should return Left(SpreadsheetFailure) when remote data source throws ServerException with status code 400',
        () async {
      // arrange
      final jsonString =
          fixtureReader.dataSource('error_create_purchase_note_file.json');
      final json = jsonDecode(jsonString);
      when(() => mockWarehouseRemoteDataSource.insertPurchaseNoteFile(any()))
          .thenThrow(ServerException(
        code: 400,
        errors: json,
        message: 'Bad Request',
      ));

      // act
      final result = await warehouseRepository.insertPurchaseNoteFile(params);

      // assert
      expect(result, Left(SpreadsheetFailure.fromJson(json)));
      verify(() => mockWarehouseRemoteDataSource.insertPurchaseNoteFile(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockWarehouseRemoteDataSource.insertPurchaseNoteFile(any()))
          .thenThrow(tServerException);

      // act
      final result = await warehouseRepository.insertPurchaseNoteFile(params);

      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockWarehouseRemoteDataSource.insertPurchaseNoteFile(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });
  });

  group('insert purchase note manual repository test', () {
    final params = tInsertPurchaseNoteManualParams;
    const resultMatcher = tInsertPurchaseNoteManualSuccess;

    test('should return Right(String) when remote call is successful',
        () async {
      // arrange
      when(() => mockWarehouseRemoteDataSource.insertPurchaseNoteManual(any()))
          .thenAnswer((_) async => resultMatcher);

      // act
      final result = await warehouseRepository.insertPurchaseNoteManual(params);

      // assert
      expect(result, const Right(resultMatcher));
      verify(() =>
              mockWarehouseRemoteDataSource.insertPurchaseNoteManual(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockWarehouseRemoteDataSource.insertPurchaseNoteManual(any()))
          .thenThrow(tServerException);

      // act
      final result = await warehouseRepository.insertPurchaseNoteManual(params);

      // assert
      expect(result, const Left(tServerFailure));
      verify(() =>
              mockWarehouseRemoteDataSource.insertPurchaseNoteManual(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });
  });

  group('insert return cost repository test', () {
    const params = tInsertReturnCostParams;
    const resultMatcher = tInsertReturnCostSuccess;

    test('should return Right(String) when remote call is successful',
        () async {
      // arrange
      when(() => mockWarehouseRemoteDataSource.insertReturnCost(any()))
          .thenAnswer((_) async => resultMatcher);

      // act
      final result = await warehouseRepository.insertReturnCost(params);

      // assert
      expect(result, const Right(resultMatcher));
      verify(() => mockWarehouseRemoteDataSource.insertReturnCost(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockWarehouseRemoteDataSource.insertReturnCost(any()))
          .thenThrow(tServerException);

      // act
      final result = await warehouseRepository.insertReturnCost(params);

      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockWarehouseRemoteDataSource.insertReturnCost(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });
  });

  group('insert shipping fee repository test', () {
    const params = tInsertShippingFeeParams;
    const resultMatcher = tInsertShippingFeeSuccess;

    test('should return Right(String) when remote call is successful',
        () async {
      // arrange
      when(() => mockWarehouseRemoteDataSource.insertShippingFee(any()))
          .thenAnswer((_) async => resultMatcher);

      // act
      final result = await warehouseRepository.insertShippingFee(params);

      // assert
      expect(result, const Right(resultMatcher));
      verify(() => mockWarehouseRemoteDataSource.insertShippingFee(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockWarehouseRemoteDataSource.insertShippingFee(any()))
          .thenThrow(tServerException);

      // act
      final result = await warehouseRepository.insertShippingFee(params);

      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockWarehouseRemoteDataSource.insertShippingFee(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });
  });

  group('update purchase note repository test', () {
    final params = tUpdatePurchaseNoteParams;
    const resultMatcher = tUpdatePurchaseNoteSuccess;

    test('should return Right(String) when remote call is successful',
        () async {
      // arrange
      when(() => mockWarehouseRemoteDataSource.updatePurchaseNote(any()))
          .thenAnswer((_) async => resultMatcher);

      // act
      final result = await warehouseRepository.updatePurchaseNote(params);

      // assert
      expect(result, const Right(resultMatcher));
      verify(() => mockWarehouseRemoteDataSource.updatePurchaseNote(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote data source throws ServerException',
        () async {
      // arrange
      when(() => mockWarehouseRemoteDataSource.updatePurchaseNote(any()))
          .thenThrow(tServerException);

      // act
      final result = await warehouseRepository.updatePurchaseNote(params);

      // assert
      expect(result, const Left(tServerFailure));
      verify(() => mockWarehouseRemoteDataSource.updatePurchaseNote(params))
          .called(1);
      verifyNoMoreInteractions(mockWarehouseRemoteDataSource);
    });
  });
}
