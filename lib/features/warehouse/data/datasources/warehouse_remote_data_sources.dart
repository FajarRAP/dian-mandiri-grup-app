import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

abstract class WarehouseRemoteDataSources<T> {
  Future<T> deletePurchaseNote({required String purchaseNoteId});
  Future<T> fetchPurchaseNote({required String purchaseNoteId});
  Future<T> fetchPurchaseNotes({
    String column = 'name',
    String order = 'asc',
    String? search,
    int limit = 10,
    int page = 1,
  });
  Future<T> fetchPurchaseNotesDropdown({
    String? search,
    int limit = 10,
    int page = 1,
  });
  Future<T> insertPurchaseNoteManual({required Map<String, dynamic> data});
  Future<T> insertPurchaseNoteFile({required Map<String, dynamic> data});
  Future<T> insertShippingFee({required Map<String, dynamic> data});
  Future<T> updatePurchaseNote({required Map<String, dynamic> data});
}

class WarehouseRemoteDataSourcesImpl
    extends WarehouseRemoteDataSources<Response> {
  WarehouseRemoteDataSourcesImpl({required this.dio});

  final Dio dio;
  @override
  Future<Response> deletePurchaseNote({required String purchaseNoteId}) {
    // TODO: implement deletePurchaseNote
    throw UnimplementedError();
  }

  @override
  Future<Response> fetchPurchaseNote({required String purchaseNoteId}) {
    // TODO: implement fetchPurchaseNote
    throw UnimplementedError();
  }

  @override
  Future<Response> fetchPurchaseNotes(
      {String column = 'name',
      String order = 'asc',
      String? search,
      int limit = 10,
      int page = 1}) {
    // TODO: implement fetchPurchaseNotes
    throw UnimplementedError();
  }

  @override
  Future<Response> fetchPurchaseNotesDropdown(
      {String? search, int limit = 10, int page = 1}) {
    // TODO: implement fetchPurchaseNotesDropdown
    throw UnimplementedError();
  }

  @override
  Future<Response> insertPurchaseNoteFile(
      {required Map<String, dynamic> data}) {
    // TODO: implement insertPurchaseNoteFile
    throw UnimplementedError();
  }

  @override
  Future<Response> insertPurchaseNoteManual(
      {required Map<String, dynamic> data}) {
    // TODO: implement insertPurchaseNoteManual
    throw UnimplementedError();
  }

  @override
  Future<Response> insertShippingFee({required Map<String, dynamic> data}) {
    // TODO: implement insertShippingFee
    throw UnimplementedError();
  }

  @override
  Future<Response> updatePurchaseNote({required Map<String, dynamic> data}) {
    // TODO: implement updatePurchaseNote
    throw UnimplementedError();
  }
}

class WarehouseRemoteDataSourcesMock
    extends WarehouseRemoteDataSources<String> {
  @override
  Future<String> deletePurchaseNote({required String purchaseNoteId}) async {
    return '''{"data": null, "message": "Purchase note deleted successfully"}''';
  }

  @override
  Future<String> fetchPurchaseNote({required String purchaseNoteId}) async {
    return await rootBundle.loadString('dummy_json/purchase_note.json');
  }

  @override
  Future<String> fetchPurchaseNotes(
      {String column = 'name',
      String order = 'asc',
      String? search,
      int limit = 10,
      int page = 1}) async {
    return await rootBundle.loadString('dummy_json/purchase_notes.json');
  }

  @override
  Future<String> fetchPurchaseNotesDropdown(
      {String? search, int limit = 10, int page = 1}) async {
    return await rootBundle
        .loadString('dummy_json/purchase_notes_dropdown.json');
  }

  @override
  Future<String> insertPurchaseNoteFile(
      {required Map<String, dynamic> data}) async {
    return '''{"data": null, "message": "Purchase note file inserted successfully"}''';
  }

  @override
  Future<String> insertPurchaseNoteManual(
      {required Map<String, dynamic> data}) async {
    return '''{"data": null, "message": "Purchase note manual inserted successfully"}''';
  }

  @override
  Future<String> insertShippingFee({required Map<String, dynamic> data}) async {
    return '''{"data": null, "message": "Shipping fee inserted successfully"}''';
  }

  @override
  Future<String> updatePurchaseNote(
      {required Map<String, dynamic> data}) async {
    return '''{"data": null, "message": "Purchase note updated successfully"}''';
  }
}
