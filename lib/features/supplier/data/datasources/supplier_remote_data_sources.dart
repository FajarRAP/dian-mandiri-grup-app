import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

abstract class SupplierRemoteDataSources<T> {
  Future<T> fetchSupplier({required String supplierId});
  Future<T> fetchSuppliers({
    String column = 'name',
    String order = 'asc',
    String? search,
    int limit = 10,
    int page = 1,
  });
  Future<T> fetchSuppliersDropdown({
    String? search,
    int limit = 10,
    int page = 1,
  });
  Future<T> insertSupplier({required Map<String, dynamic> data});
  Future<T> updateSupplier({required Map<String, dynamic> data});
}

class SupplierRemoteDataSourcesImpl
    implements SupplierRemoteDataSources<Response> {
  SupplierRemoteDataSourcesImpl({required this.dio});

  final Dio dio;

  @override
  Future<Response> fetchSupplier({required String supplierId}) async {
    return await dio.get('v1/supplier/$supplierId');
  }

  @override
  Future<Response> fetchSuppliers(
      {String column = 'name',
      String order = 'asc',
      String? search,
      int limit = 10,
      int page = 1}) async {
    return await dio.get(
      'v1/supplier',
      queryParameters: {
        'column': column,
        'order': order,
        'search': search,
        'limit': limit,
        'page': page,
      },
    );
  }

  @override
  Future<Response> fetchSuppliersDropdown(
      {String? search, int limit = 10, int page = 1}) async {
    return await dio.get(
      'v1/supplier/dropdown',
      queryParameters: {
        'search': search,
        'limit': limit,
        'page': page,
      },
    );
  }

  @override
  Future<Response> insertSupplier({required Map<String, dynamic> data}) async {
    return await dio.post(
      'v1/supplier',
      data: FormData.fromMap(data),
    );
  }

  @override
  Future<Response> updateSupplier({required Map<String, dynamic> data}) async {
    return await dio.put(
      'v1/supplier/${data['id']}',
      data: FormData.fromMap(data),
    );
  }
}

class SupplierRemoteDataSourcesMock
    implements SupplierRemoteDataSources<String> {
  @override
  Future<String> fetchSupplier({required String supplierId}) async {
    return await rootBundle.loadString('dummy_json/supplier.json');
  }

  @override
  Future<String> fetchSuppliers(
      {String column = 'name',
      String order = 'asc',
      String? search,
      int limit = 10,
      int page = 1}) async {
    return await rootBundle.loadString('dummy_json/suppliers.json');
  }

  @override
  Future<String> fetchSuppliersDropdown(
      {String? search, int limit = 10, int page = 1}) async {
    return await rootBundle.loadString('dummy_json/suppliers_dropdown.json');
  }

  @override
  Future<String> insertSupplier({required Map<String, dynamic> data}) async {
    return '''{"data":null, "message":"Berhasil menambahkan supplier"}''';
  }

  @override
  Future<String> updateSupplier({required Map<String, dynamic> data}) async {
    if (data['avatar'] != null) {
      // Multipart
      return '''{"data":null, "message":"Berhasil mengupdate supplier multipart"}''';
    } else {
      return '''{"data":null, "message":"Berhasil mengupdate supplier form-data"}''';
    }
  }
}
