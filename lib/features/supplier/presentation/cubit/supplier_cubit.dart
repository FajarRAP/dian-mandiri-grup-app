import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/supplier_detail_entity.dart';
import '../../domain/usecases/fetch_supplier_use_case.dart';
import '../../domain/usecases/fetch_suppliers_dropdown_use_case.dart';
import '../../domain/usecases/fetch_suppliers_use_case.dart';
import '../../domain/usecases/insert_supplier_use_case.dart';
import '../../domain/usecases/update_supplier_use_case.dart';

part 'supplier_state.dart';

class SupplierCubit extends Cubit<SupplierState> {
  SupplierCubit({
    required FetchSupplierUseCase fetchSupplierUseCase,
    required FetchSuppliersUseCase fetchSuppliersUseCase,
    required FetchSuppliersDropdownUseCase fetchSuppliersDropdownUseCase,
    required InsertSupplierUseCase insertSupplierUseCase,
    required UpdateSupplierUseCase updateSupplierUseCase,
  })  : _fetchSupplierUseCase = fetchSupplierUseCase,
        _fetchSuppliersUseCase = fetchSuppliersUseCase,
        _fetchSuppliersDropdownUseCase = fetchSuppliersDropdownUseCase,
        _insertSupplierUseCase = insertSupplierUseCase,
        _updateSupplierUseCase = updateSupplierUseCase,
        super(SupplierInitial());

  final FetchSupplierUseCase _fetchSupplierUseCase;
  final FetchSuppliersUseCase _fetchSuppliersUseCase;
  final FetchSuppliersDropdownUseCase _fetchSuppliersDropdownUseCase;
  final InsertSupplierUseCase _insertSupplierUseCase;
  final UpdateSupplierUseCase _updateSupplierUseCase;

  Future<void> fetchSupplierUseCase({required String supplierId}) async {
    final result = await _fetchSupplierUseCase(supplierId);
  }

  Future<void> fetchSuppliersUseCase({
    String? search,
    String column = 'name',
    String sort = 'asc',
  }) async {
    final result = await _fetchSuppliersUseCase({
      'search': search,
      'column': column,
      'sort': sort,
    });
  }

  Future<void> fetchSuppliersDropdownUseCase({
    String? search,
  }) async {
    final result = await _fetchSuppliersDropdownUseCase({
      'search': search,
    });
  }

  Future<void> insertSupplierUseCase(
      {required SupplierDetailEntity supplierDetailEntity}) async {
    final result = await _insertSupplierUseCase(supplierDetailEntity);
  }

  Future<void> updateSupplierUseCase(
      {required SupplierDetailEntity supplierDetailEntity}) async {
    final result = await _updateSupplierUseCase(supplierDetailEntity);
  }
}
