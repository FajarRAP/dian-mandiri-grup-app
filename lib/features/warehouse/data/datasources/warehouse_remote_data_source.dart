import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/network/dio_handler_mixin.dart';
import '../../domain/entities/purchase_note_detail_entity.dart';
import '../../domain/entities/purchase_note_summary_entity.dart';
import '../../domain/usecases/fetch_purchase_notes_dropdown_use_case.dart';
import '../../domain/usecases/fetch_purchase_notes_use_case.dart';
import '../../domain/usecases/fetch_purchase_note_use_case.dart';
import '../../domain/usecases/delete_purchase_note_use_case.dart';
import '../../domain/usecases/insert_purchase_note_file_use_case.dart';
import '../../domain/usecases/insert_purchase_note_manual_use_case.dart';
import '../../domain/usecases/insert_return_cost_use_case.dart';
import '../../domain/usecases/insert_shipping_fee_use_case.dart';
import '../../domain/usecases/update_purchase_note_use_case.dart';
import '../models/purchase_note_detail_model.dart';
import '../models/purchase_note_summary_model.dart';
import '../models/warehouse_item_model.dart';

abstract interface class WarehouseRemoteDataSource {
  Future<String> deletePurchaseNote(DeletePurchaseNoteUseCaseParams params);
  Future<PurchaseNoteDetailEntity> fetchPurchaseNote(
      FetchPurchaseNoteUseCaseParams params);
  Future<List<PurchaseNoteSummaryEntity>> fetchPurchaseNotes(
      FetchPurchaseNotesUseCaseParams params);
  Future<List<DropdownEntity>> fetchPurchaseNotesDropdown(
      FetchPurchaseNotesDropdownUseCaseParams params);
  Future<String> insertPurchaseNoteManual(
      InsertPurchaseNoteManualUseCaseParams params);
  Future<String> insertPurchaseNoteFile(
      InsertPurchaseNoteFileUseCaseParams params);
  Future<String> insertReturnCost(InsertReturnCostUseCaseParams params);
  Future<String> insertShippingFee(InsertShippingFeeUseCaseParams params);
  Future<String> updatePurchaseNote(UpdatePurchaseNoteUseCaseParams params);
}

class WarehouseRemoteDataSourceImpl
    with DioHandlerMixin
    implements WarehouseRemoteDataSource {
  const WarehouseRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<String> deletePurchaseNote(
      DeletePurchaseNoteUseCaseParams params) async {
    try {
      final response =
          await dio.delete('v1/purchase-note/${params.purchaseNoteId}');

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<PurchaseNoteDetailEntity> fetchPurchaseNote(
      FetchPurchaseNoteUseCaseParams params) async {
    try {
      final response =
          await dio.get('v1/purchase-note/${params.purchaseNoteId}');

      return PurchaseNoteDetailModel.fromJson(response.data['data']).toEntity();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<PurchaseNoteSummaryEntity>> fetchPurchaseNotes(
      FetchPurchaseNotesUseCaseParams params) async {
    try {
      final response = await dio.get(
        'v1/purchase-note',
        queryParameters: {
          'column': params.column,
          'sort': params.sort,
          'search': params.search,
          'limit': params.limit,
          'page': params.page,
        },
      );

      final contents =
          List<Map<String, dynamic>>.from(response.data['data']['content']);

      return contents
          .map((e) => PurchaseNoteSummaryModel.fromJson(e).toEntity())
          .toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<DropdownEntity>> fetchPurchaseNotesDropdown(
      FetchPurchaseNotesDropdownUseCaseParams params) async {
    try {
      final response = await dio.get(
        'v1/purchase-note/dropdown',
        queryParameters: {
          'search': params.search,
          'limit': params.limit,
          'page': params.page,
        },
      );

      final contents =
          List<Map<String, dynamic>>.from(response.data['data']['content']);

      return contents.map(DropdownEntity.fromJson).toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> insertPurchaseNoteFile(
      InsertPurchaseNoteFileUseCaseParams params) async {
    try {
      final response = await dio.post(
        'v1/purchase-note/spreadsheet',
        data: FormData.fromMap({
          'supplier_id': params.supplierId,
          'date': params.date.toUtc().toIso8601String(),
          'note': params.note,
          'receipt': await MultipartFile.fromFile(params.receipt),
          'spreadsheet': await MultipartFile.fromFile(params.file),
        }),
      );

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> insertPurchaseNoteManual(
      InsertPurchaseNoteManualUseCaseParams params) async {
    try {
      final items = params.items
          .map((item) => WarehouseItemModel.fromEntity(item).toJson())
          .toList();

      final response = await dio.post(
        'v1/purchase-note',
        data: FormData.fromMap({
          'supplier_id': params.supplierId,
          'date': params.date.toUtc().toIso8601String(),
          'note': params.note,
          'receipt': await MultipartFile.fromFile(params.receipt),
          'items': jsonEncode(items),
        }),
      );

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> insertReturnCost(InsertReturnCostUseCaseParams params) async {
    try {
      final response = await dio.patch(
        'v1/purchase-note/${params.purchaseNoteId}/return-cost',
        data: {'amount': params.amount},
      );

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> insertShippingFee(
      InsertShippingFeeUseCaseParams params) async {
    try {
      final response = await dio.post(
        'v1/purchase-note/shipment-price',
        data: {
          'date': DateTime.now().toUtc().toIso8601String(),
          'price': params.price,
          'receipt': params.purchaseNoteIds,
        },
      );

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> updatePurchaseNote(
      UpdatePurchaseNoteUseCaseParams params) async {
    try {
      final items = params.items
          .map((item) => WarehouseItemModel.fromEntity(item).toJson())
          .toList();
      final receipt = params.receipt.startsWith('https://')
          ? null
          : await MultipartFile.fromFile(params.receipt);

      final response = await dio.put(
        'v1/purchase-note/${params.purchaseNoteId}',
        data: FormData.fromMap({
          'supplier_id': params.supplierId,
          'date': params.date.toUtc().toIso8601String(),
          'note': params.note,
          'receipt': receipt,
          'items': jsonEncode(items),
        }),
      );

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }
}
