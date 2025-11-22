import 'package:dartz/dartz.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/purchase_note_detail_entity.dart';
import '../../domain/entities/purchase_note_summary_entity.dart';
import '../../domain/repositories/warehouse_repositories.dart';
import '../../domain/usecases/fetch_purchase_notes_dropdown_use_case.dart';
import '../../domain/usecases/fetch_purchase_notes_use_case.dart';
import '../../domain/usecases/insert_purchase_note_file_use_case.dart';
import '../../domain/usecases/insert_purchase_note_manual_use_case.dart';
import '../../domain/usecases/insert_return_cost_use_case.dart';
import '../../domain/usecases/insert_shipping_fee_use_case.dart';
import '../../domain/usecases/update_purchase_note_use_case.dart';
import '../datasources/warehouse_remote_data_sources.dart';

class WarehouseRepositoriesImpl extends WarehouseRepositories {
  WarehouseRepositoriesImpl({required this.warehouseRemoteDataSources});

  final WarehouseRemoteDataSources warehouseRemoteDataSources;

  @override
  Future<Either<Failure, String>> deletePurchaseNote(
      {required String purchaseNoteId}) async {
    try {
      final result = await warehouseRemoteDataSources.deletePurchaseNote(
          purchaseNoteId: purchaseNoteId);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, PurchaseNoteDetailEntity>> fetchPurchaseNote(
      {required String purchaseNoteId}) async {
    try {
      final result = await warehouseRemoteDataSources.fetchPurchaseNote(
          purchaseNoteId: purchaseNoteId);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<PurchaseNoteSummaryEntity>>> fetchPurchaseNotes(
      {required FetchPurchaseNotesUseCaseParams params}) async {
    try {
      final result =
          await warehouseRemoteDataSources.fetchPurchaseNotes(params: params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<DropdownEntity>>> fetchPurchaseNotesDropdown(
      {required FetchPurchaseNotesDropdownUseCaseParams params}) async {
    try {
      final result = await warehouseRemoteDataSources
          .fetchPurchaseNotesDropdown(params: params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> insertPurchaseNoteFile(
      {required InsertPurchaseNoteFileUseCaseParams params}) async {
    try {
      final result = await warehouseRemoteDataSources.insertPurchaseNoteFile(
          params: params);

      return Right(result);
    } on ServerException catch (se) {
      switch (se.statusCode) {
        case 400:
          if (List.from(se.errors?['data']['header']).isNotEmpty) {
            return Left(SpreadsheetFailure.fromJson(se.errors ?? {}));
          }

          return Left(ServerFailure(
            message: se.message,
            statusCode: se.statusCode,
          ));
        default:
          return Left(ServerFailure(
            message: se.message,
            statusCode: se.statusCode,
          ));
      }
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> insertPurchaseNoteManual(
      {required InsertPurchaseNoteManualUseCaseParams params}) async {
    try {
      final result = await warehouseRemoteDataSources.insertPurchaseNoteManual(
          params: params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> insertReturnCost(
      {required InsertReturnCostUseCaseParams params}) async {
    try {
      final result =
          await warehouseRemoteDataSources.insertReturnCost(params: params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> insertShippingFee(
      {required InsertShippingFeeUseCaseParams params}) async {
    try {
      final result =
          await warehouseRemoteDataSources.insertShippingFee(params: params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> updatePurchaseNote(
      {required UpdatePurchaseNoteUseCaseParams params}) async {
    try {
      final result =
          await warehouseRemoteDataSources.updatePurchaseNote(params: params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }
}
