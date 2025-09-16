import 'dart:convert';

import 'package:dio/dio.dart';

import '../../domain/entities/insert_purchase_note_file_entity.dart';
import '../../domain/entities/insert_purchase_note_manual_entity.dart';
import '../../domain/usecases/fetch_purchase_notes_dropdown_use_case.dart';
import '../../domain/usecases/fetch_purchase_notes_use_case.dart';
import '../../domain/usecases/insert_return_cost_use_case.dart';
import '../../domain/usecases/insert_shipping_fee_use_case.dart';
import '../../domain/usecases/update_purchase_note_use_case.dart';
import '../models/insert_purchase_note_file_model.dart';
import '../models/insert_purchase_note_manual_model.dart';

abstract class WarehouseRemoteDataSources<T> {
  Future<T> deletePurchaseNote({required String purchaseNoteId});
  Future<T> fetchPurchaseNote({required String purchaseNoteId});
  Future<T> fetchPurchaseNotes(
      {required FetchPurchaseNotesUseCaseParams params});
  Future<T> fetchPurchaseNotesDropdown(
      {required FetchPurchaseNotesDropdownUseCaseParams params});
  Future<T> insertPurchaseNoteManual(
      {required InsertPurchaseNoteManualEntity params});
  Future<T> insertPurchaseNoteFile(
      {required InsertPurchaseNoteFileEntity params});
  Future<T> insertReturnCost({required InsertReturnCostUseCaseParams params});
  Future<T> insertShippingFee({required InsertShippingFeeUseCaseParams params});
  Future<T> updatePurchaseNote(
      {required UpdatePurchaseNoteUseCaseParams params});
}

class WarehouseRemoteDataSourcesImpl
    extends WarehouseRemoteDataSources<Response> {
  WarehouseRemoteDataSourcesImpl({required this.dio});

  final Dio dio;
  @override
  Future<Response> deletePurchaseNote({required String purchaseNoteId}) async {
    return dio.delete('v1/purchase-note/$purchaseNoteId');
  }

  @override
  Future<Response> fetchPurchaseNote({required String purchaseNoteId}) async {
    return await dio.get('v1/purchase-note/$purchaseNoteId');
  }

  @override
  Future<Response> fetchPurchaseNotes(
      {required FetchPurchaseNotesUseCaseParams params}) async {
    return await dio.get(
      'v1/purchase-note',
      queryParameters: {
        'column': params.column,
        'sort': params.sort,
        'search': params.search,
        'limit': params.limit,
        'page': params.page,
      },
    );
  }

  @override
  Future<Response> fetchPurchaseNotesDropdown(
      {required FetchPurchaseNotesDropdownUseCaseParams params}) async {
    return await dio.get(
      'v1/purchase-note/dropdown',
      queryParameters: {
        'search': params.search,
        'limit': params.limit,
        'page': params.page,
      },
    );
  }

  @override
  Future<Response> insertPurchaseNoteFile(
      {required InsertPurchaseNoteFileEntity params}) async {
    final purchaseNote = InsertPurchaseNoteFileModel.fromEntity(params);
    final payload = purchaseNote.toJson();
    payload['receipt'] = await MultipartFile.fromFile(params.receipt);
    payload['spreadsheet'] = await MultipartFile.fromFile(params.file);

    return await dio.post(
      'v1/purchase-note/spreadsheet',
      data: FormData.fromMap(payload),
    );
  }

  @override
  Future<Response> insertPurchaseNoteManual(
      {required InsertPurchaseNoteManualEntity params}) async {
    final purchaseNote = InsertPurchaseNoteManualModel.fromEntity(params);
    final payload = purchaseNote.toJson();
    payload['receipt'] = await MultipartFile.fromFile(params.receipt);
    payload['items'] = jsonEncode(payload['items']);

    return await dio.post(
      'v1/purchase-note',
      data: FormData.fromMap(payload),
    );
  }

  @override
  Future<Response> insertReturnCost(
      {required InsertReturnCostUseCaseParams params}) async {
    return await dio.patch(
      'v1/purchase-note/${params.purchaseNoteId}/return-cost',
      data: {'amount': params.amount},
    );
  }

  @override
  Future<Response> insertShippingFee(
      {required InsertShippingFeeUseCaseParams params}) async {
    return dio.post(
      'v1/purchase-note/shipment-price',
      data: {
        'date': DateTime.now().toUtc().toIso8601String(),
        'price': params.price,
        'receipt': params.purchaseNoteIds,
      },
    );
  }

  @override
  Future<Response> updatePurchaseNote(
      {required UpdatePurchaseNoteUseCaseParams params}) async {
    final purchaseNote =
        InsertPurchaseNoteManualModel.fromEntity(params.purchaseNote);
    final payload = purchaseNote.toJson();

    if (!purchaseNote.receipt.startsWith('https://')) {
      payload['receipt'] = await MultipartFile.fromFile(purchaseNote.receipt);
    }
    payload['items'] = jsonEncode(payload['items']);

    return await dio.put(
      'v1/purchase-note/${params.purchaseNoteId}',
      data: FormData.fromMap(payload),
    );
  }
}
