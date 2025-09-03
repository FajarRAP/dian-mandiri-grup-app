import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/insert_purchase_note_file_entity.dart';
import '../../domain/entities/insert_purchase_note_manual_entity.dart';
import '../../domain/entities/purchase_note_detail_entity.dart';
import '../../domain/entities/purchase_note_summary_entity.dart';
import '../../domain/repositories/warehouse_repositories.dart';
import '../../domain/usecases/fetch_purchase_notes_dropdown_use_case.dart';
import '../../domain/usecases/fetch_purchase_notes_use_case.dart';
import '../../domain/usecases/insert_return_cost_use_case.dart';
import '../../domain/usecases/insert_shipping_fee_use_case.dart';
import '../../domain/usecases/update_purchase_note_use_case.dart';
import '../datasources/warehouse_remote_data_sources.dart';
import '../models/purchase_note_detail_model.dart';
import '../models/purchase_note_summary_model.dart';

class WarehouseRepositoriesImpl extends WarehouseRepositories {
  WarehouseRepositoriesImpl({required this.warehouseRemoteDataSources});

  final WarehouseRemoteDataSources<Response> warehouseRemoteDataSources;

  @override
  Future<Either<Failure, String>> deletePurchaseNote(
      {required String purchaseNoteId}) async {
    try {
      final response = await warehouseRemoteDataSources.deletePurchaseNote(
          purchaseNoteId: purchaseNoteId);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          return Left(Failure(message: '$de'));
      }
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, PurchaseNoteDetailEntity>> fetchPurchaseNote(
      {required String purchaseNoteId}) async {
    try {
      final response = await warehouseRemoteDataSources.fetchPurchaseNote(
          purchaseNoteId: purchaseNoteId);

      return Right(PurchaseNoteDetailModel.fromJson(response.data['data']));
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, List<PurchaseNoteSummaryEntity>>> fetchPurchaseNotes(
      {required FetchPurchaseNotesUseCaseParams params}) async {
    try {
      final response =
          await warehouseRemoteDataSources.fetchPurchaseNotes(params: params);
      final contents =
          List<Map<String, dynamic>>.from(response.data['data']['content']);

      return Right(contents.map(PurchaseNoteSummaryModel.fromJson).toList());
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, List<DropdownEntity>>> fetchPurchaseNotesDropdown(
      {required FetchPurchaseNotesDropdownUseCaseParams params}) async {
    try {
      final response = await warehouseRemoteDataSources
          .fetchPurchaseNotesDropdown(params: params);
      final contents =
          List<Map<String, dynamic>>.from(response.data['data']['content']);

      return Right(contents.map(DropdownEntity.fromJson).toList());
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, String>> insertPurchaseNoteFile(
      {required InsertPurchaseNoteFileEntity purchaseNote}) async {
    try {
      final response = await warehouseRemoteDataSources.insertPurchaseNoteFile(
          params: purchaseNote);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 400:
          if (List.from(de.response?.data['data']['header']).isNotEmpty) {
            return Left(SpreadsheetFailure.fromJson(de.response?.data));
          }

          return Left(Failure(message: de.response?.data['message']));
        default:
          return Left(Failure(message: '$de'));
      }
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, String>> insertPurchaseNoteManual(
      {required InsertPurchaseNoteManualEntity purchaseNote}) async {
    try {
      final response = await warehouseRemoteDataSources
          .insertPurchaseNoteManual(params: purchaseNote);

      return Right(response.data['message'] ?? 'Berhasil');
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 400:
          return Left(Failure(message: de.response?.data['message']));
        default:
          return Left(Failure(message: '$de'));
      }
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, String>> insertReturnCost(
      {required InsertReturnCostUseCaseParams params}) async {
    try {
      final response =
          await warehouseRemoteDataSources.insertReturnCost(params: params);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 400:
          return Left(Failure(message: de.response?.data['message']));
        default:
          return Left(Failure(message: '$de'));
      }
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, String>> insertShippingFee(
      {required InsertShippingFeeUseCaseParams params}) async {
    try {
      final response =
          await warehouseRemoteDataSources.insertShippingFee(params: params);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 400:
          return Left(Failure(message: de.response?.data['message']));
        default:
          return Left(Failure(message: '$de'));
      }
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, String>> updatePurchaseNote(
      {required UpdatePurchaseNoteUseCaseParams params}) async {
    try {
      final response =
          await warehouseRemoteDataSources.updatePurchaseNote(params: params);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 400:
          return Left(Failure(message: de.response?.data['message']));
        default:
          return Left(Failure(message: '$de'));
      }
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }
}
