import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/network/dio_handler_mixin.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/purchase_note_detail_entity.dart';
import '../../domain/entities/purchase_note_summary_entity.dart';
import '../../domain/usecases/delete_purchase_note_use_case.dart';
import '../../domain/usecases/fetch_purchase_note_use_case.dart';
import '../../domain/usecases/fetch_purchase_notes_dropdown_use_case.dart';
import '../../domain/usecases/fetch_purchase_notes_use_case.dart';
import '../../domain/usecases/insert_purchase_note_file_use_case.dart';
import '../../domain/usecases/create_purchase_note_use_case.dart';
import '../../domain/usecases/insert_return_cost_use_case.dart';
import '../../domain/usecases/insert_shipping_fee_use_case.dart';
import '../../domain/usecases/update_purchase_note_use_case.dart';
import '../models/purchase_note_detail_model.dart';
import '../models/purchase_note_summary_model.dart';
import '../models/warehouse_item_model.dart';

abstract interface class WarehouseRemoteDataSource {
  Future<String> deletePurchaseNote(DeletePurchaseNoteUseCaseParams params);
  Future<PurchaseNoteDetailEntity> fetchPurchaseNote(
    FetchPurchaseNoteUseCaseParams params,
  );
  Future<List<PurchaseNoteSummaryEntity>> fetchPurchaseNotes(
    FetchPurchaseNotesUseCaseParams params,
  );
  Future<List<DropdownEntity>> fetchPurchaseNotesDropdown(
    FetchPurchaseNotesDropdownUseCaseParams params,
  );
  Future<String> createPurchaseNote(CreatePurchaseNoteUseCaseParams params);
  Future<String> insertPurchaseNoteFile(
    InsertPurchaseNoteFileUseCaseParams params,
  );
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
    DeletePurchaseNoteUseCaseParams params,
  ) async {
    return await handleDioRequest<String>(() async {
      final response = await dio.delete(
        '/purchase-note/${params.purchaseNoteId}',
      );

      return response.data['message'];
    });
  }

  @override
  Future<PurchaseNoteDetailEntity> fetchPurchaseNote(
    FetchPurchaseNoteUseCaseParams params,
  ) async {
    return await handleDioRequest<PurchaseNoteDetailEntity>(() async {
      final response = await dio.get('/purchase-note/${params.purchaseNoteId}');

      return PurchaseNoteDetailModel.fromJson(response.data['data']).toEntity();
    });
  }

  @override
  Future<List<PurchaseNoteSummaryEntity>> fetchPurchaseNotes(
    FetchPurchaseNotesUseCaseParams params,
  ) async {
    return await handleDioRequest<List<PurchaseNoteSummaryEntity>>(() async {
      final response = await dio.get(
        '/purchase-note',
        queryParameters: {
          'column': params.column,
          'sort': params.sort,
          'search': params.search.query,
          'limit': params.paginate.limit,
          'page': params.paginate.page,
        },
      );

      final contents = List<JsonMap>.from(response.data['data']['content']);

      return contents
          .map((e) => PurchaseNoteSummaryModel.fromJson(e).toEntity())
          .toList();
    });
  }

  @override
  Future<List<DropdownEntity>> fetchPurchaseNotesDropdown(
    FetchPurchaseNotesDropdownUseCaseParams params,
  ) async {
    return await handleDioRequest<List<DropdownEntity>>(() async {
      final response = await dio.get(
        '/purchase-note/dropdown',
        queryParameters: {
          'search': params.search,
          'limit': params.limit,
          'page': params.page,
        },
      );

      final contents = List<JsonMap>.from(response.data['data']['content']);

      return contents.map(DropdownEntity.fromJson).toList();
    });
  }

  @override
  Future<String> insertPurchaseNoteFile(
    InsertPurchaseNoteFileUseCaseParams params,
  ) async {
    return await handleDioRequest<String>(() async {
      final response = await dio.post(
        '/purchase-note/spreadsheet',
        data: FormData.fromMap({
          'supplier_id': params.supplierId,
          'date': params.date.toUtc().toIso8601String(),
          'note': params.note,
          'receipt': await MultipartFile.fromFile(params.receipt),
          'spreadsheet': await MultipartFile.fromFile(params.file),
        }),
      );

      return response.data['message'];
    });
  }

  @override
  Future<String> createPurchaseNote(
    CreatePurchaseNoteUseCaseParams params,
  ) async {
    return await handleDioRequest<String>(() async {
      final items = params.items
          .map((item) => WarehouseItemModel.fromEntity(item).toJson())
          .toList();

      final response = await dio.post(
        '/purchase-note',
        data: FormData.fromMap({
          'supplier_id': params.supplierId,
          'date': params.date.toUtc().toIso8601String(),
          'note': params.note,
          'receipt': await MultipartFile.fromFile(params.receipt),
          'items': jsonEncode(items),
        }),
      );

      return response.data['message'];
    });
  }

  @override
  Future<String> insertReturnCost(InsertReturnCostUseCaseParams params) async {
    return await handleDioRequest<String>(() async {
      final response = await dio.patch(
        '/purchase-note/${params.purchaseNoteId}/return-cost',
        data: {'amount': params.amount},
      );

      return response.data['message'];
    });
  }

  @override
  Future<String> insertShippingFee(
    InsertShippingFeeUseCaseParams params,
  ) async {
    return await handleDioRequest<String>(() async {
      final response = await dio.post(
        '/purchase-note/shipment-price',
        data: {
          'date': DateTime.now().toUtc().toIso8601String(),
          'price': params.price,
          'receipt': params.purchaseNoteIds,
        },
      );

      return response.data['message'];
    });
  }

  @override
  Future<String> updatePurchaseNote(
    UpdatePurchaseNoteUseCaseParams params,
  ) async {
    return await handleDioRequest<String>(() async {
      final items = params.items
          .map((item) => WarehouseItemModel.fromEntity(item).toJson())
          .toList();
      final receipt = await params.receipt.toMultipartFile();

      final response = await dio.put(
        '/purchase-note/${params.purchaseNoteId}',
        data: FormData.fromMap({
          'supplier_id': params.supplierId,
          'date': params.date.toUtc().toIso8601String(),
          'note': params.note,
          'receipt': receipt,
          'items': jsonEncode(items),
        }),
      );

      return response.data['message'];
    });
  }
}
