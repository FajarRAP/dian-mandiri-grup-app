import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/insert_purchase_note_file_entity.dart';
import '../../domain/entities/insert_purchase_note_manual_entity.dart';
import '../../domain/entities/purchase_note_detail_entity.dart';
import '../../domain/entities/purchase_note_summary_entity.dart';
import '../../domain/repositories/warehouse_repositories.dart';
import '../datasources/warehouse_remote_data_sources.dart';
import '../models/insert_purchase_note_file_model.dart';
import '../models/insert_purchase_note_manual_model.dart';
import '../models/purchase_note_detail_model.dart';
import '../models/purchase_note_summary_model.dart';

class WarehouseRepositoriesImpl extends WarehouseRepositories {
  final WarehouseRemoteDataSources<Response> warehouseRemoteDataSources;

  WarehouseRepositoriesImpl({required this.warehouseRemoteDataSources});

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
          return Left(Failure());
      }
    } catch (e) {
      return Left(Failure());
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
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, List<PurchaseNoteSummaryEntity>>> fetchPurchaseNotes(
      {String column = 'created_at',
      String order = 'asc',
      String? search,
      int limit = 10,
      int page = 1}) async {
    try {
      final response = await warehouseRemoteDataSources.fetchPurchaseNotes(
          column: column,
          order: order,
          search: search,
          limit: limit,
          page: page);
      final datas =
          List<Map<String, dynamic>>.from(response.data['data']['content']);

      return Right(datas.map(PurchaseNoteSummaryModel.fromJson).toList());
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, List<DropdownEntity>>> fetchPurchaseNotesDropdown(
      {String? search, int limit = 10, int page = 1}) async {
    try {
      final response =
          await warehouseRemoteDataSources.fetchPurchaseNotesDropdown(
        search: search,
        limit: limit,
        page: page,
      );
      final datas =
          List<Map<String, dynamic>>.from(response.data['data']['content']);

      return Right(datas.map(DropdownEntity.fromJson).toList());
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> insertPurchaseNoteFile(
      {required InsertPurchaseNoteFileEntity purchaseNote}) async {
    try {
      final payload =
          InsertPurchaseNoteFileModel.fromEntity(purchaseNote).toJson();
      payload['receipt'] = await MultipartFile.fromFile(purchaseNote.receipt);
      payload['spreadsheet'] = await MultipartFile.fromFile(purchaseNote.file);

      final response = await warehouseRemoteDataSources.insertPurchaseNoteFile(
          data: payload);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 400:
          if (List.from(de.response?.data['data']['header']).isNotEmpty) {
            return Left(SpreadsheetFailure.fromJson(de.response?.data));
          }

          return Left(Failure(message: de.response?.data['message']));
        default:
          return Left(Failure());
      }
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> insertPurchaseNoteManual(
      {required InsertPurchaseNoteManualEntity purchaseNote}) async {
    try {
      final payload =
          InsertPurchaseNoteManualModel.fromEntity(purchaseNote).toJson();
      payload['receipt'] = await MultipartFile.fromFile(purchaseNote.receipt);
      payload['items'] = jsonEncode(payload['items']);

      final response = await warehouseRemoteDataSources
          .insertPurchaseNoteManual(data: payload);
      return Right(response.data['message'] ?? 'Berhasil');
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 400:
          return Left(Failure(message: de.response?.data['message']));
        default:
          return Left(Failure());
      }
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> insertReturnCost(
      {required String purchaseNoteId, required int amount}) async {
    try {
      final response = await warehouseRemoteDataSources.insertReturnCost(
          purchaseNoteId: purchaseNoteId, amount: amount);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 400:
          return Left(Failure(message: de.response?.data['message']));
        default:
          return Left(Failure());
      }
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> insertShippingFee(
      {required int price, required List<String> purchaseNoteIds}) async {
    try {
      final response = await warehouseRemoteDataSources.insertShippingFee(
        data: {
          'date': DateTime.now().toUtc().toIso8601String(),
          'price': price,
          'receipt': purchaseNoteIds,
        },
      );

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 400:
          return Left(Failure(message: de.response?.data['message']));

        default:
          return Left(Failure());
      }
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> updatePurchaseNote(
      {required String purchaseNoteId,
      required InsertPurchaseNoteManualEntity purchaseNote}) async {
    try {
      final payload =
          InsertPurchaseNoteManualModel.fromEntity(purchaseNote).toJson();
      if (!purchaseNote.receipt.startsWith('https://')) {
        payload['receipt'] = await MultipartFile.fromFile(purchaseNote.receipt);
      }
      payload['items'] = jsonEncode(payload['items']);

      final response = await warehouseRemoteDataSources.updatePurchaseNote(
          data: payload, purchaseNoteId: purchaseNoteId);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 400:
          return Left(Failure(message: de.response?.data['message']));
        default:
          return Left(Failure());
      }
    } catch (e) {
      return Left(Failure());
    }
  }
}
