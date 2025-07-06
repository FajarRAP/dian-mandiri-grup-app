import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/insert_purchase_note_file_entity.dart';
import '../../domain/entities/insert_purchase_note_manual_entity.dart';
import '../../domain/entities/purchase_note_detail_entity.dart';
import '../../domain/entities/purchase_note_summary_entity.dart';
import '../../domain/repositories/warehouse_repositories.dart';
import '../datasources/warehouse_remote_data_sources.dart';
import '../models/purchase_note_detail_model.dart';
import '../models/purchase_note_summary_model.dart';

class WarehouseRepositoriesImpl extends WarehouseRepositories {
  final WarehouseRemoteDataSources warehouseRemoteDataSources;

  WarehouseRepositoriesImpl({required this.warehouseRemoteDataSources});

  @override
  Future<Either<Failure, String>> deletePurchaseNote(
      {required String purchaseNoteId}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1800));
      final response = await warehouseRemoteDataSources.deletePurchaseNote(
          purchaseNoteId: purchaseNoteId);
      final data = jsonDecode(response);

      return Right(data['message']);
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, PurchaseNoteDetailEntity>> fetchPurchaseNote(
      {required String purchaseNoteId}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1800));
      final response = await warehouseRemoteDataSources.fetchPurchaseNote(
          purchaseNoteId: purchaseNoteId);
      final data = jsonDecode(response);

      return Right(PurchaseNoteDetailModel.fromJson(data));
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, List<PurchaseNoteSummaryEntity>>> fetchPurchaseNotes(
      {String column = 'name',
      String order = 'asc',
      String? search,
      int limit = 10,
      int page = 1}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1800));
      final response = await warehouseRemoteDataSources.fetchPurchaseNotes(
          column: column,
          order: order,
          search: search,
          limit: limit,
          page: page);
      final datas = List<Map<String, dynamic>>.from(jsonDecode(response));

      return Right(datas.map(PurchaseNoteSummaryModel.fromJson).toList());
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, List<DropdownEntity>>> fetchPurchaseNotesDropdown(
      {String? search, int limit = 10, int page = 1}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1800));
      final response =
          await warehouseRemoteDataSources.fetchPurchaseNotesDropdown(
        search: search,
        limit: limit,
        page: page,
      );
      final datas = List<Map<String, dynamic>>.from(jsonDecode(response));

      return Right(datas.map(DropdownEntity.fromJson).toList());
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> insertPurchaseNoteFile(
      {required InsertPurchaseNoteFileEntity purchaseNote}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1800));
      final response =
          await warehouseRemoteDataSources.insertPurchaseNoteFile(data: {});
      final data = jsonDecode(response);

      return Right(data['message']);
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> insertPurchaseNoteManual(
      {required InsertPurchaseNoteManualEntity purchaseNote}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1800));
      final response =
          await warehouseRemoteDataSources.insertPurchaseNoteManual(data: {});
      final data = jsonDecode(response);

      return Right(data['message']);
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> insertShippingFee(
      {required int price, required List<String> purchaseNoteIds}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1800));
      final response =
          await warehouseRemoteDataSources.insertShippingFee(data: {});
      final data = jsonDecode(response);

      return Right(data['message']);
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> updatePurchaseNote(
      {required InsertPurchaseNoteManualEntity purchaseNote}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1800));
      final response =
          await warehouseRemoteDataSources.updatePurchaseNote(data: {});
      final data = jsonDecode(response);

      return Right(data['message']);
    } catch (e) {
      return Left(Failure());
    }
  }
}
